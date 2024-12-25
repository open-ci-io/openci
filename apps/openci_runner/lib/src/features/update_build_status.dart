import 'package:mason_logger/mason_logger.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/commands/commands.dart';

Future<void> updateBuildStatus({
  required String jobId,
  OpenCIGitHubChecksStatus status = OpenCIGitHubChecksStatus.inProgress,
}) async {
  try {
    final firestore = firestoreSignal.value;

    await firestore!.collection(buildJobsCollectionPath).doc(jobId).update({
      'buildStatus': status.name,
    });
  } catch (e) {
    Logger().err('Failed to update build status, $e');
  }
}
