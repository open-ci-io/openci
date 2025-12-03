import type * as Sentry from "@sentry/cloudflare";

export const sentryConfig = (env: Env): Sentry.CloudflareOptions => ({
	dsn: env.SENTRY_DSN,
	enableLogs: true,
	tracesSampleRate: 1.0,
});
