import {
	createExecutionContext,
	env,
	waitOnExecutionContext,
} from "cloudflare:test";
import { createHmac } from "node:crypto";
import { afterEach, describe, expect, it, vi } from "vitest";
import z from "zod";
import { fetchAvailableIncusInstances } from "../src/incus";
import worker from "../src/index";

const HttpMethod = z.enum([
	"GET",
	"POST",
	"PUT",
	"DELETE",
	"PATCH",
	"OPTIONS",
	"HEAD",
]);
type HttpMethod = z.infer<typeof HttpMethod>;

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

vi.mock("../src/incus", () => {
	return {
		fetchAvailableIncusInstances: vi.fn(),
	};
});

const createSignature = (payload: string, secret: string) =>
	`sha256=${createHmac("sha256", secret).update(payload).digest("hex")}`;

function mockRequest(method: HttpMethod, body?: string, signature?: string) {
	const headers: Record<string, string> = {
		"content-type": "application/json",
	};
	if (signature) {
		headers["x-hub-signature-256"] = signature;
	}
	return new IncomingRequest("http://example.com", {
		body,
		headers,
		method,
	});
}

async function runFetch(
	method: HttpMethod,
	body?: Record<string, unknown>,
	needSignature: boolean = false,
) {
	const _body = JSON.stringify(body);
	let signature: string | undefined;
	if (needSignature) {
		const _body = JSON.stringify(body);
		signature = createSignature(_body, webhookSecret);
	}
	const request = mockRequest(method, _body, signature);
	const ctx = createExecutionContext();
	const response = await worker.fetch(request, env, ctx);
	await waitOnExecutionContext(ctx);
	return response;
}

const webhookSecret = env.GH_APP_WEBHOOK_SECRET;

afterEach(() => {
	vi.clearAllMocks();
});

describe("fetch", () => {
	it.each(
		HttpMethod.options.filter((e) => e !== HttpMethod.enum.POST),
	)("returns 405 for %s method", async (method) => {
		const response = await runFetch(method);
		expect(response.status).toBe(405);
		await expect(response.text()).resolves.toBe("Method Not Allowed");
	});

	it("responds with 200 for non-workflow_job events", async () => {
		const response = await runFetch(
			HttpMethod.enum.POST,
			{ action: "ping" },
			true,
		);

		expect(response.status).toBe(200);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Event ignored"`,
		);
	});

	it("Signature is missing", async () => {
		const response = await runFetch(HttpMethod.enum.POST, { action: "ping" });
		expect(response.status).toBe(401);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Signature is null"`,
		);
	});

	it("Webhook signature is not valid", async () => {
		const body = JSON.stringify({ action: "ping" });
		const invalidSignature = createSignature(body, "NOT_THE_REAL_SECRET");
		const request = mockRequest(HttpMethod.enum.POST, body, invalidSignature);
		const ctx = createExecutionContext();
		const response = await worker.fetch(request, env, ctx);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(401);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Unauthorized"`,
		);
	});

	it("return 201 when new runner is created", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockResolvedValueOnce([
			{ name: "vm-1", status: "Stopped" },
		]);

		const response = await runFetch(
			HttpMethod.enum.POST,
			{
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
			},
			true,
		);

		expect(response.status).toBe(201);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Successfully created OpenCI runner"`,
		);
	});

	it("nothing to be processed", async () => {
		const response = await runFetch(
			HttpMethod.enum.POST,
			{ action: "ping", workflow_job: {} },
			true,
		);
		expect(response.status).toBe(200);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Workflow Job but status is not queued. Ignore this event"`,
		);
	});

	it("returns 400 when installationId is undefined", async () => {
		const response = await runFetch(
			HttpMethod.enum.POST,
			{
				action: "queued",
				repository: {
					name: "test-repo",
					owner: { login: "test-owner" },
				},
				workflow_job: {
					id: 1,
					labels: ["self-hosted"],
				},
			},
			true,
		);

		expect(response.status).toBe(400);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Installation ID not found in payload"`,
		);
	});

	it("returns 500 when GitHub API fails", async () => {
		mockGenerateJitConfig.mockRejectedValueOnce(new Error("API Error"));

		const response = await runFetch(
			HttpMethod.enum.POST,
			{
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
			},
			true,
		);

		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Failed to generate runner JIT config"`,
		);
	});

	it("returns 500 when fetchAvailableIncusInstances fails", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockRejectedValueOnce(
			new Error("Failed to connect to Incus server"),
		);

		const response = await runFetch(
			HttpMethod.enum.POST,
			{
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
			},
			true,
		);

		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe(
			"Failed to fetch available Incus instances",
		);
	});

	it.each([
		["GH_APP_WEBHOOK_SECRET", { GH_APP_WEBHOOK_SECRET: undefined }],
		["GH_APP_ID", { GH_APP_ID: undefined }],
		["GH_APP_PRIVATE_KEY", { GH_APP_PRIVATE_KEY: undefined }],
		["CF_ACCESS_CLIENT_ID", { CF_ACCESS_CLIENT_ID: undefined }],
		["CF_ACCESS_CLIENT_SECRET", { CF_ACCESS_CLIENT_SECRET: undefined }],
		["INCUS_SERVER_URL", { INCUS_SERVER_URL: undefined }],
	])("returns 500 when %s not provided", async (envName, overrideEnv) => {
		const request = new IncomingRequest("http://example.com", {
			body: "{}",
			headers: { "content-type": "application/json" },
			method: "POST",
		});
		const ctx = createExecutionContext();
		const response = await worker.fetch(
			request,
			{ ...env, ...overrideEnv },
			ctx,
		);
		await waitOnExecutionContext(ctx);
		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe(`${envName} not provided`);
	});
});
