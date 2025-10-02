import type { Probot } from "probot";

const githubApp = (app: Probot) => {
	app.log.info("OpenCI GitHub App loaded");

	app.on("issues.opened", async (context) => {
		const issueComment = context.issue({
			body: "Thanks for opening this issue! We'll take a look shortly.",
		});

		await context.octokit.issues.createComment(issueComment);
	});
};

export default githubApp;
