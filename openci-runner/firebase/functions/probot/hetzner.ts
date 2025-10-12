const baseUrl = "https://api.hetzner.cloud/v1/servers";

export interface OctokitToken {
	token: string;
}

export async function deleteServer(id: string, apiKey: string) {
	await fetch(`${baseUrl}/${id}`, {
		headers: {
			Authorization: `Bearer ${apiKey}`,
		},
		method: "DELETE",
	});
}

export type HetznerResponse = {
	serverId: number;
	ipv4: string;
};

export async function createServer(apiKey: string): Promise<HetznerResponse> {
	const body = {
		image: "ubuntu-24.04",
		location: "fsn1",
		name: crypto.randomUUID(),
		server_type: "cpx41",
		ssh_keys: ["openci-runner-probot"],
	};

	const response = await fetch(baseUrl, {
		body: JSON.stringify(body),
		headers: {
			Authorization: `Bearer ${apiKey}`,
		},
		method: "POST",
	});

	const responseJson = await response.json();

	const server = responseJson.server;
	const ipv4 = server.public_net.ipv4.ip;

	const serverId = server.id;

	return {
		ipv4: ipv4,
		serverId: serverId,
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
