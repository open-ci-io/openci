import { verify } from "@octokit/webhooks-methods";

export default {
	async fetch(request, env, _): Promise<Response> {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
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

		return new Response("Successfully created OpenCI runner", { status: 201 });
	},
} satisfies ExportedHandler<Env>;
