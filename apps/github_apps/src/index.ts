import { createNodeMiddleware, createProbot, Probot } from "probot";

const app = (app: Probot) => {
  app.on("issues.opened", async (context) => {
    const issueComment = context.issue({
      body: "Thanks for opening this issue!",
    });

    await context.octokit.issues.createComment(issueComment);
  });
};

module.exports = (app: any) => {
  app.log("Yay! The app was loaded!");

  app.on("issues.opened", async (context: any) => {
    return context.octokit.issues.createComment(
      context.issue({ body: "Hello, World!" }),
    );
  });
};

// Firebase Functionsとして公開
exports.probotApp = createNodeMiddleware(app, { probot: createProbot() });
