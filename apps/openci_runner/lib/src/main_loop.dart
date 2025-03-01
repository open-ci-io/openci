import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:mason_logger/mason_logger.dart';
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
  final logger = Logger();
  final progress = logger.progress(
    'No build jobs found. Waiting ${pollingInterval.inSeconds} seconds before retrying.',
  );
  while (true) {
    final buildJob = await tryGetBuildJob(
      firestore: firestore,
    );
    if (buildJob == null) {
      continue;
    }

    progress.update('Successfully got a build job');

    final vmName = generateUUID;
    final logId = generateUUID;

    try {
      await processBuildJob(buildJob, firestore, pem, vmName, logId);
    } catch (e, stackTrace) {
      progress.update('Failed to process build job');
      await _handleBuildError(buildJob.id, e, stackTrace);
    } finally {
      progress.update('Cleaning up VM and build state');
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
  openciLog('Error: $error, Try to run again');
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
    openciLog('Failed to stop or delete VM, $e');
  }
}
