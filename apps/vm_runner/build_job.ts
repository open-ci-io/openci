import { green, red } from "https://deno.land/std@0.224.0/fmt/colors.ts";
import {
    DocumentSnapshot,
    Firestore,
    QuerySnapshot,
} from "npm:firebase-admin/firestore";
import { Client } from "npm:ssh2";

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
