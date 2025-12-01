import z from "zod";

export const IncusStatus = z.enum(["Running", "Stopped", "Frozen", "Error"]);

export const IncusProperty = z.object({
	name: z.string(),
	status: IncusStatus,
});

export type IncusProperty = z.infer<typeof IncusProperty>;

export const IncusInstancesResponse = z.object({
	metadata: z.array(IncusProperty),
});

export type IncusInstancesResponse = z.infer<typeof IncusInstancesResponse>;

export type IncusEnv = {
	cloudflare_access_client_id: string;
	cloudflare_access_client_secret: string;
	server_url: string;
};

export const IncusOperationStatus = z.enum([
	"Pending",
	"Running",
	"Cancelling",
	"Cancelled",
	"Success",
	"Failure",
]);

export const IncusOperationMetadata = z.object({
	class: z.string().optional(),
	err: z.string().optional(),
	id: z.string().optional(),
	status: IncusOperationStatus.optional(),
	status_code: z.number().optional(),
});

export const IncusAsyncResponse = z.discriminatedUnion("type", [
	z.object({
		metadata: IncusOperationMetadata.optional(),
		operation: z.string(),
		status: z.string(),
		status_code: z.number(),
		type: z.literal("async"),
	}),
	z.object({
		metadata: IncusOperationMetadata.optional(),
		status: z.string(),
		status_code: z.number(),
		type: z.literal("sync"),
	}),
	z.object({
		error: z.string(),
		error_code: z.number(),
		metadata: IncusOperationMetadata.optional(),
		status: z.string(),
		status_code: z.number(),
		type: z.literal("error"),
	}),
]);

export type IncusAsyncResponse = z.infer<typeof IncusAsyncResponse>;
