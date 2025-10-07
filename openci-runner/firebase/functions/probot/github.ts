const runnerName = "openci-runner-beta";

// biome-ignore lint/suspicious/noExplicitAny: <Fill the type later>
export function isJobRequired(context: any): boolean {
	return context.payload.workflow_job.labels.includes(runnerName);
}
