import { afterEach, describe, expect, it, vi } from "vitest";
import {
	_fetchIncusInstances,
	fetchAvailableIncusInstances,
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
