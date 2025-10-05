import type { ApplicationFunction, Probot } from "probot";

export const appFn: ApplicationFunction = (app: Probot) => {
	app.log.info("Yay! The app was loaded!");

	app.on("issues.opened", async (context) => {
		return context.octokit.rest.issues.createComment(
			context.issue({ body: "Hello, World!" }),
		);
	});
};
