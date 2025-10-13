import { HttpResponse, http } from "msw";

export const githubApiHandlers = [
	http.post("https://api.github.com/app/installations/2/access_tokens", () => {
		return HttpResponse.json({});
	}),

	http.post(
		"https://api.github.com/repos/hiimbex/testing-things/issues/1/comments",
		() => {
			return HttpResponse.json({});
		},
	),
];
