import { HttpResponse, http } from "msw";

const baseUrl = "https://api.hetzner.cloud/v1/servers";

export const hetznerApiHandlers = [
	http.delete<{ id: string }>(`${baseUrl}/:id`, () => {
		return HttpResponse.json({});
	}),

	http.post(`${baseUrl}`, () => {
		return HttpResponse.json({
			server: {
				id: 0,
				public_net: {
					ipv4: {
						ip: "1.1.1.1",
					},
				},
			},
		});
	}),

	http.get<{ id: string }>(`${baseUrl}/:id`, () => {
		return HttpResponse.json({
			server: {
				status: "running",
			},
		});
	}),
];
