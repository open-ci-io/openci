import {
	initializeTestEnvironment,
	type RulesTestEnvironment,
	assertSucceeds,
	assertFails,
} from "@firebase/rules-unit-testing";
import { readFileSync } from "node:fs";
import { deleteDoc, doc, getDoc, setDoc, updateDoc } from "firebase/firestore";
import { describe, test, beforeAll, afterAll } from "@jest/globals";
import { runUsersCollectionTests } from "./firestore.users.test";

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

describe("Firestore Rules", () => {
	runUsersCollectionTests(() => testEnv);
});
