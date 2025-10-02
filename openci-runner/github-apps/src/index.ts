import type { Probot } from "probot";

const githubApp = (app: Probot) => {
	app.log.info("OpenCI GitHub App loaded");

	app.on("issues.opened", async (context) => {
		const issueComment = context.issue({
			body: "Thanks for opening this issue!",
		});

		await context.octokit.rest.issues.createComment(issueComment);
	});
};

export default githubApp;
