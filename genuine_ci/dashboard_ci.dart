import 'package:genuine_ci/genuine_ci.dart';

import 'secrets.g.dart';

Future<void> main() async {
  final genuineCI = await GenuineCI.init(
    workflowName: 'Dashboard CI',
    ciTrigger: CiTrigger.pullRequest(branch: 'develop'),
  );

  await genuineCI.placeFileFromBase64(
    path: 'apps/dashboard/lib/firebase_options.dart',
    base64Content: Secrets.firebaseOptionsDartBase64,
  );

  await FlutterCi.staticAnalysis(genuineCI.workspacePath);
}
