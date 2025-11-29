import {
	createExecutionContext,
	env,
	waitOnExecutionContext,
} from "cloudflare:test";
import { createHmac } from "node:crypto";
import { afterEach, describe, expect, it, vi } from "vitest";
import { fetchAvailableIncusInstances } from "../src/incus";
import worker from "../src/index";

const IncomingRequest = Request<unknown, IncomingRequestCfProperties>;

const mockGenerateJitConfig = vi.fn().mockResolvedValue({
	data: {
		encoded_jit_config: "mock-jit-config-base64",
		runner: {
			id: 1,
			name: "test-runner",
		},
	},
});

vi.mock("@octokit/app", () => {
	return {
		App: vi.fn().mockImplementation(() => ({
			getInstallationOctokit: vi.fn().mockResolvedValue({
				rest: {
					actions: {
						generateRunnerJitconfigForRepo: mockGenerateJitConfig,
					},
				},
			}),
		})),
	};
});

const createSignature = (payload: string, secret: string) =>
	`sha256=${createHmac("sha256", secret).update(payload).digest("hex")}`;

afterEach(() => {
	vi.clearAllMocks();
});

vi.mock("../src/incus", () => {
	return {
		fetchAvailableIncusInstances: vi.fn(),
	};
});

describe("fetch", () => {
	it.each([
		"GET",
		"PUT",
		"DELETE",
		"PATCH",
		"OPTIONS",
		"HEAD",
	])("returns 405 for %s method", async (method) => {
		const request = new IncomingRequest("http://example.com", {
			headers: {
				"content-type": "application/json",
			},
			method: method,
		});
		const ctx = createExecutionContext();
		const response = await worker.fetch(request, env, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(405);
		await expect(response.text()).resolves.toBe("Method Not Allowed");
	});

	it("responds with 200 for non-workflow_job events", async () => {
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
		expect(response.status).toBe(200);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Event ignored"`,
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

	it("return 201 when new runner is created", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockResolvedValueOnce([
			{ name: "vm-1", status: "Stopped" },
		]);

		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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

	it("nothing to be processed", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({ action: "ping", workflow_job: {} });
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
		expect(response.status).toBe(200);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Workflow Job but status is not queued. Ignore this event"`,
		);
	});

	it("returns 400 when installationId is undefined", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		expect(response.status).toBe(400);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Installation ID not found in payload"`,
		);
	});

	it("returns 500 when GitHub API fails", async () => {
		mockGenerateJitConfig.mockRejectedValueOnce(new Error("API Error"));

		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Failed to generate runner JIT config"`,
		);
	});

	it("returns 500 when GH_APP_ID not provided", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		const envWithoutAppId = { ...env, GH_APP_ID: undefined };
		const response = await worker.fetch(request, envWithoutAppId, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"GH_APP_ID not provided"`,
		);
	});

	it("returns 500 when GH_APP_PRIVATE_KEY not provided", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		const envWithoutGitHubPrivateKey = {
			...env,
			GH_APP_PRIVATE_KEY: undefined,
		};
		const response = await worker.fetch(
			request,
			envWithoutGitHubPrivateKey,
			ctx,
		);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"GH_APP_PRIVATE_KEY not provided"`,
		);
	});

	it("returns 500 when CF_ACCESS_CLIENT_ID not provided", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		const envWithoutCfClientId = { ...env, CF_ACCESS_CLIENT_ID: undefined };
		const response = await worker.fetch(request, envWithoutCfClientId, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe(
			"CF_ACCESS_CLIENT_ID not provided",
		);
	});

	it("returns 500 when CF_ACCESS_CLIENT_SECRET not provided", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		const envWithoutCfClientSecret = {
			...env,
			CF_ACCESS_CLIENT_SECRET: undefined,
		};
		const response = await worker.fetch(request, envWithoutCfClientSecret, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe(
			"CF_ACCESS_CLIENT_SECRET not provided",
		);
	});

	it("returns 500 when INCUS_SERVER_URL not provided", async () => {
		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		const envWithoutIncusUrl = { ...env, INCUS_SERVER_URL: undefined };
		const response = await worker.fetch(request, envWithoutIncusUrl, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe(
			"INCUS_SERVER_URL not provided",
		);
	});

	it("returns 500 when fetchAvailableIncusInstances fails", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockRejectedValueOnce(
			new Error("Failed to connect to Incus server"),
		);

		const webhookSecret = env.GH_APP_WEBHOOK_SECRET;
		const body = JSON.stringify({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: ["self-hosted"],
			},
		});
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
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe(
			"Failed to fetch available Incus instances",
		);
	});
});
