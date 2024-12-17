import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { Octokit } from "@octokit/rest";
import { buildJobsCollectionName } from "../firestore_path.js";
import type { OpenCIGithub } from "../models/BuildJob.js";
import { getGitHubInstallationToken } from "./get_github_installation_token.js";
import { firestore } from "../index.js";
import type { CommandLog } from "../models/CommandLog.js";

export const updateGitHubChecksLog = onDocumentWritten(
	{
		document: `${buildJobsCollectionName}/{buildJobId}/logs/{logId}`,
		secrets: ["APP_ID", "PRIVATE_KEY", "GITHUB_WEBHOOK_SECRET"],
	},
	async (event) => {
		const buildJobId = event.params.buildJobId;

		const document = event.data?.after.data();

		console.log(`document: ${document}`);

		if (!document) {
			console.log("No document data found");
			return;
		}

		const buildJobDocumentSnapshot = await firestore
			.collection(buildJobsCollectionName)
			.doc(buildJobId)
			.get();

		if (!buildJobDocumentSnapshot.exists) {
			console.log("No build job document snapshot");
			return;
		}

		const openciGitHub = buildJobDocumentSnapshot.data()
			?.github as OpenCIGithub | null;

		if (openciGitHub == null) {
			console.log("No openciGitHub found");
			return;
		}

		const installationId = openciGitHub.installationId;

		const appId = process.env.APP_ID;
		const privateKey = process.env.PRIVATE_KEY;

		if (!appId || !privateKey) {
			console.error("Missing appId or privateKey");
			return;
		}

		const token = await getGitHubInstallationToken(
			installationId,
			appId,
			privateKey,
		);
		const octokit = new Octokit({ auth: token });

		await setGitHubCheckStatusToInProgress(
			octokit,
			openciGitHub,
			formatLogs(document.logs),
		);
	},
);

async function setGitHubCheckStatusToInProgress(
	octokit: Octokit,
	github: OpenCIGithub,
	logs: string,
) {
	await octokit.checks.update({
		owner: github.owner,
		repo: github.repositoryName,
		check_run_id: github.checkRunId,
		output: {
			title: "Updated Build Results",
			summary: "Build progress update",
			text: logs,
		},
	});
}

export function formatLogs(logs: CommandLog[]): string {
	return logs
		.map((log) => {
			const timestamp = log.createdAt.toDate().toISOString();
			const exitCodeStatus = log.exitCode === 0 ? "SUCCESS" : "FAILED";

			return [
				`[${timestamp}] Command: ${log.command}`,
				`Exit Code: ${log.exitCode} (${exitCodeStatus})`,
				"stdout:",
				log.logStdout,
				"stderr:",
				log.logStderr,
				"---",
			].join("\n");
		})
		.join("\n\n");
}
