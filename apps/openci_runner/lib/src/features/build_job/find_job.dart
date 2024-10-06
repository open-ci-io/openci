import 'package:dart_firebase_admin/firestore.dart';
import 'package:runner/src/commands/runner_command.dart';
import 'package:runner/src/features/build_job/models/job_status.dart';
import 'package:runner/src/models/build_job/build_job.dart';

Future<BuildJob?> findJob() async {
  final firestore = nonNullFirestoreClientSignal.value;
  final qs = await firestore
      .collection('build_jobs')
      .where('status', WhereFilter.equal, JobStatus.waiting.name)
      .limit(1)
      .get();

  if (qs.docs.isEmpty) {
    return null;
  }

  return BuildJob.fromJson(qs.docs.first.data());
}
