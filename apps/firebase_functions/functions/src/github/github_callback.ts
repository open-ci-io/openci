import { onRequest } from "firebase-functions/https";
import axios from "axios";
import { firestore } from "../index.js";
import { usersCollectionName } from "../firestore_path.js";

export const githubCallback = onRequest(
	{ secrets: ["CLIENT_ID", "CLIENT_SECRET"] },
	async (req, res) => {
		const { code, state } = req.query;
		if (!code || !state) {
			res.status(400).send("Missing code or state parameter");
			return;
		}

		console.log("code", code);
		console.log("state", state);

		const userQs = await firestore
			.collection(usersCollectionName)
			.where("userId", "==", state)
			.get();

		if (userQs.docs.length === 0) {
			res.status(400).send("Could not find OpenCI user");
			return;
		}

		try {
			const tokenResponse = await axios.post(
				"https://github.com/login/oauth/access_token",
				{
					client_id: process.env.CLIENT_ID,
					client_secret: process.env.CLIENT_SECRET,
					code,
					state,
				},
				{ headers: { Accept: "application/json" } },
			);

			const accessToken = tokenResponse.data.access_token;
			if (!accessToken) {
				throw new Error("Failed to obtain access token");
			}

			const userResponse = await axios.get("https://api.github.com/user", {
				headers: { Authorization: `token ${accessToken}` },
			});

			const githubUser = userResponse.data;

			console.log("githubUser", githubUser);
			console.log("userId", githubUser.id);
			console.log("login", githubUser.login);

			await firestore
				.collection(usersCollectionName)
				.doc(userQs.docs[0].id)
				.update({
					github: {
						userId: githubUser.id,
						login: githubUser.login,
					},
				});

			res.status(200).json({
				accessToken,
				githubUserId: githubUser.id,
				githubLogin: githubUser.login,
			});
		} catch (error) {
			console.error("OAuth callback processing error:", error);

			if (error instanceof Error) {
				res
					.status(500)
					.send(`Error processing OAuth callback: ${error.message}`);
			} else {
				res
					.status(500)
					.send("Error processing OAuth callback: Unknown error occurred");
			}
		}
	},
);
