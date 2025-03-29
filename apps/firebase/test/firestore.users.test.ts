import {
	type RulesTestEnvironment,
	assertSucceeds,
	assertFails,
} from "@firebase/rules-unit-testing";
import { deleteDoc, doc, getDoc, setDoc, updateDoc } from "firebase/firestore";
import { describe, test, beforeEach } from "@jest/globals";
import { anotherUserId, userId, userCollectionPath } from "./constants";

export function runUsersCollectionTests(
	testEnvGetter: () => RulesTestEnvironment,
) {
	let testEnv: RulesTestEnvironment;

	beforeEach(() => {
		testEnv = testEnvGetter();
	});

	describe("Users collection: create", () => {
		test("should allow an authenticated user to create a document", async () => {
			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertSucceeds(
				setDoc(doc(authDb, userCollectionPath, userId), {
					name: "Test User Create",
				}),
			);
		});

		test("should not allow an unauthenticated user to create a document", async () => {
			const unauthenticatedUser = testEnv.unauthenticatedContext();
			const authDb = unauthenticatedUser.firestore();
			await assertFails(
				setDoc(doc(authDb, userCollectionPath, userId), {
					name: "Test User Create Fail",
				}),
			);
		});

		test("should not allow an authenticated user to create a document with a different user id", async () => {
			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertFails(
				setDoc(doc(authDb, userCollectionPath, anotherUserId), {
					name: "Test User Create Fail Other",
				}),
			);
		});
	});

	describe("Users collection: read", () => {
		test("should allow an authenticated user to read their own user document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, userId), {
					name: "Test User Read",
				});
			});

			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertSucceeds(getDoc(doc(authDb, userCollectionPath, userId)));
		});

		test("should not allow an unauthenticated user to read any user document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, userId), {
					name: "Test User Read Fail",
				});
			});
			const unauthenticatedUser = testEnv.unauthenticatedContext();
			const authDb = unauthenticatedUser.firestore();
			await assertFails(getDoc(doc(authDb, userCollectionPath, userId)));
		});

		test("should deny an authenticated user from reading another user's document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, anotherUserId), {
					name: "Test User Read Fail Other",
				});
			});

			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertFails(getDoc(doc(authDb, userCollectionPath, anotherUserId)));
		});
	});

	describe("Users collection: update", () => {
		test("should allow an authenticated user to update their own user document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, userId), {
					name: "Test User Update",
				});
			});

			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertSucceeds(
				updateDoc(doc(authDb, userCollectionPath, userId), {
					name: "Updated User",
				}),
			);
		});

		test("should not allow an unauthenticated user to update a user document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, userId), {
					name: "Test User Update Fail",
				});
			});
			const unauthenticatedUser = testEnv.unauthenticatedContext();
			const authDb = unauthenticatedUser.firestore();
			await assertFails(
				updateDoc(doc(authDb, userCollectionPath, userId), {
					name: "Updated User Fail",
				}),
			);
		});

		test("should deny an authenticated user from updating another user's document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, anotherUserId), {
					name: "Test User Update Fail Other",
				});
			});

			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertFails(
				updateDoc(doc(authDb, userCollectionPath, anotherUserId), {
					name: "Updated User Fail Other",
				}),
			);
		});
	});

	describe("Users collection: delete", () => {
		test("should allow an authenticated user to delete their own user document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, userId), {
					name: "Test User Delete",
				});
			});

			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertSucceeds(deleteDoc(doc(authDb, userCollectionPath, userId)));
		});

		test("should not allow an unauthenticated user to delete a user document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, userId), {
					name: "Test User Delete Fail",
				});
			});
			const unauthenticatedUser = testEnv.unauthenticatedContext();
			const authDb = unauthenticatedUser.firestore();
			await assertFails(deleteDoc(doc(authDb, userCollectionPath, userId)));
		});

		test("should deny an authenticated user from deleting another user's document", async () => {
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, userCollectionPath, anotherUserId), {
					name: "Test User Delete Fail Other",
				});
			});

			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertFails(
				deleteDoc(doc(authDb, userCollectionPath, anotherUserId)),
			);
		});
	});
}
