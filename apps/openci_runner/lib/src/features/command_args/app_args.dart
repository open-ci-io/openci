class AppArgs {
  AppArgs({
    required this.supabaseUrl,
    required this.supabaseAPIKey,
    this.sentryDSN,
  });
  final String supabaseUrl;
  final String supabaseAPIKey;
  final String? sentryDSN;
}
