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

describe("fetchIncusInstances", () => {
	const mockEnv = {
		cloudflare_access_client_id: "test-client-id",
		cloudflare_access_client_secret: "test-client-secret",
		server_url: "https://incus.example.com",
	};

	it("fetches instances with correct headers", async () => {
		mockFetch.mockResolvedValueOnce({
			json: async () => mockMetadata,
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
		});

		await expect(_fetchIncusInstances(mockEnv)).rejects.toThrow();
	});
});

describe("fetch available(stop) incus instances", () => {
	const mockEnv = {
		cloudflare_access_client_id: "test-client-id",
		cloudflare_access_client_secret: "test-client-secret",
		server_url: "https://incus.example.com",
	};

	it("fetch stopped instances", async () => {
		mockFetch.mockResolvedValueOnce({
			json: async () => mockMetadata,
		});

		const result = await fetchAvailableIncusInstances(mockEnv);
		expect(result.length).toEqual(1);
		expect(result[0]).toEqual({ name: "vm-1", status: "Stopped" });
	});
});
