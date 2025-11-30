import { App } from "@octokit/app";
import { Octokit } from "@octokit/rest";
import type { Context } from "hono";
import { z } from "zod";
import {
	createInstance,
	fetchAvailableIncusInstances,
} from "../services/incus";

const WorkflowJobPayloadSchema = z.object({
	installation: z
		.object({
			id: z.number(),
		})
		.optional(),
	repository: z.object({
		name: z.string(),
		owner: z.object({
			login: z.string(),
		}),
	}),
});

export type WorkflowJobPayload = z.infer<typeof WorkflowJobPayloadSchema>;

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

type IncusEnv = {
	cloudflare_access_client_id: string;
	cloudflare_access_client_secret: string;
	server_url: string;
};

async function getOrCreateIncusInstance(incusEnv: IncusEnv) {
	console.log("Started to search available Incus VMs");

	const availableInstances = await fetchAvailableIncusInstances(incusEnv);
	console.log(`Found ${availableInstances.length} available Incus instances`);

	if (availableInstances.length === 0) {
		console.log("Start to create new Incus instance");
		const instanceName = `openci-runner-${Date.now()}`;
		await createInstance(incusEnv, instanceName, "openci-runner0");
	}
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

		// biome-ignore lint/correctness/noUnusedVariables: <Use later>
		const encodedJitConfig = await generateRunnerJitConfig(octokit, payload);
		console.log("Successfully generated GHA JIT config");

		const incusEnv = {
			cloudflare_access_client_id: c.env.CF_ACCESS_CLIENT_ID,
			cloudflare_access_client_secret: c.env.CF_ACCESS_CLIENT_SECRET,
			server_url: c.env.INCUS_SERVER_URL,
		};

		await getOrCreateIncusInstance(incusEnv);

		return c.text("Successfully created OpenCI runner", 201);
	} catch (e) {
		console.error(e);
		return c.text("Internal Server Error", 500);
	}
}
