/// Firebase data for creating a new Firebase app
class OpenCIFirebaseOptions {
  OpenCIFirebaseOptions({
    required this.projectId,
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
  });

  factory OpenCIFirebaseOptions.fromPlist(Map<String, dynamic> plist) {
    return OpenCIFirebaseOptions(
      projectId: plist['PROJECT_ID'] as String,
      apiKey: plist['API_KEY'] as String,
      appId: plist['GOOGLE_APP_ID'] as String,
      messagingSenderId: plist['GCM_SENDER_ID'] as String,
    );
  }

  final String projectId;
  final String apiKey;
  final String appId;
  final String messagingSenderId;
}
