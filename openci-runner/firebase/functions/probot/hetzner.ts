import type { Octokit } from "@octokit/rest";

const baseUrl = "https://api.hetzner.cloud/v1/servers";

export interface OctokitToken {
	token: string;
}

export async function deleteServer(id: string, apiKey: string) {
	await fetch(`${baseUrl}/${id}`, {
		method: "DELETE",
		headers: {
			Authorization: `Bearer ${apiKey}`,
		},
	});
}

export type HetznerResponse = {
	serverId: number;
	ipv4: string;
};

export async function createServer(apiKey: string): Promise<HetznerResponse> {
	const body = {
		name: crypto.randomUUID(),
		location: "fsn1",
		server_type: "cpx41",
		image: "ubuntu-24.04",
		ssh_keys: ["openci-runner-probot"],
	};

	const response = await fetch(baseUrl, {
		method: "POST",
		headers: {
			Authorization: `Bearer ${apiKey}`,
		},
		body: JSON.stringify(body),
	});

	const responseJson = await response.json();

	const server = responseJson.server;
	const ipv4 = server.public_net.ipv4.ip;

	const serverId = server.id;

	return {
		serverId: serverId,
		ipv4: ipv4,
	};
}

export async function getServerStatusById(
	serverId: number,
	apiKey: string,
): Promise<string> {
	const _response = await fetch(`${baseUrl}/${serverId}`, {
		headers: {
			Authorization: `Bearer ${apiKey}`,
		},
	});
	const jsonRes = await _response.json();
	return jsonRes.server.status;
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
			owner: `${owner}`,
			repo: `${repo}`,
			name: `OpenCI ランナー ${serverId}`,
			runner_group_id: 1,
			labels: ["openci-runner-beta"],
			work_folder: "_work",
			headers: {
				"X-GitHub-Api-Version": "2022-11-28",
			},
		},
	);

	return jitConfigRes.data.encoded_jit_config;
}

export function initRunner(runnerConfig: string): string {
	const command = `
mkdir actions-runner
cd actions-runner
curl -o actions-runner-linux-x64-2.328.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.328.0.tar.gz
tmux new -d -s runner "RUNNER_ALLOW_RUNASROOT=true ./run.sh --jitconfig ${runnerConfig}"
`;
	return command;
}
