import type { WorkflowJobPayload } from "../types/github.types";

interface SlackMessage {
	text: string;
}

export async function notifyJobStarted(
	webhookUrl: string,
	payload: WorkflowJobPayload,
): Promise<void> {
	const jobName = payload.workflow_job?.name ?? "Unknown";

	await sendSlackMessage(webhookUrl, {
		text: `🚀 ジョブ開始: ${jobName}`,
	});
}

export async function notifyJobCompleted(
	webhookUrl: string,
	payload: WorkflowJobPayload,
): Promise<void> {
	const job = payload.workflow_job;
	const jobName = job?.name ?? "Unknown";
	const conclusion = job?.conclusion ?? "unknown";
	const status = conclusion === "success" ? "成功" : "失敗";
	const emoji = conclusion === "success" ? "✅" : "❌";
	const duration = calculateDuration(job?.started_at, job?.completed_at);

	await sendSlackMessage(webhookUrl, {
		text: `${emoji} ジョブ完了: ${jobName} | ${status} | ${duration}`,
	});
}

function calculateDuration(startedAt?: string, completedAt?: string): string {
	if (!startedAt || !completedAt) {
		return "N/A";
	}

	const start = new Date(startedAt).getTime();
	const end = new Date(completedAt).getTime();
	const durationMs = end - start;

	const seconds = Math.floor(durationMs / 1000);
	const minutes = Math.floor(seconds / 60);
	const remainingSeconds = seconds % 60;

	if (minutes > 0) {
		return `${minutes}m ${remainingSeconds}s`;
	}
	return `${seconds}s`;
}

async function sendSlackMessage(
	webhookUrl: string,
	message: SlackMessage,
): Promise<void> {
	const response = await fetch(webhookUrl, {
		body: JSON.stringify(message),
		headers: {
			"Content-Type": "application/json",
		},
		method: "POST",
	});

	if (!response.ok) {
		console.error(`Failed to send Slack message: ${response.status}`);
	}
}
