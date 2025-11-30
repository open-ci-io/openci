import { afterEach, describe, expect, it, vi } from "vitest";
import {
	_fetchIncusInstances,
	createInstance,
	fetchAvailableIncusInstances,
	fetchStatusOfOperation,
	requestCreateInstance,
	waitForOperation,
} from "../../src/services/incus";

const mockFetch = vi.fn();
vi.stubGlobal("fetch", mockFetch);

afterEach(() => {
	vi.clearAllMocks();
});

const mockMetadata = {
	metadata: [
		{ name: "vm-0", status: "Running" },
		{ name: "vm-1", status: "Stopped" },
		{ name: "vm-2", status: "Frozen" },
		{ name: "vm-3", status: "Error" },
	],
};

const mockEnv = {
	cloudflare_access_client_id: "test-client-id",
	cloudflare_access_client_secret: "test-client-secret",
	server_url: "https://incus.example.com",
};

describe("fetchIncusInstances", () => {
	it("fetches instances with correct headers", async () => {
		mockFetch.mockResolvedValueOnce({
			json: async () => mockMetadata,
			ok: true,
		});

		const result = await _fetchIncusInstances(mockEnv);

		expect(mockFetch).toHaveBeenCalledWith(
			"https://incus.example.com/1.0/instances?recursion=1",
			{
				headers: {
					"CF-Access-Client-Id": "test-client-id",
					"CF-Access-Client-Secret": "test-client-secret",
				},
			},
		);
		expect(result.metadata).toHaveLength(4);
		expect(result.metadata).toEqual([
			{ name: "vm-0", status: "Running" },
			{ name: "vm-1", status: "Stopped" },
			{ name: "vm-2", status: "Frozen" },
			{ name: "vm-3", status: "Error" },
		]);
	});

	it("throws when response is invalid", async () => {
		mockFetch.mockResolvedValueOnce({
			json: async () => ({ invalid: "data" }),
			ok: true,
		});

		await expect(_fetchIncusInstances(mockEnv)).rejects.toThrow();
	});

	it("throws when response is not ok", async () => {
		mockFetch.mockResolvedValueOnce({
			ok: false,
			status: 500,
			statusText: "Internal Server Error",
		});

		await expect(_fetchIncusInstances(mockEnv)).rejects.toThrow(
			"Failed to fetch Incus instances: 500 Internal Server Error",
		);
	});

	it("throws when response is 401 Unauthorized", async () => {
		mockFetch.mockResolvedValueOnce({
			ok: false,
			status: 401,
			statusText: "Unauthorized",
		});

		await expect(_fetchIncusInstances(mockEnv)).rejects.toThrow(
			"Failed to fetch Incus instances: 401 Unauthorized",
		);
	});

	it("throws when response is 404 Not Found", async () => {
		mockFetch.mockResolvedValueOnce({
			ok: false,
			status: 404,
			statusText: "Not Found",
		});

		await expect(_fetchIncusInstances(mockEnv)).rejects.toThrow(
			"Failed to fetch Incus instances: 404 Not Found",
		);
	});
});

describe("fetch available(stop) incus instances", () => {
	it("fetch stopped instances", async () => {
		mockFetch.mockResolvedValueOnce({
			json: async () => mockMetadata,
			ok: true,
		});

		const result = await fetchAvailableIncusInstances(mockEnv);
		expect(result.length).toEqual(1);
		expect(result[0]).toEqual({ name: "vm-1", status: "Stopped" });
	});
});

describe("fetchStatusOfOperation", () => {
	it("fetches operation status", async () => {
		const mockResponse = {
			metadata: {
				id: "abc-123",
				status: "Running",
				status_code: 103,
			},
			status: "Success",
			status_code: 200,
			type: "sync",
		};

		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(mockResponse),
			ok: true,
		} as Response);

		const result = await fetchStatusOfOperation(mockEnv, "abc-123");

		expect(result.metadata?.status).toBe("Running");
		expect(fetch).toHaveBeenCalledWith(
			"https://incus.example.com/1.0/operations/abc-123",
			{
				headers: {
					"CF-Access-Client-Id": "test-client-id",
					"CF-Access-Client-Secret": "test-client-secret",
				},
			},
		);
	});

	it("throws when API returns an error", async () => {
		vi.mocked(fetch).mockResolvedValue({
			ok: false,
			status: 404,
			statusText: "Not Found",
		} as Response);

		await expect(fetchStatusOfOperation(mockEnv, "invalid-id")).rejects.toThrow(
			"Failed to check operation status: 404 Not Found",
		);
	});
});

const mockRunningResponse = {
	metadata: {
		id: "abc-123",
		status: "Running",
		status_code: 103,
	},
	status: "Success",
	status_code: 200,
	type: "sync",
};
const mockSuccessResponse = {
	metadata: {
		id: "abc-123",
		status: "Success",
		status_code: 200,
	},
	status: "Success",
	status_code: 200,
	type: "sync",
};

const mockFailureResponse = {
	metadata: {
		err: "Image not found",
		id: "abc-123",
		status: "Failure",
		status_code: 400,
	},
	status: "Success",
	status_code: 200,
	type: "sync",
};

const syncResponse = {
	status: "Success",
	status_code: 200,
	type: "sync",
};

const asyncResponse = {
	operation: "/1.0/operations/abc-123",
	status: "Operation created",
	status_code: 100,
	type: "async",
};

describe("waitForOperation", () => {
	it("waits until operation is Success", async () => {
		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(mockSuccessResponse),
			ok: true,
		} as Response);

		await waitForOperation(mockEnv, "abc-123", 10, 1);

		expect(fetch).toHaveBeenCalledWith(
			"https://incus.example.com/1.0/operations/abc-123",
			{
				headers: {
					"CF-Access-Client-Id": "test-client-id",
					"CF-Access-Client-Secret": "test-client-secret",
				},
			},
		);
	});
	it("three retries and Success", async () => {
		vi.mocked(fetch)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockRunningResponse),
				ok: true,
			} as Response)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockRunningResponse),
				ok: true,
			} as Response)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockSuccessResponse),
				ok: true,
			} as Response);

		await waitForOperation(mockEnv, "abc-123", 1000, 1);

		expect(fetch).toHaveBeenCalledTimes(3);
	});

	it("three retries and Fail", async () => {
		vi.mocked(fetch)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockRunningResponse),
				ok: true,
			} as Response)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockRunningResponse),
				ok: true,
			} as Response)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockFailureResponse),
				ok: true,
			} as Response);

		await expect(waitForOperation(mockEnv, "abc-123", 10, 1)).rejects.toThrow(
			"Operation failed: Image not found",
		);
		expect(fetch).toHaveBeenCalledTimes(3);
	});

	it("timeouts", async () => {
		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(mockRunningResponse),
			ok: true,
		} as Response);

		await expect(waitForOperation(mockEnv, "abc-123", 50, 10)).rejects.toThrow(
			"Operation timed out after 0.05 seconds",
		);
	});

	it("throws when fetch fails", async () => {
		vi.mocked(fetch).mockResolvedValue({
			ok: false,
			status: 500,
			statusText: "Internal Server Error",
		} as Response);

		await expect(waitForOperation(mockEnv, "abc-123", 10, 1)).rejects.toThrow(
			"Failed to check operation status: 500 Internal Server Error",
		);
	});

	it("handles Cancelled status as failure", async () => {
		const cancelledResponse = {
			metadata: {
				err: "Operation was cancelled",
				id: "abc-123",
				status: "Cancelled",
				status_code: 400,
			},
			status: "Success",
			status_code: 200,
			type: "sync",
		};

		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(cancelledResponse),
			ok: true,
		} as Response);

		await expect(waitForOperation(mockEnv, "abc-123", 10, 1)).rejects.toThrow(
			"Operation failed: Operation was cancelled",
		);
	});
});

describe("requestCreateInstance", () => {
	const mockEnv = {
		cloudflare_access_client_id: "test-client-id",
		cloudflare_access_client_secret: "test-client-secret",
		server_url: "https://incus.example.com",
	};

	it("sends correct request body with virtual-machine type", async () => {
		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(asyncResponse),
			ok: true,
		} as Response);

		await requestCreateInstance(mockEnv, "test-instance", "test-image");

		expect(fetch).toHaveBeenCalledWith(
			"https://incus.example.com/1.0/instances",
			{
				body: JSON.stringify({
					name: "test-instance",
					source: {
						alias: "test-image",
						type: "image",
					},
					type: "virtual-machine",
				}),
				headers: {
					"CF-Access-Client-Id": "test-client-id",
					"CF-Access-Client-Secret": "test-client-secret",
					"Content-Type": "application/json",
				},
				method: "POST",
			},
		);
	});

	it("returns operation ID for async response", async () => {
		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(asyncResponse),
			ok: true,
		} as Response);

		const result = await requestCreateInstance(
			mockEnv,
			"test-instance",
			"test-image",
		);

		expect(result).toBe("abc-123");
	});

	it("returns undefined for sync response", async () => {
		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(syncResponse),
			ok: true,
		} as Response);

		const result = await requestCreateInstance(
			mockEnv,
			"test-instance",
			"test-image",
		);

		expect(result).toBeUndefined();
	});

	it("throws when API returns error status", async () => {
		vi.mocked(fetch).mockResolvedValue({
			ok: false,
			status: 400,
			statusText: "Bad Request",
		} as Response);

		await expect(
			requestCreateInstance(mockEnv, "test-instance", "test-image"),
		).rejects.toThrow("Failed to create Incus instance: 400 Bad Request");
	});

	it("throws when API returns 409 Conflict (instance already exists)", async () => {
		vi.mocked(fetch).mockResolvedValue({
			ok: false,
			status: 409,
			statusText: "Conflict",
		} as Response);

		await expect(
			requestCreateInstance(mockEnv, "existing-instance", "test-image"),
		).rejects.toThrow("Failed to create Incus instance: 409 Conflict");
	});

	it("throws when operation path is empty string", async () => {
		const invalidAsyncResponse = {
			operation: "",
			status: "Operation created",
			status_code: 100,
			type: "async",
		};

		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(invalidAsyncResponse),
			ok: true,
		} as Response);

		await expect(
			requestCreateInstance(mockEnv, "test-instance", "test-image"),
		).rejects.toThrow("Invalid operation path format: ");
	});

	it("throws when operation path ends with slash", async () => {
		const invalidAsyncResponse = {
			operation: "/1.0/operations/",
			status: "Operation created",
			status_code: 100,
			type: "async",
		};

		vi.mocked(fetch).mockResolvedValue({
			json: () => Promise.resolve(invalidAsyncResponse),
			ok: true,
		} as Response);

		await expect(
			requestCreateInstance(mockEnv, "test-instance", "test-image"),
		).rejects.toThrow("Invalid operation path format: /1.0/operations/");
	});
});

describe("createInstance", () => {
	const mockEnv = {
		cloudflare_access_client_id: "test-client-id",
		cloudflare_access_client_secret: "test-client-secret",
		server_url: "https://incus.example.com",
	};

	it("creates instance and waits for operation to complete", async () => {
		vi.mocked(fetch)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(asyncResponse),
				ok: true,
			} as Response)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockSuccessResponse),
				ok: true,
			} as Response);

		await createInstance(mockEnv, "test-instance", "test-image");

		expect(fetch).toHaveBeenCalledTimes(2);
		expect(fetch).toHaveBeenNthCalledWith(
			1,
			"https://incus.example.com/1.0/instances",
			expect.objectContaining({ method: "POST" }),
		);
		expect(fetch).toHaveBeenNthCalledWith(
			2,
			"https://incus.example.com/1.0/operations/abc-123",
			expect.objectContaining({
				headers: {
					"CF-Access-Client-Id": "test-client-id",
					"CF-Access-Client-Secret": "test-client-secret",
				},
			}),
		);
	});

	it("completes immediately for sync response without waiting", async () => {
		vi.mocked(fetch).mockResolvedValueOnce({
			json: () => Promise.resolve(syncResponse),
			ok: true,
		} as Response);

		await createInstance(mockEnv, "test-instance", "test-image");

		expect(fetch).toHaveBeenCalledTimes(1);
	});

	it("throws when instance creation fails", async () => {
		vi.mocked(fetch).mockResolvedValue({
			ok: false,
			status: 500,
			statusText: "Internal Server Error",
		} as Response);

		await expect(
			createInstance(mockEnv, "test-instance", "test-image"),
		).rejects.toThrow(
			"Failed to create Incus instance: 500 Internal Server Error",
		);
	});

	it("throws when operation fails", async () => {
		vi.mocked(fetch)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(asyncResponse),
				ok: true,
			} as Response)
			.mockResolvedValueOnce({
				json: () => Promise.resolve(mockFailureResponse),
				ok: true,
			} as Response);

		await expect(
			createInstance(mockEnv, "test-instance", "test-image"),
		).rejects.toThrow("Operation failed: Image not found");
	});
});
