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

const IncusOperationStatus = z.enum([
	"Pending",
	"Running",
	"Cancelling",
	"Cancelled",
	"Success",
	"Failure",
]);

const IncusResponseType = z.enum(["sync", "async", "error"]);

const IncusOperationMetadata = z.object({
	class: z.string().optional(),
	err: z.string().optional(),
	id: z.string().optional(),
	status: IncusOperationStatus.optional(),
	status_code: z.number().optional(),
});

const IncusAsyncResponse = z.object({
	metadata: IncusOperationMetadata.optional(),
	operation: z.string().optional(),
	status: z.string(),
	status_code: z.number(),
	type: IncusResponseType,
});

export type IncusAsyncResponse = z.infer<typeof IncusAsyncResponse>;

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

	const result = IncusAsyncResponse.parse(await response.json());

	if (result.type === IncusResponseType.enum.async && result.operation) {
		const operationId = result.operation.split("/").pop();
		if (operationId) {
			console.log(`Waiting for operation ${operationId} to complete...`);
			await waitForOperation(envData, operationId);
			console.log(`Operation ${operationId} completed successfully`);
		}
	}
}

export async function fetchStatusOfOperation(
	envData: IncusEnv,
	operationId: string,
): Promise<IncusAsyncResponse> {
	const baseUrl = envData.server_url;
	const operationUrl = `${baseUrl}/1.0/operations/${operationId}`;
	const cloudflareAccessHeaders = {
		"CF-Access-Client-Id": envData.cloudflare_access_client_id,
		"CF-Access-Client-Secret": envData.cloudflare_access_client_secret,
	};

	const response = await fetch(operationUrl, {
		headers: cloudflareAccessHeaders,
	});

	if (!response.ok) {
		throw new Error(
			`Failed to check operation status: ${response.status} ${response.statusText}`,
		);
	}

	return IncusAsyncResponse.parse(await response.json());
}

export async function waitForOperation(
	envData: IncusEnv,
	operationId: string,
	maxWaitMs = 5 * 60 * 1000,
	intervalMs = 2000,
): Promise<void> {
	const startTime = Date.now();

	while (Date.now() - startTime < maxWaitMs) {
		const result = await fetchStatusOfOperation(envData, operationId);
		const status = result.metadata?.status;
		const statusCode = result.metadata?.status_code;

		console.log(`Operation status: ${status} (code: ${statusCode})`);

		if (status === IncusOperationStatus.enum.Success || statusCode === 200) {
			return;
		}

		if (
			status === IncusOperationStatus.enum.Failure ||
			(statusCode && statusCode >= 400)
		) {
			throw new Error(`Operation failed: ${result.metadata?.err}`);
		}

		await new Promise((resolve) => setTimeout(resolve, intervalMs));
	}

	throw new Error(`Operation timed out after ${maxWaitMs / 1000} seconds`);
}
