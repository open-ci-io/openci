/* eslint-disable @typescript-eslint/no-explicit-any */
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { githubApp } from "./github/github_app.js";
import { updateGitHubCheckStatus } from "./github/update_github_checks_status.js";
import { updateGitHubChecksLog } from "./github/update_github_checks_log.js";
import { onObjectFinalized } from "firebase-functions/v2/storage";
import type { OpenCIGithub } from "./models/BuildJob.js";
import { getGitHubInstallationToken } from "./github/get_github_installation_token.js";
import { Octokit } from "@octokit/rest";
import { getStorage } from "firebase-admin/storage";

const firebaseApp = initializeApp();
export const firestore = getFirestore(firebaseApp);
const storage = getStorage(firebaseApp);

export const githubAppFunction = githubApp;
export const updateGitHubCheckStatusFunction = updateGitHubCheckStatus;
export const updateGitHubChecksLogFunction = updateGitHubChecksLog;

export const generateThumbnail = onObjectFinalized(
	{
		region: "asia-northeast1",
		secrets: ["APP_ID", "PRIVATE_KEY", "GITHUB_WEBHOOK_SECRET"],
	},
	async (event) => {
		console.log(`event.source: ${event.source}`);
		console.log(`event.data: ${event.data}`);
		console.log(`event.data.bucket: ${event.data.bucket}`);
		console.log(`event.data.name: ${event.data.name}`);
		console.log(`event.data.contentType: ${event.data.contentType}`);

		const bucket = storage.bucket(event.data.bucket);
		const file = bucket.file(event.data.name);

		const [content] = await file.download();
		const logs = content.toString("utf-8");

		const jobId = event.data.name.split("/")[1];
		const docs = await firestore.collection("build_jobs_v3").doc(jobId).get();
		const data = docs.data();
		const openciGitHub = data?.github as OpenCIGithub | null;
		console.log(`openciGitHub: ${openciGitHub}`);

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

		await setGitHubCheckStatusToInProgress(octokit, openciGitHub, logs);
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
