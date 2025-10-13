import { HttpResponse, http } from "msw";

const baseUrl = "https://api.hetzner.cloud/v1/servers";

export const hetznerApiHandlers = [
	http.delete(`${baseUrl}/id`, () => {
		return HttpResponse.json({});
	}),

	http.post(`${baseUrl}`, () => {
		return HttpResponse.json({
			server: {
				id: "0",
				public_net: {
					ipv4: {
						ip: "1.1.1.1",
					},
				},
			},
		});
	}),

	http.get(`${baseUrl}/id`, () => {
		return HttpResponse.json({
			server: {
				status: "running",
			},
		});
	}),
];
