import { Hono } from "hono";
import { handleWorkflowJob } from "../handlers/workflow-job";
import { verifySignature } from "../middleware/github";

const webhook = new Hono<{ Bindings: Env }>();

webhook.use("*", verifySignature());

webhook.post("/", async (c) => {
	const payload = await c.req.json();

	if (!("workflow_job" in payload)) {
		return c.text("Event ignored", 200);
	}

	if (payload.action !== "queued") {
		return c.text("Workflow Job but status is not queued", 200);
	}

	return handleWorkflowJob(c, payload);
});

export { webhook };
