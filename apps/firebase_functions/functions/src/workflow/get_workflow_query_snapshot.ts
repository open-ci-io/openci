import { workflowCollectionName } from "../firestore_path.js";

export async function getWorkflowQuerySnapshot(
	githubRepositoryUrl: string,
	triggerType: string,
	firestore: FirebaseFirestore.Firestore,
) {
	console.log("githubRepositoryUrl", githubRepositoryUrl);
	console.log("triggerType", triggerType);
	const workflowQuerySnapshot = await firestore
		.collection(workflowCollectionName)
		.where("github.repositoryUrl", "==", githubRepositoryUrl)
		.where("github.triggerType", "==", triggerType)
		.get();

	if (workflowQuerySnapshot.empty) {
		throw new Error("OpenCI could not find the repository in our database.");
	}
	return workflowQuerySnapshot;
}
