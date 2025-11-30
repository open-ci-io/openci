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
		type: "virtual-machine",
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
	console.log("Incus instance creation initiated");

	const result = (await response.json()) as IncusAsyncResponse;

	if (result.type === "async" && result.operation) {
		const operationId = result.operation.split("/").pop();
		if (operationId) {
			console.log(`Waiting for operation ${operationId} to complete...`);
			await waitForOperation(envData, operationId);
			console.log(`Operation ${operationId} completed successfully`);
		}
	}
}

async function waitForOperation(
	envData: IncusEnv,
	operationId: string,
	maxWaitMs = 5 * 60 * 1000,
	intervalMs = 2000,
): Promise<void> {
	const baseUrl = envData.server_url;
	const operationUrl = `${baseUrl}/1.0/operations/${operationId}`;
	const cloudflareAccessHeaders = {
		"CF-Access-Client-Id": envData.cloudflare_access_client_id,
		"CF-Access-Client-Secret": envData.cloudflare_access_client_secret,
	};

	const startTime = Date.now();

	while (Date.now() - startTime < maxWaitMs) {
		const response = await fetch(operationUrl, {
			headers: cloudflareAccessHeaders,
		});

		if (response.status === 404) {
			console.log("Operation not found, assuming completed");
			return;
		}

		if (!response.ok) {
			throw new Error(
				`Failed to check operation status: ${response.status} ${response.statusText}`,
			);
		}

		const result = (await response.json()) as IncusAsyncResponse;
		const status = result.metadata?.status;
		const statusCode = result.metadata?.status_code;

		console.log(`Operation status: ${status} (code: ${statusCode})`);

		if (status === "Success" || statusCode === 200) {
			return;
		}

		if (status === "Failure" || (statusCode && statusCode >= 400)) {
			throw new Error(`Operation failed: ${result.metadata?.err}`);
		}

		await new Promise((resolve) => setTimeout(resolve, intervalMs));
	}

	throw new Error(`Operation timed out after ${maxWaitMs / 1000} seconds`);
}
