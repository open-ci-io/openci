import 'package:dart_firebase_admin/firestore.dart';
import 'package:openci_models/openci_models.dart';
import 'package:runner/src/commands/runner_command.dart';

Future<BuildJob?> findJob() async {
  final firestore = nonNullFirestoreClientSignal.value;
  final qs = await firestore
      .collection('build_jobs')
      .where(
        'buildStatus',
        WhereFilter.equal,
        OpenCIGitHubChecksStatus.queued.name,
      )
      .limit(1)
      .get();

  if (qs.docs.isEmpty) {
    return null;
  }

  return BuildJob.fromJson(qs.docs.first.data());
}
