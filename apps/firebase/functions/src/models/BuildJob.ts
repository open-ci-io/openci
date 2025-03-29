export interface BuildJob {
	buildStatus: OpenCIGitHubChecksStatus;
	github: OpenCIGithub;
	id: string;
	workflowId: string;
	createdAt: number;
}

export enum OpenCIGitHubChecksStatus {
	QUEUED = "queued",
	IN_PROGRESS = "inProgress",
	FAILURE = "failure",
	SUCCESS = "success",
}

export interface OpenCIGithub {
	owner: string;
	repositoryName: string;
	installationId: number;
	appId: number;
	checkRunId: number;
	issueNumber?: number;
	baseBranch: string;
	buildBranch: string;
}
