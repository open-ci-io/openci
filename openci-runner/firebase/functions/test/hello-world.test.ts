import express from "express";
import request from "supertest";
import { beforeAll, describe, expect, it, vi } from "vitest";

vi.mock("firebase-functions/params", () => ({
	defineSecret: (name: string) => ({
		name,
		value: () => JSON.stringify({ projectId: "demo-project", appId: 123 }),
	}),
}));

// biome-ignore lint/suspicious/noExplicitAny: <explanation>
let helloWorld: (req: any, res: any) => unknown;

beforeAll(async () => {
	const mod = await import("../src/index");
	helloWorld = mod.githubWebhook;
});

describe("helloWorld", () => {
	it("Return 200 status code", async () => {
		const app = express();
		app.all("*", (req, res) => helloWorld(req, res));

		const res = await request(app).get("/");
		expect(res.status).toBe(200);
		expect(res.text).toBe("Hello from Firebase!");
	});
});
