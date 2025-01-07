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
		// biome-ignore lint/suspicious/noExplicitAny: <explanation>
	} catch (error: any) {
		/**
		 * Octokit 経由でのエラーは多岐にわたりますが、
		 * - error.status にステータスコードが入っている
		 * - error.message にメッセージが入っている
		 * というケースが多いです。
		 *
		 * ここでステータスコードやメッセージを判定し、
		 * 特定のエラー（たとえばタイムアウトや GitHub 側の 5xx エラーなど）に
		 * 適したメッセージをユーザーに返すようにします。
		 */
		if (error.status === 504 || /timed out/i.test(error.message)) {
			throw new Error(
				"We couldn't respond to your request in time. Sorry about that. " +
					"Please try resubmitting your request and contact us if the problem persists.",
			);
		}
		if (error.status >= 500) {
			throw new Error(
				"GitHub service is currently experiencing issues (5xx). " +
					"Please try again later. If the problem persists, contact us.",
			);
		}
		// その他の場合
		throw new Error(`Error creating installation token: ${error.message}`);
	}
}
