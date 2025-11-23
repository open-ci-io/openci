import { App } from "@octokit/app";
import { Octokit } from "@octokit/rest";
import { verify } from "@octokit/webhooks-methods";
import type { WebhookEvent } from "@octokit/webhooks-types";
import { v4 as uuidv4 } from "uuid";
import type { IncusInstanceResponse, IncusInstancesResponse } from "./incus";

export default {
	async fetch(request, env, _): Promise<Response> {
		if (request.method !== "POST") {
			return new Response("Method not allowed", { status: 405 });
		}
		const baseUrl = env.INCUS_SERVER_URL;
		const instanceUrl = `${baseUrl}/1.0/instances`;
		const cloudflareAccessHeaders = {
			"CF-Access-Client-Id": env.CF_ACCESS_CLIENT_ID,
			"CF-Access-Client-Secret": env.CF_ACCESS_CLIENT_SECRET,
		};

		const allInstancesInfo = await fetch(`${instanceUrl}?recursion=1`, {
			headers: cloudflareAccessHeaders,
		});

		const data = (await allInstancesInfo.json()) as IncusInstancesResponse;
		const instanceList = data.metadata;
		const availableInstanceList = instanceList.filter(
			(e) => e.status === "Stopped",
		);
		console.log(
			"Incus API response:",
			availableInstanceList.map((e) => e.status),
		);

		let vmName: string;

		if (availableInstanceList.length !== 0) {
			vmName = uuidv4();
			const baseImage = "openci-runner0";
			const res = await fetch(`${instanceUrl}`, {
				body: JSON.stringify({
					config: {
						"limits.cpu": "8",
						"limits.memory": "16GiB",
					},
					devices: {
						root: {
							path: "/",
							pool: "default",
							size: "128GiB",
							type: "disk",
						},
					},
					name: vmName,
					source: {
						alias: baseImage,
						type: "image",
					},
					start: true,
					type: "virtual-machine",
				}),
				headers: cloudflareAccessHeaders,
				method: "POST",
			});

			const hasCreated = false;

			const sleep = (ms: number) => new Promise((res) => setTimeout(res, ms));

			while (!hasCreated) {
				const res = await fetch(`${instanceUrl}/${vmName}`, {
					headers: cloudflareAccessHeaders,
				});
				console.log("res");
				const resJson = (await res.json()) as IncusInstanceResponse;
				console.log(resJson);
				const status = resJson.metadata.status;
				console.log(resJson.metadata.status);
				await sleep(1000);
				if (status === "Running") {
					console.log("successfully start a VM");

					console.log("Waiting for Incus agent...");

					// Incus agentの起動を待つ
					let agentReady = false;
					let retries = 0;
					const maxRetries = 30; // 最大30秒待機

					while (!agentReady && retries < maxRetries) {
						await sleep(1000);
						retries++;

						const stateRes = await fetch(`${instanceUrl}/${vmName}/state`, {
							headers: cloudflareAccessHeaders,
						});
						const stateData = (await stateRes.json()) as any;

						// agentが起動しているか確認
						if (
							stateData.metadata?.processes !== undefined &&
							stateData.metadata.processes >= 0
						) {
							agentReady = true;
							console.log(`Incus agent is ready! (took 
  ${retries} seconds)`);
						} else {
							console.log(`Waiting for agent... 
  (${retries}/${maxRetries})`);
						}
					}

					if (!agentReady) {
						console.log("Warning: Agent did not start in time");
						return new Response("Agent timeout", { status: 500 });
					}
					break;
				}
			}

			const execRes = await fetch(`${instanceUrl}/${vmName}/exec`, {
				body: JSON.stringify({
					command: ["touch", "/root/helloWorld.ts"],
					interactive: false,
					"record-output": true,
					"wait-for-websocket": false,
				}),

				headers: cloudflareAccessHeaders,
				method: "POST",
			});
			const execResJson = (await execRes.json()) as any;

			if (execResJson.operation) {
				const waitRes = await fetch(`${baseUrl}${execResJson.operation}/wait`, {
					headers: cloudflareAccessHeaders,
				});
				const waitData = (await waitRes.json()) as any;
				console.log("Exec operation completed:", waitData);

				if (waitData.metadata?.err) {
					console.log("Exec error:", waitData.metadata.err);
				} else if (waitData.metadata?.metadata?.return !== 0) {
					console.log(`Command failed with exit code: 
  ${waitData.metadata.metadata.return}`);
				} else {
					console.log("File created successfully!");
				}
			}

			console.log("vmName", vmName, "execResJson", execResJson);
			return new Response("Finished", {
				status: 200,
			});
		} else {
			const instance = availableInstanceList[0];

			// Config
			const res = await fetch(`${instanceUrl}/${instance.name}`, {
				body: JSON.stringify({
					config: {
						"limits.cpu": "8",
						"limits.memory": "16GiB",
					},
				}),
				headers: cloudflareAccessHeaders,
				method: "PATCH",
			});

			console.log(res);
			if (!res.ok) {
				const errorBody = await res.json();
				console.log("Error details:", errorBody);
				return new Response("Errors in vm config", { status: 401 });
			} else {
				const successBody = await res.json();
				console.log("Success:", successBody);
			}
		}

		// Start the VM

		// config vm
		// 1. check available instances
		// 2. if there are not available instances, create a new one.
		// 3. set appropriate config
		// 4. start the instance
		// 5. run GHA script

		// after the job completion, delete the vm and create as much as vms possible

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
