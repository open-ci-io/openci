/* eslint-disable @typescript-eslint/no-explicit-any */
import { type Context, Probot } from "probot";
import { v4 as uuidv4 } from "uuid";
import { getWorkflowQuerySnapshot } from "../workflow/get_workflow_query_snapshot.js";
import { createChecks } from "./create_checks.js";
import { buildJobsCollectionName } from "../firestore_path.js";
import { firestore } from "../index.js";
import { onRequest } from "firebase-functions/https";
import {
	type BuildJob,
	type OpenCIGithub,
	OpenCIGitHubChecksStatus,
} from "../models/BuildJob.js";
import { Webhooks } from "@octokit/webhooks";

export const githubApp = onRequest(
	{ secrets: ["APP_ID", "PRIVATE_KEY", "GITHUB_WEBHOOK_SECRET"] },
	async (request, response) => {
		const secret = process.env.GITHUB_WEBHOOK_SECRET;
		if (!secret) {
			response.status(500).send("Webhook secret is not configured");
			return;
		}

		const webhooks = new Webhooks({ secret });

		try {
			const signature = request.get("x-hub-signature-256") as string;
			const rawBody = JSON.stringify(request.body);
			const isValid = await webhooks.verify(rawBody, signature);
			if (isValid === false) {
				console.log("Webhook signature verification failed");
				response.status(401).send("Webhook signature verification failed");
				return;
			}
		} catch (error) {
			console.error("Webhook signature verification failed:", error);
			response.status(401).send("Webhook signature verification failed");
			return;
		}

		const name =
			// biome-ignore lint/suspicious/noExplicitAny: <explanation>
			request.get("x-github-event") || (request.get("X-GitHub-Event") as any);
		const id =
			request.get("x-github-delivery") ||
			// biome-ignore lint/suspicious/noExplicitAny: <explanation>
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
	},
);

const appFunction = async (app: Probot) => {
	app.on(
		[
			"pull_request.opened",
			"pull_request.reopened",
			"pull_request.synchronize",
			// For debugging purposes
			// "pull_request.edited",
			"push",
			"check_run.rerequested",
		],
		async (
			context: Context<"pull_request"> | Context<"push"> | Context<"check_run">,
		) => {
			if (context.name === "check_run") {
				const checkRunContext = context as Context<"check_run">;
				const _payload = checkRunContext.payload;
				const checkRunId = _payload.check_run.id;

				const checkRun = await firestore
					.collection(buildJobsCollectionName)
					.where("github.checkRunId", "==", checkRunId)
					.get();

				if (checkRun.docs.length === 0) {
					console.log("Check run not found");
					return;
				}

				const buildJob = checkRun.docs[0].data();
				await firestore
					.collection(buildJobsCollectionName)
					.doc(buildJob.id)
					.update({
						buildStatus: OpenCIGitHubChecksStatus.QUEUED,
					});

				return;
			}

			if (context.name === "pull_request") {
				const pullRequestContext = context as Context<"pull_request">;
				const _payload = pullRequestContext.payload;

				const pullRequest = _payload.pull_request;
				const installation = _payload.installation;
				if (installation == null) {
					throw new Error("installation is null, please check it.");
				}
				const githubRepositoryUrl = pullRequest.base.repo.html_url;
				const baseBranch = pullRequest.base.ref;
				const currentBranch = pullRequest.head.ref;

				const workflowQuerySnapshot = await getWorkflowQuerySnapshot(
					githubRepositoryUrl,
					"pullRequest",
					firestore,
				);

				for (const workflowsDocs of workflowQuerySnapshot.docs) {
					const workflowData = workflowsDocs.data();
					const { github, name } = workflowData;
					const branchPattern = github.branchPattern;
					let condition = false;

					if (github.baseBranch === baseBranch) {
						if (branchPattern == null) {
							condition = true;
						} else if (branchPattern != null) {
							if (currentBranch.includes(branchPattern)) {
								condition = true;
							}
						}
					}

					if (condition) {
						const buildBranch = pullRequest.head.ref;

						const _checks = await createChecks(pullRequestContext, name);

						const appId = process.env.APP_ID;
						if (appId == null) {
							throw new Error("appId is null, please check it.");
						}

						const github: OpenCIGithub = {
							repositoryUrl: githubRepositoryUrl,
							owner: context.payload.repository.owner.login,
							repositoryName: context.payload.repository.name,
							installationId: installation.id,
							appId: Number(appId),
							checkRunId: _checks.data.id,
							baseBranch: baseBranch,
							buildBranch: buildBranch,
						};
						const documentId = uuidv4();

						const buildJob: BuildJob = {
							buildStatus: OpenCIGitHubChecksStatus.QUEUED,
							github: github,
							id: documentId,
							workflowId: workflowsDocs.id,
							createdAt: Math.floor(Date.now() / 1000),
						};

						await firestore
							.collection(buildJobsCollectionName)
							.doc(buildJob.id)
							.set(buildJob);
					}
				}
			} else if (context.name === "push") {
				const pushContext = context as Context<"push">;
				const _payload = pushContext.payload;

				const installation = _payload.installation;
				if (installation == null) {
					throw new Error("installation is undefined, please check it.");
				}

				const githubRepositoryUrl = _payload.repository.html_url;
				const baseBranch = _payload.ref.replace("refs/heads/", "");

				const workflowQuerySnapshot = await getWorkflowQuerySnapshot(
					githubRepositoryUrl,
					"push",
					firestore,
				);

				for (const workflowsDocs of workflowQuerySnapshot.docs) {
					const workflowData = workflowsDocs.data();
					const { github, name } = workflowData;
					const branchPattern = github.branchPattern;
					let condition = false;

					if (github.baseBranch === baseBranch) {
						if (branchPattern == null) {
							condition = true;
						} else if (branchPattern != null) {
							if (branchPattern.includes(branchPattern)) {
								condition = true;
							}
						}
					}

					if (condition) {
						const _checks = await createChecks(pushContext, name);

						const appId = process.env.APP_ID;
						if (appId == null) {
							throw new Error("appId is null, please check it.");
						}

						const github: OpenCIGithub = {
							repositoryUrl: githubRepositoryUrl,
							owner: context.payload.repository.owner.login,
							repositoryName: context.payload.repository.name,
							installationId: installation.id,
							appId: Number(appId),
							checkRunId: _checks.data.id,
							baseBranch: baseBranch,
							buildBranch: baseBranch,
						};
						const documentId = uuidv4();

						const buildJob: BuildJob = {
							buildStatus: OpenCIGitHubChecksStatus.QUEUED,
							github: github,
							id: documentId,
							workflowId: workflowsDocs.id,
							createdAt: Math.floor(Date.now() / 1000),
						};

						await firestore
							.collection(buildJobsCollectionName)
							.doc(buildJob.id)
							.set(buildJob);
					}
				}
			}
		},
	);
};
