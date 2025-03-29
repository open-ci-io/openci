/** @type {import('ts-jest').JestConfigWithTsJest} **/
module.exports = {
	testEnvironment: "node",
	transform: {
		"^.+\\.tsx?$": "<rootDir>/node_modules/ts-jest/preprocessor.js",
	},
};
