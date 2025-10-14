import type { Octokit } from "@octokit/rest";

const runnerName = "openci-runner-beta";

// biome-ignore lint/suspicious/noExplicitAny: <Fill the type later>
export function isJobRequired(context: any): boolean {
	return context.payload.workflow_job.labels.includes(runnerName);
}

const generateJitConfigPath =
	"/repos/{owner}/{repo}/actions/runners/generate-jitconfig";

type JitConfigRequest = {
	headers: Record<string, string>;
	labels: string[];
	name: string;
	owner: string;
	repo: string;
	runner_group_id: number;
	work_folder: string;
};

export function jitConfigRequestBody(
	owner: string,
	repo: string,
	serverId: number,
): JitConfigRequest {
	return {
		headers: {
			"X-GitHub-Api-Version": "2022-11-28",
		},
		labels: ["openci-runner-beta"],
		name: `OpenCI ランナー ${serverId}`,
		owner: `${owner}`,
		repo: `${repo}`,
		runner_group_id: 1,
		work_folder: "_work",
	};
}

export async function getJitConfig(
	octokit: Octokit,
	owner: string,
	repo: string,
	serverId: number,
): Promise<string> {
	const body = jitConfigRequestBody(owner, repo, serverId);
	const jitConfigRes = await octokit.request(
		`POST ${generateJitConfigPath}`,
		body,
	);

	return jitConfigRes.data.encoded_jit_config;
}

export enum ActionsRunnerOS {
	osx = "osx",
	linux = "linux",
}

export enum ActionsRunnerArchitecture {
	x64 = "x64",
	arm64 = "arm64",
}

const mkdir = "mkdir actions-runner";

const cdActionRunner = "cd actions-runner";

function downloadRunnerScriptAndUnZip(
	scriptVersion: string,
	os: ActionsRunnerOS,
	architecture: ActionsRunnerArchitecture,
) {
	const fileName = `actions-runner-${os}-${architecture}-${scriptVersion}.tar.gz`;
	return `curl -o ${fileName} -L https://github.com/actions/runner/releases/download/v${scriptVersion}/${fileName} && tar xzf ./${fileName}`;
}

function runGHAScript(runnerConfig: string): string {
	return `tmux new -d -s runner "RUNNER_ALLOW_RUNASROOT=true ./run.sh --jitconfig ${runnerConfig}"`;
}

export function initRunner(
	scriptVersion: string,
	os: ActionsRunnerOS,
	architecture: ActionsRunnerArchitecture,
): string {
	const command = [
		mkdir,
		cdActionRunner,
		downloadRunnerScriptAndUnZip(scriptVersion, os, architecture),
	];
	return command.join(" && ");
}

export function startRunner(runnerConfig: string): string {
	const command = [cdActionRunner, runGHAScript(runnerConfig)];
	return command.join(" && ");
}
