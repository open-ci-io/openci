import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { Octokit } from "@octokit/rest";
import { buildJobsCollectionName } from "../firestore_path.js";
import {
	type OpenCIGithub,
	OpenCIGitHubChecksStatus,
} from "../models/BuildJob.js";
import { getGitHubInstallationToken } from "./get_github_installation_token.js";

export const updateGitHubCheckStatus = onDocumentUpdated(
	{
		document: `${buildJobsCollectionName}/{buildJobId}`,
		secrets: ["APP_ID", "PRIVATE_KEY", "GITHUB_WEBHOOK_SECRET"],
	},
	async (event) => {
		const beforeData = event.data?.before.data();
		const afterData = event.data?.after.data();

		if (!beforeData || !afterData) {
			console.log("No before or after data");
			return;
		}

		const appId = process.env.APP_ID;
		const privateKey = process.env.PRIVATE_KEY;

		if (!appId || !privateKey) {
			console.error("Missing appId or privateKey");
			return;
		}

		const github = afterData.github as OpenCIGithub;
		const token = await getGitHubInstallationToken(
			github.installationId,
			appId,
			privateKey,
		);
		const octokit = new Octokit({ auth: token });

		if (
			beforeData.buildStatus === OpenCIGitHubChecksStatus.QUEUED &&
			afterData.buildStatus === OpenCIGitHubChecksStatus.IN_PROGRESS
		) {
			await setGitHubCheckStatusToInProgress(octokit, github);
		} else if (
			beforeData.buildStatus === OpenCIGitHubChecksStatus.IN_PROGRESS &&
			afterData.buildStatus === OpenCIGitHubChecksStatus.SUCCESS
		) {
			await setGitHubCheckStatusToCompleted(octokit, github, "success");
		} else if (
			beforeData.buildStatus === OpenCIGitHubChecksStatus.IN_PROGRESS &&
			afterData.buildStatus === OpenCIGitHubChecksStatus.FAILURE
		) {
			await setGitHubCheckStatusToCompleted(octokit, github, "failure");
		} else {
			console.log("No status change");
		}
	},
);

async function setGitHubCheckStatusToInProgress(
	octokit: Octokit,
	github: OpenCIGithub,
) {
	await octokit.checks.update({
		owner: github.owner,
		repo: github.repositoryName,
		check_run_id: github.checkRunId,
		status: "in_progress",
		started_at: new Date().toISOString(),
	});
}

async function setGitHubCheckStatusToCompleted(
	octokit: Octokit,
	github: OpenCIGithub,
	conclusion: "success" | "failure",
) {
	await octokit.checks.update({
		owner: github.owner,
		repo: github.repositoryName,
		check_run_id: github.checkRunId,
		status: "completed",
		conclusion: conclusion,
	});
}
