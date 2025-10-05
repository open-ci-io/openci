import { onRequest } from "firebase-functions/https";
import { defineSecret } from "firebase-functions/params";

import { logger } from "firebase-functions";

const firebaseServiceAccount = defineSecret("FB_SERVICE_ACCOUNT");
const githubAppId = defineSecret("GITHUB_APP_ID");
// const githubPrivateKey = defineSecret("GITHUB_PRIVATE_KEY");
// const githubWebhookSecret = defineSecret("GITHUB_WEBHOOK_SECRET");

// export const probotApp = createNodeMiddleware(appFn, {
// 	probot: createProbot({
// 		overrides: {
// 			appId: githubAppId.value(),
// 			privateKey: githubPrivateKey.value(),
// 			secret: githubWebhookSecret.value(),
// 		},
// 	}),
// 	webhooksPath: "/",
// });

export const githubWebhook = onRequest(
	{
		secrets: [
			firebaseServiceAccount,
			githubAppId,
			// githubPrivateKey,
			// githubWebhookSecret,
		],
	},
	(req, res) => {
		const serviceAccountJson = JSON.parse(firebaseServiceAccount.value());
		serviceAccountJson;
		const ghaAppId = JSON.parse(githubAppId.value());
		ghaAppId;

// 	createNodeMiddleware(appFn, {
// 	probot: createProbot({
// 		overrides: {
// 			appId: githubAppId.value(),
// 			privateKey: githubPrivateKey.value(),
// 			secret: githubWebhookSecret.value(),
// 		},
// 	}),
// 	webhooksPath: "/",
// });
		logger.info("Hello logs!", { structuredData: true });
		res.send("Hello from Firebase!");
	},
);
