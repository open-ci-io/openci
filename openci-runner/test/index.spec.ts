import {
	createExecutionContext,
	env,
	SELF,
	waitOnExecutionContext,
} from "cloudflare:test";
import { createHmac } from "node:crypto";
import { describe, expect, it } from "vitest";
import worker, { verifyGitHubWebhookSecret } from "../src/index";

// For now, you'll need to do something like this to get a correctly-typed
// `Request` to pass to `worker.fetch()`.
const IncomingRequest = Request<unknown, IncomingRequestCfProperties>;

const createSignature = (payload: string, secret: string) =>
	`sha256=${createHmac("sha256", secret).update(payload).digest("hex")}`;

describe("ensure secrets", () => {
	it("all secrets are set", () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		console.log(webhookSecret);
		expect(webhookSecret).not.toBeNull();
	});
});

describe("fetch", () => {
	it("responds with 201 when signature is valid (unit style)", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({ action: "ping" });
		const signature = createSignature(body, webhookSecret);
		const request = new IncomingRequest("http://example.com", {
			body,
			headers: {
				"content-type": "application/json",
				"x-hub-signature-256": signature,
			},
			method: "POST",
		});
		// Create an empty context to pass to `worker.fetch()`.
		const ctx = createExecutionContext();
		const response = await worker.fetch(request, env, ctx);
		// Wait for all `Promise`s passed to `ctx.waitUntil()` to settle before running test assertions
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(201);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Successfully created OpenCI runner"`,
		);
	});

	it("Signature is missing", async () => {
		const body = JSON.stringify({ action: "ping" });
		const request = new IncomingRequest("http://example.com", {
			body,
			headers: {
				"content-type": "application/json",
			},
			method: "POST",
		});
		const ctx = createExecutionContext();
		const response = await worker.fetch(request, env, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(401);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Signature is null"`,
		);
	});

	it("Webhook signature is not valid", async () => {
		const body = JSON.stringify({ action: "ping" });
		const invalidSignature = createSignature(body, "NOT_THE_REAL_SECRET");
		const request = new IncomingRequest("http://example.com", {
			body,
			headers: {
				"content-type": "application/json",
				"x-hub-signature-256": invalidSignature,
			},
			method: "POST",
		});
		const ctx = createExecutionContext();
		const response = await worker.fetch(request, env, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(401);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Unauthorized"`,
		);
	});

	it("responds with 201 when signature is valid (integration style)", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({ action: "ping" });
		const signature = createSignature(body, webhookSecret);
		const response = await SELF.fetch("https://example.com", {
			body,
			headers: {
				"content-type": "application/json",
				"x-hub-signature-256": signature,
			},
			method: "POST",
		});
		expect(response.status).toBe(201);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Successfully created OpenCI runner"`,
		);
	});
});

describe("verifyGitHubWebhookSecret", () => {
	const webhookSecret = "test-secret";
	const body = JSON.stringify({ action: "ping" });

	it("returns true when the signature matches the payload and secret", async () => {
		const signature = createSignature(body, webhookSecret);
		await expect(
			verifyGitHubWebhookSecret(body, signature, webhookSecret),
		).resolves.toBe(true);
	});

	it("returns false when the signature does not match the payload", async () => {
		const signature = createSignature(body, webhookSecret);
		await expect(
			verifyGitHubWebhookSecret(body, signature, "another-secret"),
		).resolves.toBe(false);
	});
});
