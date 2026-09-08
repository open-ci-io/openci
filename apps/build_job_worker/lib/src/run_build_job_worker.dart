import 'package:openci_shared/openci_shared.dart';

import 'claim_next_build_job.dart';

/// Claims and executes jobs one at a time until [shouldStop] returns true.
///
/// [executeJob] is responsible for result recording and cleanup before returning.
/// A job claimed while stopping is still executed; it must not be abandoned.
/// [onError] reports thrown errors and must not throw. The caller owns clients.
Future<void> runBuildJobWorker({
  required OpenCiApiService api,
  required Future<BuildJobStatus> Function(BuildJob job) executeJob,
  required bool Function() shouldStop,
  required void Function(Object error, StackTrace stackTrace) onError,
  Duration pollInterval = const Duration(seconds: 3),
}) async {
  if (pollInterval <= Duration.zero) {
    throw ArgumentError.value(
      pollInterval,
      'pollInterval',
      'Must be positive.',
    );
  }

  while (!shouldStop()) {
    try {
      final job = await claimNextBuildJob(api);
      if (job != null) {
        await executeJob(job);
        continue;
      }
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }

    if (!shouldStop()) {
      await Future<void>.delayed(pollInterval);
    }
  }
}
