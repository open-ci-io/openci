import { App } from "@octokit/app";
import { Octokit } from "@octokit/rest";
import type { Context } from "hono";
import {
	createInstance,
	execCommand,
	fetchAvailableIncusInstances,
	waitForVMAgent,
} from "../services/incus";
import type { WorkflowJobPayload } from "../types/github.types";
import type { IncusEnv } from "../types/incus.types";

async function createOctokit(
	c: Context<{ Bindings: Env }>,
	installationId: number,
) {
	const app = new App({
		appId: c.env.GH_APP_ID,
		Octokit: Octokit,
		privateKey: c.env.GH_APP_PRIVATE_KEY,
	});

	return await app.getInstallationOctokit(installationId);
}

async function generateRunnerJitConfig(
	octokit: Octokit,
	payload: WorkflowJobPayload,
) {
	const runnerLabel = "openci-runner-beta-dev";
	const runnerName = "OpenCIランナーβ(開発環境)";

	const { data } = await octokit.rest.actions.generateRunnerJitconfigForRepo({
		labels: [runnerLabel],
		name: `${runnerName}-${Date.now()}`,
		owner: payload.repository.owner.login,
		repo: payload.repository.name,
		runner_group_id: 1,
		work_folder: "_work",
	});

	return data.encoded_jit_config;
}

async function getOrCreateIncusInstance(incusEnv: IncusEnv): Promise<string> {
	console.log("Started to search available Incus VMs");

	const availableInstances = await fetchAvailableIncusInstances(incusEnv);
	console.log(`Found ${availableInstances.length} available Incus instances`);

	// 次のissueでVMのWarm Poolを実装する https://github.com/open-ci-io/openci/issues/591
	console.log("Start to create new Incus instance");
	const instanceName = `openci-runner-${Date.now()}`;
	const imageName = "openci-runner-0.0.1";
	await createInstance(incusEnv, instanceName, imageName);
	return instanceName;
}

export async function handleWorkflowJob(
	c: Context<{ Bindings: Env }>,
	payload: WorkflowJobPayload,
) {
	const installationId = payload.installation?.id;
	if (!installationId) {
		return c.text("Installation ID not found", 400);
	}

	try {
		const octokit = await createOctokit(c, installationId);

		const encodedJitConfig = await generateRunnerJitConfig(octokit, payload);
		console.log("Successfully generated GHA JIT config");

		const incusEnv = {
			cloudflare_access_client_id: c.env.CF_ACCESS_CLIENT_ID,
			cloudflare_access_client_secret: c.env.CF_ACCESS_CLIENT_SECRET,
			server_url: c.env.INCUS_SERVER_URL,
		};

		const instanceName = await getOrCreateIncusInstance(incusEnv);

		await waitForVMAgent(incusEnv, instanceName);

		await execCommand(
			incusEnv,
			instanceName,
			[
				"tmux",
				"new-session",
				"-d",
				"-s",
				"runner",
				`RUNNER_ALLOW_RUNASROOT=1 ./run.sh --jitconfig ${encodedJitConfig}`,
			],
			{ cwd: "/root/actions-runner" },
		);
		console.log("Successfully registered as GitHub Actions Self-Hosted Runner");

		return c.text("Successfully created OpenCI runner", 201);
	} catch (e) {
		console.error(e);
		return c.text("Internal Server Error", 500);
	}
}
