import { describe, expect, test } from "vitest";
import {
	ActionsRunnerArchitecture,
	ActionsRunnerOS,
	jitConfigRequestBody,
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

	describe("generate a jit-config for self-hosted runner", () => {
		const owner = "open-ci-io";
		const repo = "openci";
		const serverId = 0;
		test("jitConfigRequestBody", () => {
			const res = jitConfigRequestBody(owner, repo, serverId);

			expect(res.headers).toStrictEqual({
				"X-GitHub-Api-Version": "2022-11-28",
			});
			expect(res.labels).toStrictEqual(["openci-runner-beta"]);
			expect(res.name).toBe(`OpenCI ランナー ${serverId}`);
			expect(res.owner).toBe(owner);
			expect(res.repo).toBe(repo);
			expect(res.runner_group_id).toBe(1);
			expect(res.work_folder).toBe("_work");
		});
	});
});
