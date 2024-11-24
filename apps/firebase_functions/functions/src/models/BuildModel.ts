/* eslint-disable @typescript-eslint/no-explicit-any */
import * as admin from "firebase-admin";

interface BuildStatus {
    processing: boolean;
    failure: boolean;
    success: boolean;
}

interface Branch {
    baseBranch: string;
    buildBranch: string;
}

interface GithubChecks {
    issueNumber: number | null;
    checkRunId: number;
}

interface Github {
    repositoryUrl: string;
    owner: string;
    repositoryName: string;
    installationId: number;
    appId: number;
}

export class BuildModel {
    constructor(
        readonly buildStatus: BuildStatus,
        readonly branch: Branch,
        readonly githubChecks: GithubChecks,
        readonly github: Github,
        readonly createdAt: admin.firestore.FieldValue,
        readonly documentId: string,
        readonly platform: string,
        readonly workflowId: string,
    ) {}

    // Method to serialize the model to JSON
    toJson(): any {
        return {
            buildStatus: this.buildStatus,
            branch: this.branch,
            githubChecks: this.githubChecks,
            github: this.github,
            createdAt: this.createdAt,
            documentId: this.documentId,
            platform: this.platform,
            workflowId: this.workflowId,
        };
    }

    // Method to deserialize from JSON
    static fromJson(json: any): BuildModel {
        return new BuildModel(
            json.buildStatus,
            json.branch,
            json.githubChecks,
            json.github,
            json.createdAt,
            json.documentId,
            json.platform,
            json.workflowId,
        );
    }
}
