import type { FieldValue } from "firebase-admin/firestore";

export interface BuildJob {
	buildStatus: OpenCIGitHubChecksStatus;
	github: OpenCIGithub;
	id: string;
	workflowId: string;
	createdAt: FieldValue;
}

export enum OpenCIGitHubChecksStatus {
	QUEUED = "queued",
	IN_PROGRESS = "inProgress",
	FAILURE = "failure",
	SUCCESS = "success",
}

export interface OpenCIGithub {
	repositoryUrl: string;
	owner: string;
	repositoryName: string;
	installationId: number;
	appId: number;
	checkRunId: number;
	issueNumber?: number;
	baseBranch: string;
	buildBranch: string;
}
