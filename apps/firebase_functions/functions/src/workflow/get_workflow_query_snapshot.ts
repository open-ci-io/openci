import { workflowCollectionName } from "../firestore_path.js";

export async function getWorkflowQuerySnapshot(
	githubRepositoryFullName: string,
	triggerType: string,
	firestore: FirebaseFirestore.Firestore,
) {
	console.log("githubRepositoryFullName", githubRepositoryFullName);
	console.log("triggerType", triggerType);
	const workflowQuerySnapshot = await firestore
		.collection(workflowCollectionName)
		.where("github.repositoryFullName", "==", githubRepositoryFullName)
		.where("github.triggerType", "==", triggerType)
		.get();

	if (workflowQuerySnapshot.empty) {
		throw new Error("OpenCI could not find the repository in our database.");
	}
	return workflowQuerySnapshot;
}
