import type { Octokit } from "@octokit/rest";

const runnerName = "openci-runner-beta";

// biome-ignore lint/suspicious/noExplicitAny: <Fill the type later>
export function isJobRequired(context: any): boolean {
	return context.payload.workflow_job.labels.includes(runnerName);
}

export async function getJitConfig(
	octokit: Octokit,
	owner: string,
	repo: string,
	serverId: number,
): Promise<string> {
	const jitConfigRes = await octokit.request(
		`POST /repos/{owner}/{repo}/actions/runners/generate-jitconfig`,
		{
			headers: {
				"X-GitHub-Api-Version": "2022-11-28",
			},
			labels: ["openci-runner-beta"],
			name: `OpenCI ランナー ${serverId}`,
			owner: `${owner}`,
			repo: `${repo}`,
			runner_group_id: 1,
			work_folder: "_work",
		},
	);

	return jitConfigRes.data.encoded_jit_config;
}
