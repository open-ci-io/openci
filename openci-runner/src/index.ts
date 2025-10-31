/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Bind resources to your worker in `wrangler.jsonc`. After adding bindings, a type definition for the
 * `Env` object can be regenerated with `npm run cf-typegen`.
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

import { Webhooks } from "@octokit/webhooks";

export default {
	async fetch(request, env, _): Promise<Response> {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const headers = request.headers;
		const signature = headers.get("x-hub-signature-256");
		if (signature == null) {
			return new Response("Signature is null", { status: 401 });
		}
		const body = await request.text();

		const isValid = await verifyGitHubWebhookSecret(
			body,
			signature,
			webhookSecret,
		);
		if (!isValid) {
			return new Response("Unauthorized", { status: 401 });
		}

		return new Response("Successfully created OpenCI runner", { status: 201 });
	},
} satisfies ExportedHandler<Env>;

export async function verifyGitHubWebhookSecret(
	body: string,
	signature: string,
	webhookSecret: string,
): Promise<boolean> {
	const webhooks = new Webhooks({
		secret: webhookSecret,
	});
	if (!(await webhooks.verify(body, signature))) {
		return false;
	}

	return true;
}
