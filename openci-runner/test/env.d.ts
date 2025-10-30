declare module "cloudflare:test" {
	interface ProvidedEnv extends Env {}

	interface Env extends Cloudflare.Env {
		[x: string]: string;
	}
}
