import { App } from "@octokit/app";
import { Octokit } from "@octokit/rest";
import { verify } from "@octokit/webhooks-methods";
import type { WebhookEvent } from "@octokit/webhooks-types";

export default {
	async fetch(request, env, _): Promise<Response> {
		const baseUrl = env.INCUS_SERVER_URL;
		const res = await fetch(`${baseUrl}/1.0/instances/test2`, {
			headers: {
				"CF-Access-Client-Id": env.CF_ACCESS_CLIENT_ID,
				"CF-Access-Client-Secret": env.CF_ACCESS_CLIENT_SECRET,
			},
		});

		const data = await res.json();
		console.log("Incus API response:", data);

		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		if (!webhookSecret) {
			return new Response("Webhook secret not configured", { status: 500 });
		}

		const headers = request.headers;
		const signature = headers.get("x-hub-signature-256");
		if (signature == null) {
			return new Response("Signature is null", { status: 401 });
		}
		const body = await request.text();

		const isValid = await verify(webhookSecret, body, signature);
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
					if (!env.GH_APP_ID) {
						return new Response("GH_APP_ID not provided", {
							status: 500,
						});
					}
					if (!env.GH_APP_PRIVATE_KEY) {
						return new Response("GH_APP_PRIVATE_KEY not provided", {
							status: 500,
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

						// biome-ignore lint/correctness/noUnusedVariables: <Use this later>
						const { encoded_jit_config } = data;

						// Incus APIを呼び出してVMを起動
						const baseUrl = env.INCUS_SERVER_URL;
						const res = await fetch(`${baseUrl}/1.0`, {
							headers: {
								"CF-Access-Client-Id": env.CF_ACCESS_CLIENT_ID,
								"CF-Access-Client-Secret": env.CF_ACCESS_CLIENT_SECRET,
							},
						});

						// // Stoppedなインスタンスを探す
						// const instances = listData.metadata || [];
						// const stoppedInstance = instances.find(
						// 	(inst: { status: string }) => inst.status === "Stopped",
						// );

						// if (!stoppedInstance) {
						// 	return new Response("No available VM found", { status: 503 });
						// }

						// console.log(`Selected VM: ${stoppedInstance.name}`);

						// // VMを起動
						// const startResponse = await fetch(
						// 	`${incusUrl}/1.0/instances/${stoppedInstance.name}/state`,
						// 	{
						// 		body: JSON.stringify({
						// 			action: "start",
						// 			timeout: 30,
						// 		}),
						// 		headers: {
						// 			Authorization: `Bearer ${incusToken}`,
						// 			"Content-Type": "application/json",
						// 		},
						// 		method: "PUT",
						// 	},
						// );

						// const startData = await startResponse.json();
						// console.log("Start VM response:", startData);

						// TODO: VMの起動完了を待つ
						// TODO: GitHub Actionsランナーをセットアップ
					} catch (e) {
						console.log("Failed to generate runner JIT config:", e);
						return new Response("Failed to generate runner JIT config", {
							status: 500,
						});
					}

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
