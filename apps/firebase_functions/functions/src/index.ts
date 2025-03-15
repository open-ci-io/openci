/* eslint-disable @typescript-eslint/no-explicit-any */
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { githubApp } from "./github/github_app.js";
import { updateGitHubCheckStatus } from "./github/update_github_checks_status.js";
import { updateGitHubChecksLog } from "./github/update_github_checks_log.js";

const firebaseApp = initializeApp();
export const firestore = getFirestore(firebaseApp);

export const githubAppFunction = githubApp;
export const updateGitHubCheckStatusFunction = updateGitHubCheckStatus;
export const updateGitHubChecksLogFunction = updateGitHubChecksLog;
