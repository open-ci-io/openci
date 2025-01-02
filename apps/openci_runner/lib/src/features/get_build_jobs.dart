import 'package:dart_firebase_admin/firestore.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/commands/runner_command.dart';

Future<QuerySnapshot<Map<String, dynamic>>?> _getBuildJobQuerySnapshot(
  Firestore firestore,
) async {
  final qs = await firestore
      .collection(buildJobsCollectionPath)
      .where(
        'buildStatus',
        WhereFilter.equal,
        OpenCIGitHubChecksStatus.queued.name,
      )
      .orderBy('createdAt', descending: false)
      .limit(1)
      .get();
  if (qs.docs.isEmpty) {
    return null;
  }
  return qs;
}

Future<BuildJob?> getBuildJob(
  Firestore firestore,
) async {
  final qs = await _getBuildJobQuerySnapshot(firestore);
  if (qs == null) {
    return null;
  }
  return BuildJob.fromJson(qs.docs.first.data());
}

Future<BuildJob?> tryGetBuildJob({
  required Firestore firestore,
  required void Function() log,
}) async {
  final buildJob = await getBuildJob(firestore);
  if (buildJob == null) {
    log();
    await Future<void>.delayed(pollingInterval);
  }
  return buildJob;
}
