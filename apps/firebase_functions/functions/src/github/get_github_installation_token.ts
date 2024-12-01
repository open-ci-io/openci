import { createAppAuth } from "@octokit/auth-app";
import { Octokit } from "@octokit/rest";

export async function getGitHubInstallationToken(
	installationId: number,
	appId: string,
	privateKey: string,
) {
	if (!appId || !privateKey || !installationId) {
		throw new Error("Missing required parameters");
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
		const { data } = await appOctokit.rest.apps.createInstallationAccessToken({
			installation_id: installationId,
		});
		return data.token;
	} catch (error) {
		console.error("Error creating installation token:", error);
		throw error;
	}
}
