import { logger } from "firebase-functions";
import { onRequest } from "firebase-functions/https";
import { defineSecret } from "firebase-functions/params";

const firebaseServiceAccount = defineSecret("FB_SERVICE_ACCOUNT");

export const githubWebhook = onRequest(
	{ secrets: [firebaseServiceAccount] },
	(req, res) => {
		const serviceAccountJson = JSON.parse(firebaseServiceAccount.value());
		serviceAccountJson;
		logger.info("Hello logs!", { structuredData: true });
		res.send("Hello from Firebase!");
	},
);
