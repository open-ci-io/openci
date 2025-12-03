import z from "zod";

export const WorkflowJobPayloadSchema = z.object({
	installation: z
		.object({
			id: z.number(),
		})
		.optional(),
	repository: z.object({
		name: z.string(),
		owner: z.object({
			login: z.string(),
		}),
	}),
	workflow_job: z
		.object({
			run_id: z.number(),
		})
		.optional(),
});

export type WorkflowJobPayload = z.infer<typeof WorkflowJobPayloadSchema>;
