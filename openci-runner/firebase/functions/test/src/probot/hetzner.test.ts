import { describe, expect, test } from "vitest";
import {
	createServer,
	createServerSpec,
	deleteServer,
	getServerStatusById,
} from "../../../lib/probot/hetzner.js";

describe("Hetzner", () => {
	test("delete a server", async () => {
		await deleteServer("id", "apiKey");
	});

	test("create a server spec", async () => {
		const imageName = "ubuntu-24.04";
		const location = "fsn1";
		const serverType = "cpx41";
		const sshKeyName = "openci-runner-probot";

		const spec = createServerSpec();
		expect(spec.image).toStrictEqual(imageName);
		expect(spec.location).toStrictEqual(location);
		expect(spec.name).toMatch(
			/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/,
		);
		expect(spec.server_type).toStrictEqual(serverType);
		expect(spec.ssh_keys[0]).toStrictEqual(sshKeyName);
	});

	test("create a server", async () => {
		const serverSpec = createServerSpec();
		const result = await createServer("api_key", serverSpec);
		expect(result.ipv4).toBe("1.1.1.1");
		expect(result.serverId).toBe("0");
	});

	test("get a server status", async () => {
		const result = await getServerStatusById("id", "apiKey");
		expect(result).toBe("running");
	});
});
