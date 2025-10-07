import { Octokit } from "@octokit/rest";
import { NodeSSH } from "node-ssh";
import { setTimeout } from "node:timers/promises";
import type { ApplicationFunction, Context, Probot } from "probot";
import { isJobRequired } from "./github.js";
import {
	createServer,
	deleteServer,
	getJitConfig,
	getServerStatusById,
	initRunner,
	type OctokitToken,
} from "./hetzner.js";

export const appFn: ApplicationFunction = (app: Probot) => {
	app.log.info("Yay! The app was loaded!");

	app.on("issues.reopened", async (context: Context) => {
		return context.octokit.rest.issues.createComment(
			context.issue({ body: "Probot is working!" }),
		);
	});

	app.on("workflow_job.queued", async (context) => {
		console.log("workflow_job.queued");
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

		const hetznerResponse = await createServer(process.env.HETZNER_API_KEY);
		while (true) {
			const status = await getServerStatusById(
				hetznerResponse.serverId,
				process.env.HETZNER_API_KEY,
			);
			if (status === "running") {
				console.log("Server is now running!");
				break;
			} else {
				console.log("Waiting for the server init. Will try again in 1 second");
				await setTimeout(1000);
			}
		}
		const ssh = new NodeSSH();
		const maxRetry = 10;
		let retryCount = 0;
		while (retryCount < maxRetry) {
			console.log("retry:", retryCount);
			try {
				const sshResult = await ssh.connect({
					host: hetznerResponse.ipv4,
					username: "root",
					privateKey: process.env.HETZNER_SSH_PRIVATE_KEY,
					passphrase: process.env.HETZNER_SSH_PASSPHRASE,
				});

				const octokit = new Octokit({
					auth: token,
				});
				const encodedJitConfig = await getJitConfig(
					octokit,
					owner,
					repo,
					hetznerResponse.serverId,
				);
				await sshResult.execCommand("apt install tmux");
				await sshResult.execCommand(initRunner(encodedJitConfig));
				console.log("Successfully start openci runner");
				break;
			} catch (e) {
				console.log("error, will try again in 1 second", e);
				await setTimeout(1000);
				retryCount++;
			}
		}
	});

	app.on("workflow_job.completed", async (context) => {
		console.log("workflow_job.completed");
		if (!isJobRequired(context)) {
			console.log("This workflow job doesn't use openci runner");
			return;
		}
		const runnerName = context.payload.workflow_job.runner_name;
		if (runnerName == null) {
			console.log("This runner is GitHub hosted one");
		}
		const defaultRunnerName = "OpenCI ランナー ";
		const runnerId = runnerName?.replace(defaultRunnerName, "");
		console.log("runner id", runnerId);

		await deleteServer(runnerId, process.env.HETZNER_API_KEY);
		console.log("Finish cleaning up");
	});
};

export default appFn;
