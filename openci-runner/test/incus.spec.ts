import { afterEach, describe, expect, it, vi } from "vitest";
import {
	_fetchIncusInstances,
	fetchAvailableIncusInstances,
	fetchStatusOfOperation,
	waitForOperation,
} from "../src/incus";

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

describe("waitForOperation", () => {
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
