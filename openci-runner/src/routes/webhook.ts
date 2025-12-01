import { Hono } from "hono";
import {
	handleWorkflowJobCompleted,
	handleWorkflowJobQueued,
} from "../handlers/workflow-job";
import { verifySignature } from "../middleware/github";
import { OPENCI_RUNNER_LABEL } from "../services/incus";

const webhook = new Hono<{ Bindings: Env }>();

webhook.use("*", verifySignature());

webhook.post("/", async (c) => {
	const payload = await c.req.json();

	if (!("workflow_job" in payload)) {
		return c.text("Event ignored", 200);
	}

	const labels: string[] = payload.workflow_job.labels ?? [];
	if (!labels.includes(OPENCI_RUNNER_LABEL)) {
		return c.text("Workflow Job does not target OpenCI runner", 200);
	}

	if (payload.action === "queued") {
		return handleWorkflowJobQueued(c, payload);
	}

	if (payload.action === "completed") {
		return handleWorkflowJobCompleted(c, payload);
	}

	return c.text("Workflow Job action not supported", 200);
});

export { webhook };
