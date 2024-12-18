declare module "redact-secrets" {
	interface Redact {
		map: <T>(obj: T) => T;
		forEach: <T>(obj: T) => void;
	}

	function redactSecrets(replacement: string): Redact;
	export = redactSecrets;
}
