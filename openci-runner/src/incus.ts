export type IncusInstancesResponse = {
	metadata: IncusProperty[];
};

export type IncusInstanceResponse = {
	metadata: IncusProperty;
};

export type IncusProperty = {
	status: string;
	name: string;
};
