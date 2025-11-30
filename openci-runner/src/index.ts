import { Hono } from "hono";
import { validateEnv } from "./middleware/validate-env";
import { webhook } from "./routes/webhook";

const app = new Hono<{ Bindings: Env }>();

app.use("*", validateEnv());
app.route("/webhook", webhook);

export default app;
