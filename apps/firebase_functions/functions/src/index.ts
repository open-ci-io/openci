/* eslint-disable @typescript-eslint/no-explicit-any */
import { onRequest } from "firebase-functions/v2/https";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { Context, Probot } from "probot";
import { initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { createAppAuth } from "@octokit/auth-app";
import { Octokit } from "@octokit/rest";
import { v4 as uuidv4 } from "uuid";
import * as process from "node:process";
import { BuildModel } from "./models/BuildModel.js";

const jobsCollectionName = "jobs_v3";
const workflowCollectionName = "workflows_v1";

const app = initializeApp();
const firestore = getFirestore(app);

export const getGitHubInstallationToken = onRequest(async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).send("Method Not Allowed");
    return;
  }

  const { appId, privateKey, installationId } = req.body;

  if (!appId || !privateKey || !installationId) {
    res.status(400).send("Missing required parameters");
    return;
  }

  const appOctokit = new Octokit({
    authStrategy: createAppAuth,
    auth: {
      appId: appId,
      privateKey: privateKey,
      installationId: installationId,
    },
  });

  try {
    const { data } = await appOctokit.rest.apps.createInstallationAccessToken({
      installation_id: installationId,
    });

    res.status(200).json({ installationToken: data.token });
  } catch (error) {
    console.error("Error creating installation token:", error);
    res.status(500).send("Internal Server Error");
  }
});

export const updateGitHubCheckStateFunction = onDocumentUpdated(
  `${jobsCollectionName}/{documentId}`,
  async (event) => {
    if (event.data == undefined) {
      throw new Error("Build model is undefined");
    }
    const buildId = event.params.documentId;
    const oldStatus = event.data.before.data().buildStatus;
    const newStatus = event.data.after.data().buildStatus;
    const { platform, workflowId, github, githubChecks } = event.data.after
      .data();

    const octokit = new Octokit({
      authStrategy: createAppAuth,
      auth: {
        appId: process.env.APP_ID,
        privateKey: process.env.PRIVATE_KEY,
        installationId: github.installationId,
      },
    });

    if (oldStatus.failure !== newStatus.failure) {
      if (newStatus.failure) {
        const response = await octokit.checks.update({
          check_run_id: githubChecks.checkRunId,
          owner: github.owner,
          status: "completed",
          conclusion: "failure",
          repo: github.repositoryName,
        });
        console.log("Check status updated successfully:");
        console.log(response.data);
        console.log(`Build ${buildId}: Failure status changed to true`);
      }
    }
    if (oldStatus.processing !== newStatus.processing) {
      if (newStatus.processing) {
        const response = await octokit.checks.update({
          check_run_id: githubChecks.checkRunId,
          status: "in_progress",
          owner: github.owner,
          repo: github.repositoryName,
        });
        console.log("Check status updated successfully:");
        console.log(response.data);
        console.log(`Build ${buildId}: Processing status changed to true`);
      }
    }

    if (oldStatus.success !== newStatus.success) {
      if (newStatus.success) {
        const response = await octokit.checks.update({
          check_run_id: githubChecks.checkRunId,
          owner: github.owner,
          status: "completed",
          conclusion: "success",
          repo: github.repositoryName,
        });
        console.log("Check status updated successfully:");
        console.log(response.data);
        console.log(`Build ${buildId}: Success status changed to true`);
        console.log("workflowId", workflowId);

        const workflowQuerySnapshot = await firestore
          .collection(workflowCollectionName)
          .where("documentId", "==", workflowId)
          .get();

        const workflowQueryDocumentSnapshot = workflowQuerySnapshot.docs[0];

        console.log(
          "workflowQueryDocumentSnapshot",
          workflowQueryDocumentSnapshot.exists,
        );
        const workflowData = workflowQueryDocumentSnapshot.data();

        const organizationId = workflowData.organizationId;

        const organizationQuerySnapshot = await firestore
          .collection("organizations")
          .where("documentId", "==", organizationId)
          .get();

        const organizationData = organizationQuerySnapshot.docs[0].data();

        let retrievedBuildNumber = 0;

        const { buildNumber } = organizationData;

        if (platform == "ios") {
          retrievedBuildNumber = buildNumber.ios;
        } else if (platform == "android") {
          retrievedBuildNumber = buildNumber.android;
        }

        await addIssueComment(
          octokit,
          retrievedBuildNumber,
          workflowData.workflowName,
          githubChecks.issueNumber,
          github.owner,
          github.repositoryName,
        );

        const buildNumberField = `buildNumber.${platform}`;
        await firestore
          .collection("organizations")
          .doc(organizationId)
          .update({ [buildNumberField]: retrievedBuildNumber + 1 });
      }
    }
  },
);

export const githubApps = onRequest(async (request, response) => {
  const name = request.get("x-github-event") ||
    (request.get("X-GitHub-Event") as any);
  const id = request.get("x-github-delivery") ||
    (request.get("X-GitHub-Delivery") as any);

  const probot = new Probot({
    appId: process.env.APP_ID,
    privateKey: process.env.PRIVATE_KEY,
  });

  await probot.load(appFunction);

  await probot.receive({
    name,
    id,
    payload: request.body,
  });

  response.send({
    statusCode: 200,
    body: JSON.stringify({
      message: "Executed",
    }),
  });
});

const appFunction = async (app: Probot) => {
  app.on(
    [
      "pull_request.opened",
      "pull_request.reopened",
      "pull_request.synchronize",
      // For debugging purposes
      "pull_request.edited",
      "push",
    ],
    async (context: Context<"pull_request"> | Context<"push">) => {
      if (context.name == "push") {
        const pushContext = context as Context<"push">;
        const branchName = pushContext.payload.ref.replace("refs/heads/", "");
        console.log("branchName", branchName);
        const _payload = pushContext.payload;

        const repositoryUrl = _payload.repository.html_url;
        const installationId = _payload.installation;

        if (installationId == undefined) {
          throw new Error("installationId is null, please check it.");
        }
        if (branchName == undefined) {
          throw new Error("branchName is null, please check it.");
        }

        const workflowQuerySnapshot = await getWorkflowQuerySnapshot(
          repositoryUrl,
          "push",
        );

        for (const workflowsDocs of workflowQuerySnapshot.docs) {
          const workflowData = workflowsDocs.data();
          const { platform, workflowName, github } = workflowData;

          if (github.baseBranch !== branchName) {
            console.log("Branch name does not match, skipping.");
            continue;
          }

          const _checks = await createChecks(pushContext, workflowName);

          const buildStatus = {
            processing: false,
            failure: false,
            success: false,
          };
          const branch = {
            baseBranch: branchName,
            buildBranch: branchName,
          };

          const githubChecks = {
            issueNumber: null,
            checkRunId: _checks.data.id,
          };

          const appId = process.env.APP_ID;
          if (appId == undefined) {
            throw new Error("appId is null, please check it.");
          }

          const _github = {
            repositoryUrl: repositoryUrl,
            owner: context.payload.repository.owner.login,
            repositoryName: context.payload.repository.name,
            installationId: installationId.id,
            appId: Number(appId),
          };
          const createdAt = FieldValue.serverTimestamp();
          const documentId = uuidv4();
          const job = new BuildModel(
            buildStatus,
            branch,
            githubChecks,
            _github,
            createdAt,
            documentId,
            platform,
            workflowsDocs.id,
          );
          await firestore
            .collection(jobsCollectionName)
            .doc(job.documentId)
            .set(job.toJson());
        }
      } else if (context.name == "pull_request") {
        const pullRequestContext = context as Context<"pull_request">;
        const _payload = pullRequestContext.payload;

        const pullRequest = _payload.pull_request;
        const installationId = _payload.installation;
        const githubRepositoryUrl = pullRequest.base.repo.html_url;
        const baseBranch = pullRequest.base.ref;
        const currentBranch = pullRequest.head.ref;
        if (installationId == null) {
          throw new Error("installationId is null, please check it.");
        }

        const workflowQuerySnapshot = await getWorkflowQuerySnapshot(
          githubRepositoryUrl,
          "pullRequest",
        );

        for (const workflowsDocs of workflowQuerySnapshot.docs) {
          const workflowData = workflowsDocs.data();
          const { github, platform, workflowName } = workflowData;
          const branchPattern = github.branchPattern;
          let condition = false;

          if (github.baseBranch == baseBranch) {
            if (branchPattern == undefined) {
              condition = true;
            } else if (branchPattern != undefined) {
              if (currentBranch.includes(branchPattern)) {
                condition = true;
              }
            }
          }

          if (condition) {
            const buildBranch = pullRequest.head.ref;

            const _checks = await createChecks(
              pullRequestContext,
              workflowName,
            );

            const buildStatus = {
              processing: false,
              failure: false,
              success: false,
            };
            const branch = {
              baseBranch: baseBranch,
              buildBranch: buildBranch,
            };
            const githubChecks = {
              issueNumber: pullRequestContext.payload.pull_request.number,
              checkRunId: _checks.data.id,
            };

            const appId = process.env.APP_ID;
            if (appId == undefined) {
              throw new Error("appId is null, please check it.");
            }

            const github = {
              repositoryUrl: githubRepositoryUrl,
              owner: context.payload.repository.owner.login,
              repositoryName: context.payload.repository.name,
              installationId: installationId.id,
              appId: Number(appId),
            };
            const createdAt = FieldValue.serverTimestamp();
            const documentId = uuidv4();
            const job = new BuildModel(
              buildStatus,
              branch,
              githubChecks,
              github,
              createdAt,
              documentId,
              platform,
              workflowsDocs.id,
            );
            await firestore
              .collection(jobsCollectionName)
              .doc(job.documentId)
              .set(job.toJson());
          }
        }
      }
    },
  );
};

async function addIssueComment(
  octokit: Octokit,
  buildNumber: number | null,
  workflowName: string,
  issueNumber: number,
  owner: string,
  repositoryName: string,
): Promise<void> {
  if (buildNumber == null) {
    console.log("Build number is null, skipping adding issue comment.");
    return;
  }
  const _issueCommentBody = issueCommentBody(workflowName, buildNumber);

  try {
    const { data: comments } = await octokit.rest.issues.listComments({
      owner: owner,
      repo: repositoryName,
      issue_number: issueNumber,
    });

    const existingComment = comments.find((comment) =>
      comment.body?.startsWith(issueCommentBodyBase(workflowName))
    );

    if (existingComment) {
      await octokit.rest.issues.updateComment({
        owner: owner,
        repo: repositoryName,
        comment_id: existingComment.id,
        body: _issueCommentBody,
      });
    } else {
      await octokit.rest.issues.createComment({
        owner: owner,
        repo: repositoryName,
        issue_number: issueNumber,
        body: _issueCommentBody,
      });
    }
  } catch (error) {
    console.error("Error adding or updating issue comment:", error);
  }
}

function issueCommentBody(workflowName: string, buildNumber: number) {
  return `${issueCommentBodyBase(workflowName)} ${buildNumber}`;
}

function issueCommentBodyBase(workflowName: string) {
  return `${workflowName}: Build Number:`;
}

async function getWorkflowQuerySnapshot(
  githubRepositoryUrl: string,
  triggerType: string,
) {
  console.log("githubRepositoryUrl", githubRepositoryUrl);
  console.log("triggerType", triggerType);
  const workflowQuerySnapshot = await firestore
    .collection(workflowCollectionName)
    .where("github.repositoryUrl", "==", githubRepositoryUrl)
    .where("github.triggerType", "==", triggerType)
    .get();

  if (workflowQuerySnapshot.empty) {
    throw new Error("OpenCI could not find the repository in our database.");
  }
  return workflowQuerySnapshot;
}

async function createChecks(
  context: Context<"pull_request"> | Context<"push">,
  name: string,
) {
  let headSha = "";
  if (context.name == "pull_request") {
    const _context = context as Context<"pull_request">;
    headSha = _context.payload.pull_request.head.sha;
  } else if (context.name == "push") {
    const _context = context as Context<"push">;
    headSha = _context.payload.after;
  }
  try {
    return await context.octokit.checks.create({
      owner: context.payload.repository.owner.login,
      repo: context.payload.repository.name,
      head_sha: headSha,
      name: name,
      status: "queued",
    });
  } catch (error) {
    console.error("Failed to create check suite:", error);
    throw error;
  }
}
