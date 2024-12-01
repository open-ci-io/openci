import type { Context } from "probot";

export async function createChecks(
	context: Context<"pull_request"> | Context<"push">,
	name: string,
) {
	let headSha = "";
	if (context.name === "pull_request") {
		const _context = context as Context<"pull_request">;
		headSha = _context.payload.pull_request.head.sha;
	} else if (context.name === "push") {
		const _context = context as Context<"push">;
		headSha = _context.payload.after;
	}
	try {
		return await context.octokit.checks.create({
			owner: context.payload.repository.owner.login,
			repo: context.payload.repository.name,
			head_sha: headSha,
			name: name,
			status: "queued",
		});
	} catch (error) {
		console.error("Failed to create check suite:", error);
		throw error;
	}
}
