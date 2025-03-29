import {
	initializeTestEnvironment,
	type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { readFileSync } from "node:fs";
import { describe, beforeAll, afterAll } from "@jest/globals";
import { runBuildJobsV3CollectionTests } from "./firestore.build-jobs-v3.test";
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
	runBuildJobsV3CollectionTests(() => testEnv);
});
