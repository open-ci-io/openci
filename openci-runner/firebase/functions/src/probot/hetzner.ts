const baseUrl = "https://api.hetzner.cloud/v1/servers";

export interface OctokitToken {
	token: string;
}

export interface HetznerResponse {
	serverId: number;
	ipv4: string;
}

export interface HetznerServerSpec {
	image: string;
	location: string;
	name: string;
	server_type: string;
	ssh_keys: [string];
}

export async function deleteServer(id: string, apiKey: string) {
	await fetch(`${baseUrl}/${id}`, {
		headers: {
			Authorization: `Bearer ${apiKey}`,
		},
		method: "DELETE",
	});
}

export function createServerSpec(
	image: string = "ubuntu-24.04",
	location: string = "fsn1",
	name: string = crypto.randomUUID(),
	serverType: string = "cpx41",
	sshKeyName: string = "openci-runner-probot",
): HetznerServerSpec {
	return {
		image: image,
		location: location,
		name: name,
		server_type: serverType,
		ssh_keys: [sshKeyName],
	};
}

export async function createServer(
	apiKey: string,
	serverSpec: HetznerServerSpec,
): Promise<HetznerResponse> {
	const response = await fetch(baseUrl, {
		body: JSON.stringify(serverSpec),
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
