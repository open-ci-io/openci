import { verify } from "@octokit/webhooks-methods";
import type { WebhookEvent } from "@octokit/webhooks-types";

export default {
	async fetch(request, env, _): Promise<Response> {
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
			if (payload.action === WorkflowJobAction.Queued) {
				console.log("Queued", payload);
			}
		}

		return new Response("Successfully created OpenCI runner", { status: 201 });
	},
} satisfies ExportedHandler<Env>;

const WorkflowJobAction = {
	Completed: "completed",
	InProgress: "in_progress",
	Queued: "queued",
	Waiting: "waiting",
} as const;
