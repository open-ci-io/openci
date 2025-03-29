import type { Timestamp } from "firebase-admin/firestore";

export interface CommandLog {
	command: string;
	logStdout: string;
	logStderr: string;
	createdAt: Timestamp;
	exitCode: number;
}
