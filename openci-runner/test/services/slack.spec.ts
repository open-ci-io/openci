import { afterEach, describe, expect, it, vi } from "vitest";
import { notifyJobCompleted, notifyJobStarted } from "../../src/services/slack";
import type { WorkflowJobPayload } from "../../src/types/github.types";

const mockFetch = vi.fn();
vi.stubGlobal("fetch", mockFetch);

afterEach(() => {
	vi.clearAllMocks();
});

const mockWebhookUrl = "https://hooks.slack.com/services/xxx/yyy/zzz";

const createPayload = (
	overrides: Partial<WorkflowJobPayload["workflow_job"]> = {},
): WorkflowJobPayload => ({
	repository: {
		name: "openci",
		owner: { login: "openci-inc" },
	},
	workflow_job: {
		name: "test",
		run_id: 12345,
		...overrides,
	},
});

describe("notifyJobStarted", () => {
	it("sends job started notification", async () => {
		mockFetch.mockResolvedValueOnce({ ok: true });

		const payload = createPayload({ name: "build" });
		await notifyJobStarted(mockWebhookUrl, payload);

		expect(mockFetch).toHaveBeenCalledWith(mockWebhookUrl, {
			body: JSON.stringify({ text: "🚀 ジョブ開始: build" }),
			headers: { "Content-Type": "application/json" },
			method: "POST",
		});
	});

	it("uses Unknown when job name is missing", async () => {
		mockFetch.mockResolvedValueOnce({ ok: true });

		const payload = createPayload({ name: undefined });
		await notifyJobStarted(mockWebhookUrl, payload);

		expect(mockFetch).toHaveBeenCalledWith(mockWebhookUrl, {
			body: JSON.stringify({ text: "🚀 ジョブ開始: Unknown" }),
			headers: { "Content-Type": "application/json" },
			method: "POST",
		});
	});
});

describe("notifyJobCompleted", () => {
	it("sends success notification with duration", async () => {
		mockFetch.mockResolvedValueOnce({ ok: true });

		const payload = createPayload({
			completed_at: "2025-01-01T00:01:30Z",
			conclusion: "success",
			name: "test",
			started_at: "2025-01-01T00:00:00Z",
		});
		await notifyJobCompleted(mockWebhookUrl, payload);

		expect(mockFetch).toHaveBeenCalledWith(mockWebhookUrl, {
			body: JSON.stringify({
				text: "✅ ジョブ完了: test | 成功 | 1m 30s",
			}),
			headers: { "Content-Type": "application/json" },
			method: "POST",
		});
	});

	it("sends failure notification", async () => {
		mockFetch.mockResolvedValueOnce({ ok: true });

		const payload = createPayload({
			completed_at: "2025-01-01T00:00:45Z",
			conclusion: "failure",
			name: "test",
			started_at: "2025-01-01T00:00:00Z",
		});
		await notifyJobCompleted(mockWebhookUrl, payload);

		expect(mockFetch).toHaveBeenCalledWith(mockWebhookUrl, {
			body: JSON.stringify({
				text: "❌ ジョブ完了: test | 失敗 | 45s",
			}),
			headers: { "Content-Type": "application/json" },
			method: "POST",
		});
	});

	it("shows N/A when timestamps are missing", async () => {
		mockFetch.mockResolvedValueOnce({ ok: true });

		const payload = createPayload({
			conclusion: "success",
			name: "test",
		});
		await notifyJobCompleted(mockWebhookUrl, payload);

		expect(mockFetch).toHaveBeenCalledWith(mockWebhookUrl, {
			body: JSON.stringify({
				text: "✅ ジョブ完了: test | 成功 | N/A",
			}),
			headers: { "Content-Type": "application/json" },
			method: "POST",
		});
	});

	it("uses unknown status when conclusion is missing", async () => {
		mockFetch.mockResolvedValueOnce({ ok: true });

		const payload = createPayload({
			conclusion: undefined,
			name: "test",
		});
		await notifyJobCompleted(mockWebhookUrl, payload);

		expect(mockFetch).toHaveBeenCalledWith(mockWebhookUrl, {
			body: JSON.stringify({
				text: "❌ ジョブ完了: test | 失敗 | N/A",
			}),
			headers: { "Content-Type": "application/json" },
			method: "POST",
		});
	});

	it("logs error when fetch fails", async () => {
		const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});
		mockFetch.mockResolvedValueOnce({ ok: false, status: 500 });

		const payload = createPayload({ conclusion: "success", name: "test" });
		await notifyJobCompleted(mockWebhookUrl, payload);

		expect(consoleSpy).toHaveBeenCalledWith(
			"Failed to send Slack message: 500",
		);
		consoleSpy.mockRestore();
	});
});
