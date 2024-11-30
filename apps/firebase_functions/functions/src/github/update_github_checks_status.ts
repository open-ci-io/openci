import { onDocumentUpdated } from "firebase-functions/firestore";
import { Octokit } from "@octokit/rest";
import { getGitHubInstallationTokenUrl } from "../constants/urls.js";
import { buildJobsCollectionName } from "../firestore_path.js";
import {
	type OpenCIGithub,
	OpenCIGitHubChecksStatus,
} from "../models/BuildJob.js";
import https from "axios";

export const updateGitHubCheckStatus = onDocumentUpdated(
	`${buildJobsCollectionName}/{buildJobId}`,
	async (event) => {
		const beforeData = event.data?.before.data();
		const afterData = event.data?.after.data();

		if (!beforeData || !afterData) {
			console.log("No before or after data");
			return;
		}

		const github = afterData.github as OpenCIGithub;
		const token = await _getGitHubInstallationToken(github.installationId);
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

async function _getGitHubInstallationToken(installationId: number) {
	const response = await https.post(getGitHubInstallationTokenUrl, {
		installationId: installationId,
	});
	return response.data.installationToken;
}
