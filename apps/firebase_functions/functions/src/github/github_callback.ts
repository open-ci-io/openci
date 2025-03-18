import { onRequest } from "firebase-functions/https";
import axios from "axios";

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

		if (state !== "foo") {
			res.status(400).send("Invalid state parameter");
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

			// 3. ここで、Firebase Authのuid（別途クライアント側で管理している情報と照合する）と、
			//    GitHubユーザー情報（githubUser.id, githubUser.login）を紐づける処理を追加可能
			//    例えば、Firestoreに保存するなどして、後続の処理で参照できるようにする

			res.status(200).json({
				accessToken, // GitHubアクセストークン
				githubUserId: githubUser.id,
				githubLogin: githubUser.login,
			});
		} catch (error) {
			console.error("OAuth callback processing error:", error);

			// errorはunknown型なので、適切に型チェックを行う
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
