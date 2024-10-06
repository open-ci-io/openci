class AppArgs {
  AppArgs({
    required this.firebaseProjectName,
    this.sentryDSN,
    required this.firebaseServiceAccountFileRelativePath,
  });
  final String firebaseProjectName;
  final String? sentryDSN;
  final String firebaseServiceAccountFileRelativePath;
}
