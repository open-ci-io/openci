import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { Probot } from "probot";
import { afterEach, beforeEach, describe, test } from "vitest";
import { appFn } from "../../lib/probot/index.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const privateKey = fs.readFileSync(
	path.join(__dirname, "../fixtures/mock-cert.pem"),
	"utf-8",
);

const payload = JSON.parse(
	fs.readFileSync(
		path.join(__dirname, "../fixtures/issues.opened.json"),
		"utf-8",
	),
);

describe("Probot App", () => {
	let probot: Probot;

	beforeEach(() => {
		probot = new Probot({
			appId: 123,
			privateKey,
		});
		probot.load(appFn);
	});

	test("creates a comment when an issue is opened", async () => {
		await probot.receive({
			id: "",
			name: "issues",
			payload,
		});
	});

	afterEach(() => {});
});

// export async function deleteServer(id: string, apiKey: string) {
// 	await fetch(`${baseUrl}/${id}`, {
// 		headers: {
// 			Authorization: `Bearer ${apiKey}`,
// 		},
// 		method: "DELETE",
// 	});
// }
