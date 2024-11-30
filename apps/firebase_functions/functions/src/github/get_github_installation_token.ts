import { onRequest } from "firebase-functions/https";
import { createAppAuth } from "@octokit/auth-app";
import { Octokit } from "@octokit/rest";

export const getGitHubInstallationToken = onRequest(
	{ secrets: ["APP_ID", "PRIVATE_KEY"] },
	async (req, res) => {
		if (req.method !== "POST") {
			res.status(405).send("Method Not Allowed");
			return;
		}

		const appId = process.env.APP_ID;
		const privateKey = process.env.PRIVATE_KEY;
		const { installationId } = req.body;

		if (!appId || !privateKey || !installationId) {
			res.status(400).send("Missing required parameters");
			return;
		}

		const appOctokit = new Octokit({
			authStrategy: createAppAuth,
			auth: {
				appId: appId,
				privateKey: privateKey,
				installationId: installationId,
			},
		});

		try {
			const { data } = await appOctokit.rest.apps.createInstallationAccessToken(
				{
					installation_id: installationId,
				},
			);

			res.status(200).json({ installationToken: data.token });
		} catch (error) {
			console.error("Error creating installation token:", error);
			res.status(500).send("Internal Server Error");
		}
	},
);
