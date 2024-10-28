import {
    DocumentSnapshot,
    Firestore,
    QuerySnapshot,
} from "npm:firebase-admin/firestore";
import { baseUrl } from "./prod_urls.ts";

export async function getBuildJob(db: Firestore): Promise<QuerySnapshot> {
    return await db
        .collection("build_jobs")
        .where("buildStatus", "==", "queued")
        .orderBy("createdAt", "asc")
        .limit(1)
        .get();
}

export async function getWorkflowDocs(
    db: Firestore,
    workflowId: string,
): Promise<DocumentSnapshot> {
    return await db.collection("workflows").doc(workflowId).get();
}

export async function setStatusToInProgress(
    db: Firestore,
    jobId: string,
): Promise<void> {
    await updateBuildStatus(jobId, "inProgress");
    await db.collection("build_jobs").doc(jobId).update({
        buildStatus: "inProgress",
    });
}

export async function setStatusToSuccess(
    db: Firestore,
    jobId: string,
): Promise<void> {
    await updateBuildStatus(jobId, "success");
    await db.collection("build_jobs").doc(jobId).update({
        buildStatus: "success",
    });
}

export async function setStatusToFailure(
    db: Firestore,
    jobId: string,
): Promise<void> {
    await updateBuildStatus(jobId, "failure");
    await db.collection("build_jobs").doc(jobId).update({
        buildStatus: "failure",
    });
}

export async function updateBuildStatus(
    jobId: string,
    status: string,
): Promise<void> {
    const url = new URL("/update_checks", baseUrl);

    const body = JSON.stringify({
        jobId: jobId,
        checksStatus: status,
    });

    try {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: body,
        });

        if (!response.ok) {
            throw new Error(
                `APIエラー: ${response.status} ${response.statusText}`,
            );
        }

        console.log(`Build status updated: ${status}`);
    } catch (error) {
        console.error(`Failed to update build status: ${error}`);
    }
}
