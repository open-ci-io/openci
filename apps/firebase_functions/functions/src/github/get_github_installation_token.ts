import jwt from "jsonwebtoken";
import axios, { isAxiosError } from "axios";

export async function getGitHubInstallationToken(
	installationId: number,
	appId: string,
	privateKey: string,
) {
	if (!appId || !privateKey || !installationId) {
		throw new Error("Missing required parameters");
	}

	try {
		const token = generateJWT(appId, privateKey);
		console.log(`jwtToken: ${token}`);
		const { data } = await axios.post(
			`https://api.github.com/app/installations/${installationId}/access_tokens`,
			{},
			{
				headers: {
					Accept: "application/vnd.github.v3+json",
					Authorization: `Bearer ${token}`,
				},
				timeout: 5000,
			},
		);

		console.log(`data: ${data}`);
		console.log(`data.token: ${data.token}`);

		return data.token;
	} catch (error) {
		if (isAxiosError(error)) {
			console.error("GitHub API error:", error.response?.data || error.message);
		}
		throw error;
	}
}

function generateJWT(appId: string, privateKey: string): string {
	const now = Math.floor(Date.now() / 1000);

	return jwt.sign(
		{
			iat: now - 60,
			exp: now + 10 * 60,
			iss: appId,
		},
		privateKey,
		{ algorithm: "RS256" },
	);
}
