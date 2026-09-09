import 'package:genuine_ci/genuine_ci.dart';

Future<void> main() async {
  final genuineCI = await GenuineCI.init(
    workflowName: 'Dashboard CI',
    ciTrigger: CiTrigger.pullRequest(branch: 'develop'),
  );

  await genuineCI.placeFile(
    path: 'apps/dashboard/lib/firebase_options.dart',
    base64Content: Secrets.firebaseOptions,
  );

  await FlutterCi.staticAnalysis(genuineCI.workspacePath);
}
