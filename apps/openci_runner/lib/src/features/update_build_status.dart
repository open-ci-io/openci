import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/commands/commands.dart';

Future<void> updateBuildStatus({
  required String jobId,
  OpenCIGitHubChecksStatus status = OpenCIGitHubChecksStatus.inProgress,
}) async {
  final firestore = firestoreSignal.value;

  await firestore!.collection(buildJobsCollectionPath).doc(jobId).update({
    'buildStatus': status.name,
  });
}
