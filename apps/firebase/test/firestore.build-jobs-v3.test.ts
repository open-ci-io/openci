import {
	type RulesTestEnvironment,
	assertFails,
	assertSucceeds,
} from "@firebase/rules-unit-testing";
import { deleteDoc, doc, getDoc, setDoc, updateDoc } from "firebase/firestore";
import { describe, test, beforeEach } from "@jest/globals";
import {
	anotherUserId,
	buildJobCollectionPath,
	buildJobId,
	userId,
	workflowCollectionPath,
	workflowId,
} from "./constants";

export function runBuildJobsV3CollectionTests(
	testEnvGetter: () => RulesTestEnvironment,
) {
	let testEnv: RulesTestEnvironment;

	beforeEach(async () => {
		testEnv = testEnvGetter();
		await testEnv.clearFirestore();
	});

	describe("Build Jobs v3 collection: create", () => {
		test("should not allow an unauthenticated user to create a build job", async () => {
			const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				setDoc(doc(unauthenticatedDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				}),
			);
		});

		test("should not allow an authenticated user to create a build job for another user", async () => {
			const authenticatedDb = testEnv
				.authenticatedContext(anotherUserId)
				.firestore();
			await assertFails(
				setDoc(doc(authenticatedDb, buildJobCollectionPath, buildJobId), {
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

	describe("Build Jobs v3 collection: update", () => {
		test("should not allow an unauthenticated user to update a build job", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});
			const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				updateDoc(doc(unauthenticatedDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				}),
			);
		});

		test("should not allow an authenticated user to update a build job for another user", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});
			const authenticatedDb = testEnv
				.authenticatedContext(anotherUserId)
				.firestore();
			await assertFails(
				updateDoc(doc(authenticatedDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				}),
			);
		});
	});

	describe("Build Jobs v3 collection: delete", () => {
		test("should not allow an unauthenticated user to delete a build job", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});
			const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				deleteDoc(doc(unauthenticatedDb, buildJobCollectionPath, buildJobId)),
			);
		});

		test("should not allow an authenticated user to update a build job for another user", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, buildJobCollectionPath, buildJobId), {
					workflowId: workflowId,
					status: "running",
				});
			});
			const authenticatedDb = testEnv
				.authenticatedContext(anotherUserId)
				.firestore();
			await assertFails(
				deleteDoc(doc(authenticatedDb, buildJobCollectionPath, buildJobId)),
			);
		});
	});
}
