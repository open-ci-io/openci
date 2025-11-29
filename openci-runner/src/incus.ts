import z from "zod";

const IncusStatus = z.enum(["Running", "Stopped", "Frozen", "Error"]);

const IncusProperty = z.object({
	name: z.string(),
	status: IncusStatus,
});

export type IncusProperty = z.infer<typeof IncusProperty>;

export const IncusInstancesResponse = z.object({
	metadata: z.array(IncusProperty),
});

export type IncusInstancesResponse = z.infer<typeof IncusInstancesResponse>;

type IncusEnv = {
	cloudflare_access_client_id: string;
	cloudflare_access_client_secret: string;
	server_url: string;
};

export async function _fetchIncusInstances(
	envData: IncusEnv,
): Promise<IncusInstancesResponse> {
	const baseUrl = envData.server_url;
	const instanceUrl = `${baseUrl}/1.0/instances`;
	const cloudflareAccessHeaders = {
		"CF-Access-Client-Id": envData.cloudflare_access_client_id,
		"CF-Access-Client-Secret": envData.cloudflare_access_client_secret,
	};

	const recursionRes = await fetch(`${instanceUrl}?recursion=1`, {
		headers: cloudflareAccessHeaders,
	});

	return IncusInstancesResponse.parse(await recursionRes.json());
}

export async function fetchAvailableIncusInstances(
	envData: IncusEnv,
): Promise<IncusProperty[]> {
	const res = await _fetchIncusInstances(envData);
	return res.metadata.filter((e) => e.status === IncusStatus.enum.Stopped);
}
