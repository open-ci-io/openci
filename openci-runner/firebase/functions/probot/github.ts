import type { Octokit } from "@octokit/rest";
import { Env } from "./index.js";

function runnerName(env: Env) {
	if (env === Env.dev) {
		return "openci-runner-beta-dev";
	} else {
		return "openci-runner-beta";
	}
}

// biome-ignore lint/suspicious/noExplicitAny: <Fill the type later>
export function isJobRequired(context: any): boolean {
	return context.payload.workflow_job.labels.includes(runnerName);
}

export async function getJitConfig(
	octokit: Octokit,
	owner: string,
	repo: string,
	serverId: number,
	env: Env,
): Promise<string> {
	let name: string;
	if (env === Env.dev) {
		name = `OpenCI ランナー 開発環境 ${serverId}`;
	} else {
		name = `OpenCI ランナー ${serverId}`;
	}
	const jitConfigRes = await octokit.request(
		`POST /repos/{owner}/{repo}/actions/runners/generate-jitconfig`,
		{
			headers: {
				"X-GitHub-Api-Version": "2022-11-28",
			},
			labels: [runnerName(env)],
			name: name,
			owner: `${owner}`,
			repo: `${repo}`,
			runner_group_id: 1,
			work_folder: "_work",
		},
	);

	return jitConfigRes.data.encoded_jit_config;
}
