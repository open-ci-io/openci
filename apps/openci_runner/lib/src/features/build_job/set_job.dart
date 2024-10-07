import 'package:openci_models/openci_models.dart';
import 'package:runner/src/commands/signals.dart';

Future<void> setJobStatus(
  BuildJob job,
  OpenCIGitHubChecksStatus status,
) async {
  final firestore = nonNullFirestoreClientSignal.value;
  await firestore.collection('build_jobs').doc(job.id).update({
    'buildStatus': status.name,
  });
}
