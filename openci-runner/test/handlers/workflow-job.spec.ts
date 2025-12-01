import {
	createExecutionContext,
	env,
	waitOnExecutionContext,
} from "cloudflare:test";
import { createHmac } from "node:crypto";
import { afterEach, describe, expect, it, vi } from "vitest";
import worker from "../../src/index";
import { OPENCI_RUNNER_LABEL } from "../../src/routes/webhook";
import {
	createInstance,
	fetchAvailableIncusInstances,
} from "../../src/services/incus";

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

vi.mock("../../src/services/incus", () => {
	return {
		createInstance: vi.fn(),
		deleteInstance: vi.fn(),
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

describe("workflow-job handler", () => {
	it("returns 201 when new runner is created with available instance", async () => {
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
				labels: [OPENCI_RUNNER_LABEL],
				run_id: 12345,
			},
		});

		expect(response.status).toBe(201);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Successfully created OpenCI runner"`,
		);
	});

	it("returns 400 when installationId is undefined", async () => {
		const response = await runFetch({
			action: "queued",
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: [OPENCI_RUNNER_LABEL],
				run_id: 12345,
			},
		});

		expect(response.status).toBe(400);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Installation ID not found"`,
		);
	});

	it("returns 500 when GitHub API fails", async () => {
		mockGenerateJitConfig.mockRejectedValueOnce(new Error("API Error"));

		const response = await runFetch({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: [OPENCI_RUNNER_LABEL],
				run_id: 12345,
			},
		});

		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toMatchInlineSnapshot(
			`"Internal Server Error"`,
		);
	});

	it("returns 500 when fetchAvailableIncusInstances fails", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockRejectedValueOnce(
			new Error("Failed to connect to Incus server"),
		);

		const response = await runFetch({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: [OPENCI_RUNNER_LABEL],
				run_id: 12345,
			},
		});

		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe("Internal Server Error");
	});

	it("creates new instance when no available instances found", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockResolvedValueOnce([]);
		vi.mocked(createInstance).mockResolvedValueOnce(undefined);

		const response = await runFetch({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: [OPENCI_RUNNER_LABEL],
				run_id: 12345,
			},
		});

		expect(response.status).toBe(201);
		await expect(response.text()).resolves.toBe(
			"Successfully created OpenCI runner",
		);
		expect(createInstance).toHaveBeenCalledWith(
			expect.objectContaining({
				cloudflare_access_client_id: env.CF_ACCESS_CLIENT_ID,
				cloudflare_access_client_secret: env.CF_ACCESS_CLIENT_SECRET,
				server_url: env.INCUS_SERVER_URL,
			}),
			"openci-runner-12345",
			"openci-runner-0.0.1",
		);
	});

	it("returns 500 when createInstance fails", async () => {
		vi.mocked(fetchAvailableIncusInstances).mockResolvedValueOnce([]);
		vi.mocked(createInstance).mockRejectedValueOnce(
			new Error("Failed to create instance"),
		);

		const response = await runFetch({
			action: "queued",
			installation: { id: 123456 },
			repository: {
				name: "test-repo",
				owner: { login: "test-owner" },
			},
			workflow_job: {
				id: 1,
				labels: [OPENCI_RUNNER_LABEL],
				run_id: 12345,
			},
		});

		expect(response.status).toBe(500);
		await expect(response.text()).resolves.toBe("Internal Server Error");
		expect(createInstance).toHaveBeenCalledTimes(1);
	});
});
