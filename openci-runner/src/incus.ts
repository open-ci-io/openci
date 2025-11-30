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

	if (!recursionRes.ok) {
		throw new Error(
			`Failed to fetch Incus instances: ${recursionRes.status} ${recursionRes.statusText}`,
		);
	}

	return IncusInstancesResponse.parse(await recursionRes.json());
}

export async function fetchAvailableIncusInstances(
	envData: IncusEnv,
): Promise<IncusProperty[]> {
	const res = await _fetchIncusInstances(envData);
	return res.metadata.filter((e) => e.status === IncusStatus.enum.Stopped);
}

type IncusAsyncResponse = {
	type: string;
	status: string;
	status_code: number;
	operation: string;
	metadata?: {
		id?: string;
		class?: string;
		status?: string;
		status_code?: number;
		err?: string;
	};
};

export async function createInstance(
	envData: IncusEnv,
	instanceName: string,
	imageName: string,
): Promise<void> {
	const baseUrl = envData.server_url;
	const instanceUrl = `${baseUrl}/1.0/instances`;
	const cloudflareAccessHeaders = {
		"CF-Access-Client-Id": envData.cloudflare_access_client_id,
		"CF-Access-Client-Secret": envData.cloudflare_access_client_secret,
		"Content-Type": "application/json",
	};

	const requestBody = {
		name: instanceName,
		source: {
			alias: imageName,
			type: "image",
		},
	};

	const response = await fetch(instanceUrl, {
		body: JSON.stringify(requestBody),
		headers: cloudflareAccessHeaders,
		method: "POST",
	});

	if (!response.ok) {
		throw new Error(
			`Failed to create Incus instance: ${response.status} ${response.statusText}`,
		);
	}

	const result = (await response.json()) as IncusAsyncResponse;

	// 操作の完了を待つ
	if (result.type === "async" && result.metadata?.id) {
		await waitForOperation(envData, result.metadata.id);
	}
}

async function waitForOperation(
	envData: IncusEnv,
	operationId: string,
	maxWaitMs = 5 * 60 * 1000, // 5分
	intervalMs = 2000, // 2秒間隔
): Promise<void> {
	const baseUrl = envData.server_url;
	const operationUrl = `${baseUrl}/1.0/operations/${operationId}/wait`;
	const cloudflareAccessHeaders = {
		"CF-Access-Client-Id": envData.cloudflare_access_client_id,
		"CF-Access-Client-Secret": envData.cloudflare_access_client_secret,
	};

	const startTime = Date.now();

	while (Date.now() - startTime < maxWaitMs) {
		const response = await fetch(`${operationUrl}?timeout=30`, {
			headers: cloudflareAccessHeaders,
		});

		if (!response.ok) {
			throw new Error(
				`Failed to check operation status: ${response.status} ${response.statusText}`,
			);
		}

		const result = (await response.json()) as IncusAsyncResponse;
		const statusCode = result.metadata?.status_code;

		// 200 = Success
		if (statusCode === 200) {
			return;
		}

		// 400+ = Failure
		if (statusCode && statusCode >= 400) {
			throw new Error(`Operation failed: ${result.metadata?.err}`);
		}

		// 100-199 = Running/Pending の場合は再試行
		await new Promise((resolve) => setTimeout(resolve, intervalMs));
	}

	throw new Error(`Operation timed out after ${maxWaitMs / 1000} seconds`);
}
