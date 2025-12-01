import {
	createExecutionContext,
	env,
	waitOnExecutionContext,
} from "cloudflare:test";
import { createHmac } from "node:crypto";
import { afterEach, describe, expect, it, vi } from "vitest";
import worker from "../../src/index";
import { fetchAvailableIncusInstances } from "../../src/services/incus";

const IncomingRequest = Request<unknown, IncomingRequestCfProperties>;

vi.mock("@octokit/app", () => {
	return {
		App: vi.fn().mockImplementation(() => ({
			getInstallationOctokit: vi.fn().mockResolvedValue({
				rest: {
					actions: {
						generateRunnerJitconfigForRepo: vi.fn().mockResolvedValue({
							data: {
								encoded_jit_config: "mock-jit-config-base64",
								runner: { id: 1, name: "test-runner" },
							},
						}),
					},
				},
			}),
		})),
	};
});

vi.mock("../../src/services/incus", () => {
	return {
		createInstance: vi.fn(),
		execCommand: vi.fn(),
		fetchAvailableIncusInstances: vi.fn(),
		waitForVMAgent: vi.fn(),
	};
});

const createSignature = (payload: string, secret: string) =>
	`sha256=${createHmac("sha256", secret).update(payload).digest("hex")}`;

function mockRequest(body: string, signature: string) {
	return new IncomingRequest("http://example.com/webhook", {
		body,
		headers: {
			"content-type": "application/json",
			"x-hub-signature-256": signature,
		},
		method: "POST",
	});
}

async function runFetch(body: Record<string, unknown>) {
	const _body = JSON.stringify(body);
	const signature = createSignature(_body, env.GH_APP_WEBHOOK_SECRET);
	const request = mockRequest(_body, signature);
	const ctx = createExecutionContext();
	const response = await worker.fetch(request, env, ctx);
	await waitOnExecutionContext(ctx);
	return response;
}

afterEach(() => {
	vi.clearAllMocks();
});

describe("webhook route", () => {
	it("responds with 200 for non-workflow_job events", async () => {
		const response = await runFetch({ action: "ping" });

		expect(response.status).toBe(200);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Event ignored"`,
		);
	});

	it("responds with 200 when workflow_job status is not queued", async () => {
		const response = await runFetch({ action: "ping", workflow_job: {} });
		expect(response.status).toBe(200);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Workflow Job but status is not queued"`,
		);
	});

	it("forwards queued workflow_job events to handler", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockResolvedValueOnce([
			{ name: "vm-1", status: "Stopped" },
		]);

		const response = await runFetch({
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

		expect(response.status).toBe(201);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Successfully created OpenCI runner"`,
		);
	});
});
