import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import nock from "nock";
import { Probot } from "probot";
import { afterEach, beforeEach, describe, expect, test } from "vitest";
import { appFn } from "../lib/probot/index.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const privateKey = fs.readFileSync(
	path.join(__dirname, "fixtures/mock-cert.pem"),
	"utf-8",
);

const payload = JSON.parse(
	fs.readFileSync(path.join(__dirname, "fixtures/issues.opened.json"), "utf-8"),
);

nock.disableNetConnect();

describe("My Probot app", () => {
	let probot: Probot;

	const appId = 123;

	beforeEach(() => {
		nock.disableNetConnect();
		probot = new Probot({
			appId: appId,
			privateKey,
		});
		probot.load(appFn);
	});

	test("creates a comment when an issue is opened", async () => {
		const issueCreatedBody = { body: "Hello, World!" };

		nock("https://api.github.com")
			.post("/app/installations/2/access_tokens")
			.reply(200, { token: "test" });

		// Test that a comment is posted
		nock("https://api.github.com")
			.post("/repos/hiimbex/testing-things/issues/1/comments", (body) => {
				expect(body).toEqual(issueCreatedBody);
				return true;
			})
			.reply(200);

		// Receive a webhook event
		await probot.receive({
			id: "",
			name: "issues",
			payload,
		});

		expect(nock.isDone()).toBe(true);
	});

	afterEach(() => {
		nock.cleanAll();
		nock.enableNetConnect();
	});
});
