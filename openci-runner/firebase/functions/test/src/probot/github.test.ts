import { describe, expect, test } from "vitest";
import {
	ActionsRunnerArchitecture,
	ActionsRunnerOS,
} from "../../../src/probot/github";

describe("github", () => {
	test("ActionsRunnerOS", () => {
		const osx = ActionsRunnerOS.osx;
		expect(osx).toBe("osx");

		const linux = ActionsRunnerOS.linux;
		expect(linux).toBe("linux");
	});

	test("ActionsRunnerArchitecture", () => {
		const arm64 = ActionsRunnerArchitecture.arm64;
		expect(arm64).toBe("arm64");

		const x64 = ActionsRunnerArchitecture.x64;
		expect(x64).toBe("x64");
	});
});
