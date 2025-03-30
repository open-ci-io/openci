import {
	type RulesTestEnvironment,
	assertFails,
	assertSucceeds,
} from "@firebase/rules-unit-testing";
import { deleteDoc, doc, getDoc, setDoc, updateDoc } from "firebase/firestore";
import { describe, test, beforeEach } from "@jest/globals";
import {
	anotherUserId,
	userId,
	workflowCollectionPath,
	workflowId,
} from "./consts";

export function runWorkflowsCollectionTests(
	testEnvGetter: () => RulesTestEnvironment,
) {
	let testEnv: RulesTestEnvironment;

	beforeEach(async () => {
		testEnv = testEnvGetter();
		await testEnv.clearFirestore();
	});

	describe("Workflows collection: create", () => {
		test("should not allow an unauthenticated user to create a workflow", async () => {
			const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				setDoc(doc(unauthenticatedDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				}),
			);
		});

		test("should allow an authenticated user to create a workflow", async () => {
			const authenticatedDb = testEnv.authenticatedContext(userId).firestore();
			await assertSucceeds(
				setDoc(doc(authenticatedDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				}),
			);
		});
	});

	describe("Workflows collection: read", () => {
		test("should allow authenticated owner to read workflow", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});

			const authDb = testEnv.authenticatedContext(userId).firestore();
			await assertSucceeds(
				getDoc(doc(authDb, workflowCollectionPath, workflowId)),
			);
		});

		test("should not allow unauthenticated user to read workflow", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				getDoc(doc(unauthenticatedDb, workflowCollectionPath, workflowId)),
			);
		});

		test("should not allow authenticated non-owner to read workflow", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const authenticatedDb = testEnv
				.authenticatedContext(anotherUserId)
				.firestore();
			await assertFails(
				getDoc(doc(authenticatedDb, workflowCollectionPath, workflowId)),
			);
		});
	});

	describe("Workflows collection: update", () => {
		test("should not allow an unauthenticated user to update a workflow", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				updateDoc(doc(unauthenticatedDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				}),
			);
		});

		test("should not allow an authenticated user to update a workflow for another user", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const authenticatedDb = testEnv
				.authenticatedContext(anotherUserId)
				.firestore();
			await assertFails(
				updateDoc(doc(authenticatedDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				}),
			);
		});
		test("should allow an authenticated user to update their own workflow", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const authenticatedDb = testEnv.authenticatedContext(userId).firestore();
			await assertSucceeds(
				updateDoc(doc(authenticatedDb, workflowCollectionPath, workflowId), {
					name: "Test Workflow",
				}),
			);
		});
	});

	describe("Workflows collection: delete", () => {
		test("should not allow an unauthenticated user to delete a workflow", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
			await assertFails(
				deleteDoc(doc(unauthenticatedDb, workflowCollectionPath, workflowId)),
			);
		});
		test("should not allow an authenticated user to delete a workflow for another user", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const authenticatedDb = testEnv
				.authenticatedContext(anotherUserId)
				.firestore();
			await assertFails(
				deleteDoc(doc(authenticatedDb, workflowCollectionPath, workflowId)),
			);
		});
		test("should allow an authenticated user to delete their own workflow", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, workflowCollectionPath, workflowId), {
					owners: [userId],
					name: "Test Workflow",
				});
			});
			const authenticatedDb = testEnv.authenticatedContext(userId).firestore();
			await assertSucceeds(
				deleteDoc(doc(authenticatedDb, workflowCollectionPath, workflowId)),
			);
		});
	});
}
