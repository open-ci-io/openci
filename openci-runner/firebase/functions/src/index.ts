import { onRequest } from "firebase-functions/https";
import { defineSecret } from "firebase-functions/params";
import { createNodeMiddleware, createProbot } from "probot";

import { appFn } from "../probot/index.js";

const githubAppId = defineSecret("GITHUB_APP_ID");
const githubPrivateKey = defineSecret("GITHUB_PRIVATE_KEY");
const githubWebhookSecret = defineSecret("GITHUB_WEBHOOK_SECRET");

export const githubWebhook = onRequest(
	{
		secrets: [githubAppId, githubPrivateKey, githubWebhookSecret],
	},
	async (req, res) => {
		const probot = await createNodeMiddleware(appFn, {
			probot: createProbot({
				overrides: {
					appId: githubAppId.value(),
					privateKey: githubPrivateKey.value(),
					secret: githubWebhookSecret.value(),
				},
			}),
			webhooksPath: "/",
		});

		probot(req, res, () => {
			res.writeHead(404);
			res.end();
		});
	},
);
