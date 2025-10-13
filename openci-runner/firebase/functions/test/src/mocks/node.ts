import { setupServer } from "msw/node";
import { githubApiHandlers } from "./github_api_handlers.js";
import { hetznerApiHandlers } from "./hetzner_api_handlers.js";

export const server = setupServer(...githubApiHandlers, ...hetznerApiHandlers);
