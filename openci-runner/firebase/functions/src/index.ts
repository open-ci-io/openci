import { cert, initializeApp } from "firebase-admin/app";
import { logger } from "firebase-functions";
import { defineInt, defineSecret } from "firebase-functions/params";
import { onRequest } from "firebase-functions/v2/https";
import { type ApplicationFunction, Probot } from "probot";
import githubApp from "../../../github-apps/src";

const firebaseServiceAccount = defineSecret("FB_SERVICE_ACCOUNT");

export const helloWorld = onRequest(
	{ secrets: [firebaseServiceAccount] },
	(req, res) => {
		const serviceAccountJson = JSON.parse(firebaseServiceAccount.value());
		serviceAccountJson;
		logger.info("Hello logs!", { structuredData: true });
		res.send("Hello from Firebase!");
	},
);

const githubAppId = defineInt("GITHUB_APP_ID");
const githubPrivateKey = defineSecret("GITHUB_PRIVATE_KEY");
const githubWebhookSecret = defineSecret("GITHUB_WEBHOOK_SECRET");

const createProbot = ({
	appId,
	privateKey,
	webhookSecret,
}: {
	appId: string;
	privateKey: string;
	webhookSecret: string;
}) => {
	const probot = new Probot({
		appId,
		privateKey: privateKey.replace(/\\n/g, "\n"),
		secret: webhookSecret,
	});

	const appLoader = githubApp as unknown as ApplicationFunction;
	probot.load(appLoader);
	return probot;
};

export const githubWebhook = onRequest(
	{
		secrets: [firebaseServiceAccount, githubPrivateKey, githubWebhookSecret],
	},
	async (req, res) => {
		if (req.method === "GET") {
			res.status(200).send({ status: "ok" });
			return;
		}

		if (req.method !== "POST") {
			res.setHeader("Allow", "GET, POST");
			res.status(405).send("Method Not Allowed");
			return;
		}

		try {
			initializeApp({
				credential: cert(firebaseServiceAccount.value()),
			});

			const probot = createProbot({
				appId: githubAppId.value().toString(),
				privateKey: githubPrivateKey.value(),
				webhookSecret: githubWebhookSecret.value(),
			});

			const deliveryId = req.header("x-github-delivery");
			const eventName = req.header("x-github-event");
			const signature = req.header("x-hub-signature-256");

			if (!deliveryId || !eventName || !signature) {
				res.status(400).send("Missing GitHub webhook headers");
				return;
			}

			const payload =
				req.rawBody?.toString("utf8") ?? JSON.stringify(req.body ?? {});

			await probot.webhooks.verifyAndReceive({
				id: deliveryId,
				// biome-ignore lint/suspicious/noExplicitAny: <explanation>
				name: eventName as any,
				payload,
				signature,
			});

			res.status(202).send("Accepted");
		} catch (error) {
			logger.error("Failed to handle GitHub webhook", error);
			res.status(500).send("Internal Server Error");
		}
	},
);
