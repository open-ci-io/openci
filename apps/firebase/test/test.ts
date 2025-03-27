import {
	initializeTestEnvironment,
	type RulesTestEnvironment,
	assertSucceeds,
	assertFails,
} from "@firebase/rules-unit-testing";
import { readFileSync } from "node:fs";
import { doc, getDoc, setDoc } from "firebase/firestore";
import { describe, test, beforeAll, afterAll } from "@jest/globals";

const PROJECT_ID = "open-ci-release";

let testEnv: RulesTestEnvironment;

beforeAll(async () => {
	testEnv = await initializeTestEnvironment({
		projectId: PROJECT_ID,
		firestore: {
			rules: readFileSync("../firestore.rules", "utf8"),
		},
	});
});

afterAll(async () => {
	await testEnv.clearFirestore();
});

describe("Firestore security rules", () => {
	describe("Users collection: read", () => {
		test("should allow an authenticated user to read their own user document", async () => {
			const userId = "user_123";
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, "users", userId), { name: "Test User" });
			});

			const authenticatedUser = testEnv.authenticatedContext(userId);
			const authDb = authenticatedUser.firestore();
			await assertSucceeds(getDoc(doc(authDb, "users", userId)));
		});

		test("should not allow an unauthenticated user to read any user document", async () => {
			const userId = "user_123";
			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, "users", userId), { name: "Test User" });
			});
			const unauthenticatedUser = testEnv.unauthenticatedContext();
			const authDb = unauthenticatedUser.firestore();
			await assertFails(getDoc(doc(authDb, "users", userId)));
		});

		test("should deny an authenticated user from reading another user's document", async () => {
			const targetUserId = "user_123";
			const requesterUserId = "user_456";

			await testEnv.withSecurityRulesDisabled(async (context) => {
				const adminDb = context.firestore();
				await setDoc(doc(adminDb, "users", targetUserId), {
					name: "Test User",
				});
			});

			const authenticatedUser = testEnv.authenticatedContext(requesterUserId);
			const authDb = authenticatedUser.firestore();
			await assertFails(getDoc(doc(authDb, "users", targetUserId)));
		});
	});
});
