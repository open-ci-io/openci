import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { Octokit } from "@octokit/rest";
import { buildJobsCollectionName } from "../firestore_path.js";
import type { OpenCIGithub } from "../models/BuildJob.js";
import { getGitHubInstallationToken } from "./get_github_installation_token.js";
import { firestore } from "../index.js";
import type { CommandLog } from "../models/CommandLog.js";
import isSecret from "is-secret";

export const updateGitHubChecksLog = onDocumentWritten(
	{
		document: `${buildJobsCollectionName}/{buildJobId}/logs/{logId}`,
		secrets: ["APP_ID", "PRIVATE_KEY", "GITHUB_WEBHOOK_SECRET"],
	},
	async (event) => {
		const buildJobId = event.params.buildJobId;

		const document = event.data?.after.data();

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

		const oldLog = await getCheckRunOutput(octokit, openciGitHub);
		const newLog = formatLog(document as CommandLog);

		const combinedLogs = [oldLog, newLog].filter(Boolean).join("\n\n");

		await setGitHubCheckStatusToInProgress(octokit, openciGitHub, combinedLogs);
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

function formatLog(log: CommandLog): string {
	console.log("log", log);

	const normalizedTimestamp = Math.floor(Number(log.createdAt) / 1000);
	const timestamp = new Date(normalizedTimestamp * 1000).toISOString();
	console.log("timestamp + log", timestamp + log);
	const exitCodeStatus = log.exitCode === 0 ? "SUCCESS" : "FAILED";

	const maskSecret = (value: string) => {
		const maskedGitHubUrl = value.replace(
			/(https:\/\/)[^@]*(@github\.com)/g,
			"$1[REDACTED]$2",
		);
		const maskedBase64 = maskedGitHubUrl.replace(
			/[A-Za-z0-9+/]{50,}={0,2}/g,
			"[BASE64_REDACTED]",
		);
		const maskedFirebaseToken = maskedBase64.replace(
			/1\/\/[A-Za-z0-9_-]+/g,
			"[FIREBASE_TOKEN_REDACTED]",
		);
		return isSecret.value(maskedFirebaseToken)
			? "********"
			: maskedFirebaseToken;
	};

	const maskedData = {
		command: maskSecret(log.command),
		stdout: maskSecret(log.logStdout),
		stderr: maskSecret(log.logStderr),
	};

	const result = [
		`[${timestamp}] Command: ${maskedData.command}`,
		`Exit Code: ${log.exitCode} (${exitCodeStatus})`,
		"stdout:",
		maskedData.stdout,
		"stderr:",
		maskedData.stderr,
		"---",
	].join("\n");

	console.log("result", result);

	return result;
}

export function formatLogs(logs: CommandLog[]): string {
	console.log("logs", logs);
	return logs
		.map((log) => {
			return formatLog(log);
		})
		.join("\n\n");
}

async function getCheckRunOutput(
	octokit: Octokit,
	github: OpenCIGithub,
): Promise<string | null> {
	try {
		const response = await octokit.checks.get({
			owner: github.owner,
			repo: github.repositoryName,
			check_run_id: github.checkRunId,
		});

		return response.data.output?.text ?? null;
	} catch (error) {
		console.error("Failed to get check run output:", error);
		return null;
	}
}
