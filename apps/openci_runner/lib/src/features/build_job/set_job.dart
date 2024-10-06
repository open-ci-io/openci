import 'package:runner/src/commands/runner_command.dart';
import 'package:runner/src/features/build_job/models/job_status.dart';
import 'package:runner/src/models/build_job/build_job.dart';

Future<void> setJobStatus(
  BuildJob job,
  JobStatus status,
) async {
  final firestore = nonNullFirestoreClientSignal.value;
  await firestore.collection('build_jobs').doc(job.id).update({
    'status': status.name,
  });
}
