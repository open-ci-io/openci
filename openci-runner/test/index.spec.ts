import {
	createExecutionContext,
	env,
	waitOnExecutionContext,
} from "cloudflare:test";
import { createHmac } from "node:crypto";
import { describe, expect, it } from "vitest";
import worker from "../src/index";

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
	it("responds with 201 when signature is valid", async () => {
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
		const ctx = createExecutionContext();
		const response = await worker.fetch(request, env, ctx);
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

	it("returns 500 when webhook secret is not configured", async () => {
		const request = new IncomingRequest("http://example.com", {
			body: JSON.stringify({ action: "ping" }),
			headers: { "content-type": "application/json" },
			method: "POST",
		});
		const ctx = createExecutionContext();
		const envWithoutSecret = { ...env, GH_APP_WEBHOOK_SECRET: undefined };

		const response = await worker.fetch(request, envWithoutSecret, ctx);
		await waitOnExecutionContext(ctx);

		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe(
			"Webhook secret not configured",
		);
	});
});
