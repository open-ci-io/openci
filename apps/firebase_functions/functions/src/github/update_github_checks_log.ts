import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { Octokit } from "@octokit/rest";
import { buildJobsCollectionName } from "../firestore_path.js";
import type { OpenCIGithub } from "../models/BuildJob.js";
import { getGitHubInstallationToken } from "./get_github_installation_token.js";

export const updateGitHubChecksLog = onDocumentUpdated(
	{
		document: `${buildJobsCollectionName}/{buildJobId}/logs/{logId}`,
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

		await setGitHubCheckStatusToInProgress(octokit, github);
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
		output: {
			title: "Updated Build Results",
			summary: "Build progress update",
			text: "sample logs",
		},
	});
}
