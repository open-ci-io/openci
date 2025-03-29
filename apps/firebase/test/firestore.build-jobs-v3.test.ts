import {
	type RulesTestEnvironment,
	assertFails,
	assertSucceeds,
} from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc } from "firebase/firestore";
import { describe, test, beforeEach } from "@jest/globals";
import {
	anotherUserId,
	buildJobCollectionPath,
	buildJobId,
	userId,
	workflowCollectionPath,
	workflowId,
} from "./consts";

export function runBuildJobsV3CollectionTests(
	testEnvGetter: () => RulesTestEnvironment,
) {
	let testEnv: RulesTestEnvironment;

	beforeEach(async () => {
		testEnv = testEnvGetter();
		await testEnv.clearFirestore();
	});

	describe("Build Jobs v3 collection: create", () => {
		test("should not allow any users to create build job documents", async () => {
			const authDb = testEnv.authenticatedContext(userId).firestore();
			await assertFails(
				setDoc(doc(authDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				}),
			);
		});
	});

	describe("Build Jobs v3 collection: read", () => {
		test("should allow authenticated owner to read build job", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});

			const authDb = testEnv.authenticatedContext(userId).firestore();
			await assertSucceeds(
				getDoc(doc(authDb, buildJobCollectionPath, buildJobId)),
			);
		});

		test("should not allow unauthenticated user to read build job", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});
			const authDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				getDoc(doc(authDb, buildJobCollectionPath, buildJobId)),
			);
		});

		test("should not allow authenticated non-owner to read build job", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});
			const authDb = testEnv.authenticatedContext(anotherUserId).firestore();
			await assertFails(
				getDoc(doc(authDb, buildJobCollectionPath, buildJobId)),
			);
		});

		test("deny read if build job document does not have workflowId", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					status: "running",
				});
			});
			const authDb = testEnv.authenticatedContext(userId).firestore();
			await assertFails(
				getDoc(doc(authDb, buildJobCollectionPath, buildJobId)),
			);
		});

		test("should deny reading build job if related workflow document does not exist", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});

			const authDb = testEnv.authenticatedContext(userId).firestore();
			await assertFails(
				getDoc(doc(authDb, buildJobCollectionPath, buildJobId)),
			);
		});
	});
}
