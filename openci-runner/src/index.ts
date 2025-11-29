import { App } from "@octokit/app";
import { Octokit } from "@octokit/rest";
import { verify } from "@octokit/webhooks-methods";
import type { WebhookEvent } from "@octokit/webhooks-types";
import { fetchAvailableIncusInstances, type IncusProperty } from "./incus";

const validateEnv = (env: Env): string | null => {
	if (!env.GH_APP_WEBHOOK_SECRET) return "GH_APP_WEBHOOK_SECRET not provided";
	if (!env.GH_APP_ID) return "GH_APP_ID not provided";
	if (!env.GH_APP_PRIVATE_KEY) return "GH_APP_PRIVATE_KEY not provided";
	if (!env.CF_ACCESS_CLIENT_ID) return "CF_ACCESS_CLIENT_ID not provided";
	if (!env.CF_ACCESS_CLIENT_SECRET)
		return "CF_ACCESS_CLIENT_SECRET not provided";
	if (!env.INCUS_SERVER_URL) return "INCUS_SERVER_URL not provided";
	return null;
};

export default {
	async fetch(request, env, _): Promise<Response> {
		if (request.method !== "POST") {
			return new Response("Method Not Allowed", {
				headers: { Allow: "POST" },
				status: 405,
			});
		}

		const envError = validateEnv(env);
		if (envError) {
			return new Response(envError, { status: 500 });
		}

		const headers = request.headers;
		const signature = headers.get("x-hub-signature-256");
		if (signature == null) {
			return new Response("Signature is null", { status: 401 });
		}
		const body = await request.text();

		const isValid = await verify(env.GH_APP_WEBHOOK_SECRET, body, signature);
		if (!isValid) {
			return new Response("Unauthorized", { status: 401 });
		}

		const payload: WebhookEvent = JSON.parse(body);

		if ("workflow_job" in payload) {
			switch (payload.action) {
				case WorkflowJobAction.Queued: {
					const installationId = payload.installation?.id;
					if (installationId === undefined) {
						return new Response("Installation ID not found in payload", {
							status: 400,
						});
					}

					const app = new App({
						appId: env.GH_APP_ID,
						Octokit: Octokit,
						privateKey: env.GH_APP_PRIVATE_KEY,
					});

					const octokit = await app.getInstallationOctokit(installationId);

					const runnerLabel = "openci-runner-beta-dev";
					const runnerName = "OpenCIランナーβ(開発環境)";

					// biome-ignore lint/correctness/noUnusedVariables: <Use later>
					let encodedJitConfig: string;
					try {
						const { data } =
							await octokit.rest.actions.generateRunnerJitconfigForRepo({
								labels: [runnerLabel],
								name: `${runnerName}-${Date.now()}`,
								owner: payload.repository.owner.login,
								repo: payload.repository.name,
								runner_group_id: 1,
								work_folder: "_work",
							});

						encodedJitConfig = data.encoded_jit_config;
					} catch (e) {
						console.log("Failed to generate runner JIT config:", e);
						return new Response("Failed to generate runner JIT config", {
							status: 500,
						});
					}
					console.log("Successfully generated GHA JIT config");

					console.log("Started to search available Incus VMs");
					const incusEnv = {
						cloudflare_access_client_id: env.CF_ACCESS_CLIENT_ID,
						cloudflare_access_client_secret: env.CF_ACCESS_CLIENT_SECRET,
						server_url: env.INCUS_SERVER_URL,
					};

					let availableInstances: IncusProperty[];
					try {
						availableInstances = await fetchAvailableIncusInstances(incusEnv);
					} catch (e) {
						console.log("Failed to fetch available Incus instances:", e);
						return new Response("Failed to fetch available Incus instances", {
							status: 500,
						});
					}
					console.log(
						`Found ${availableInstances.length} available Incus instances`,
					);

					return new Response(`Successfully created OpenCI runner`, {
						status: 201,
					});
				}
				default:
					return new Response(
						"Workflow Job but status is not queued. Ignore this event",
						{
							status: 200,
						},
					);
			}
		}

		return new Response("Event ignored", { status: 200 });
	},
} satisfies ExportedHandler<Env>;

const WorkflowJobAction = {
	Queued: "queued",
} as const;
