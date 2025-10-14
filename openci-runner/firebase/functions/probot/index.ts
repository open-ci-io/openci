import { setTimeout } from "node:timers/promises";
import { Octokit } from "@octokit/rest";
import { NodeSSH } from "node-ssh";
import type { ApplicationFunction, Context, Probot } from "probot";
import { getJitConfig, isJobRequired } from "./github.js";
import {
	createServer,
	deleteServer,
	getServerStatusById,
	initRunner,
	type OctokitToken,
} from "./hetzner.js";

const workflowJobQueued = "workflow_job.queued";
const workflowJobCompleted = "workflow_job.completed";

export enum Env {
	dev = "dev",
	prod = "prod",
}

export const appFn: ApplicationFunction = (app: Probot) => {
	app.log.info("Yay! The app was loaded!");

	// This is for debugging.
	app.on("issues.opened", async (context: Context) => {
		return context.octokit.rest.issues.createComment(
			context.issue({ body: "Hello, World!" }),
		);
	});

	app.on(workflowJobQueued, async (context) => {
		console.info(`${workflowJobQueued} has started`);

		if (
			!process.env.HETZNER_API_KEY ||
			!process.env.HETZNER_SSH_PRIVATE_KEY ||
			!process.env.HETZNER_SSH_PASSPHRASE ||
			!process.env.ENV
		) {
			throw new Error("Required environment variables are missing");
		}
		var env: Env = Env[process.env.ENV];
		const { token } = (await context.octokit.auth({
			type: "installation",
		})) as OctokitToken;

		if (!isJobRequired(context)) {
			console.log("This workflow job doesn't use openci runner");
			return;
		}

		const repository = context.payload.repository;
		const owner = repository.owner.login;
		const repo = repository.name;

		const hetznerResponse = await createServer(
			process.env.HETZNER_API_KEY,
			env,
		);
		console.info("Runner server has been created");
		while (true) {
			const status = await getServerStatusById(
				hetznerResponse.serverId,
				process.env.HETZNER_API_KEY,
			);
			if (status === "running") {
				console.info("Runner server is now running!");
				break;
			} else {
				console.info("Waiting for the server init. Will try again in 1 second");
				await setTimeout(1000);
			}
		}
		const ssh = new NodeSSH();
		const maxRetry = 10;
		let retryCount = 0;
		while (retryCount < maxRetry) {
			console.info("retry:", retryCount);
			try {
				const sshResult = await ssh.connect({
					host: hetznerResponse.ipv4,
					passphrase: process.env.HETZNER_SSH_PASSPHRASE,
					privateKey: process.env.HETZNER_SSH_PRIVATE_KEY,
					username: "root",
				});

				const octokit = new Octokit({
					auth: token,
				});
				const encodedJitConfig = await getJitConfig(
					octokit,
					owner,
					repo,
					hetznerResponse.serverId,
					env,
				);
				await sshResult.execCommand("apt install tmux");
				await sshResult.execCommand(initRunner(encodedJitConfig));
				console.info("Successfully start openci runner");
				break;
			} catch (e) {
				console.log("error, will try again in 1 second", e);
				await setTimeout(1000);
				retryCount++;
			}
		}

		if (retryCount >= maxRetry) {
			throw new Error(
				`Failed to establish SSH connection. I did try my best. ${maxRetry}`,
			);
		}
		console.info(`${workflowJobQueued} has finished`);
		return;
	});

	app.on(workflowJobCompleted, async (context) => {
		console.info(`${workflowJobCompleted} event started`);
		if (!process.env.HETZNER_API_KEY) {
			throw new Error("Required environment variables are missing");
		}
		if (!isJobRequired(context)) {
			console.log("This workflow job doesn't use openci runner. Stopping.");
			return;
		}
		const runnerName = context.payload.workflow_job.runner_name;
		if (runnerName == null) {
			console.log("This runner is GitHub hosted one. Stopping");
			return;
		}
		const defaultRunnerName = "OpenCI ランナー ";
		const runnerId = runnerName?.replace(defaultRunnerName, "");
		console.info("runner id", runnerId);

		try {
			await deleteServer(runnerId, process.env.HETZNER_API_KEY);
			console.info("Successfully deleted runner");
		} catch (e) {
			console.error(`Failed to delete a runner: ${runnerId}`, "Error:", e);
		}
		console.info(`${workflowJobCompleted} event finished`);
		return;
	});
};

export default appFn;
