import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/commands/runner_command.dart';
import 'package:openci_runner/src/features/get_build_jobs.dart';
import 'package:openci_runner/src/features/tart_vm/delete_vm.dart';
import 'package:openci_runner/src/features/tart_vm/stop_vm.dart';
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/log.dart';
import 'package:openci_runner/src/process_build_job.dart';
import 'package:openci_runner/src/service/uuid_service.dart';
import 'package:sentry/sentry.dart';

Future<void> mainLoop(Firestore firestore, String pem) async {
  while (true) {
    final buildJob = await tryGetBuildJob(
      firestore: firestore,
      log: () => log(
        'No build jobs found. Waiting ${pollingInterval.inSeconds} seconds before retrying.',
      ),
    );
    if (buildJob == null) {
      continue;
    }

    final vmName = generateUUID;
    final logId = generateUUID;

    try {
      await processBuildJob(buildJob, firestore, pem, vmName, logId);
    } catch (e, stackTrace) {
      await _handleBuildError(buildJob.id, e, stackTrace);
    } finally {
      await _cleanupVmAndBuildState(buildJob.id, vmName);
    }
  }
}

Future<void> _handleBuildError(
  String jobId,
  Object error,
  StackTrace stackTrace,
) async {
  await updateBuildStatus(
    jobId: jobId,
    status: OpenCIGitHubChecksStatus.failure,
  );
  await Sentry.captureException(error, stackTrace: stackTrace);
  log('Error: $error, Try to run again');
}

Future<void> _cleanupVmAndBuildState(String jobId, String vmName) async {
  try {
    await stopVM(vmName);
    await cleanUpVMs();
  } catch (e, stackTrace) {
    await updateBuildStatus(
      jobId: jobId,
      status: OpenCIGitHubChecksStatus.failure,
    );
    await Sentry.captureException(e, stackTrace: stackTrace);
    log('Failed to stop or delete VM, $e');
  }
}
