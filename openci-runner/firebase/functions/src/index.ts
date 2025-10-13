import { onRequest } from "firebase-functions/https";
import { log } from "firebase-functions/logger";
import { defineSecret } from "firebase-functions/params";
import { createNodeMiddleware, createProbot } from "probot";
import { appFn } from "./probot/index.js";

const githubAppId = defineSecret("GITHUB_APP_ID");
const githubPrivateKey = defineSecret("GITHUB_PRIVATE_KEY");
const githubWebhookSecret = defineSecret("GITHUB_WEBHOOK_SECRET");

const hetznerApiKey = defineSecret("HETZNER_API_KEY");
const hetznerSshPassphrase = defineSecret("HETZNER_SSH_PASSPHRASE");
const hetznerSshPrivateKey = defineSecret("HETZNER_SSH_PRIVATE_KEY");

export const githubWebhook = onRequest(
	{
		cpu: 8,
		memory: "16GiB",
		secrets: [
			githubAppId,
			githubPrivateKey,
			githubWebhookSecret,
			hetznerApiKey,
			hetznerSshPassphrase,
			hetznerSshPrivateKey,
		],
		timeoutSeconds: 300,
	},
	async (req, res) => {
		log("githubWebhook has started");
		const probot = await createNodeMiddleware(appFn, {
			probot: createProbot({
				env: {
					HETZNER_API_KEY: hetznerApiKey.value(),
					HETZNER_SSH_PASSPHRASE: hetznerSshPassphrase.value(),
					HETZNER_SSH_PRIVATE_KEY: hetznerSshPrivateKey.value(),
				},
				overrides: {
					appId: githubAppId.value(),
					privateKey: githubPrivateKey.value(),
					secret: githubWebhookSecret.value(),
				},
			}),
			webhooksPath: "/",
		});

		await probot(req, res, () => {
			res.writeHead(404);
			res.end();
		});
		return;
	},
);
