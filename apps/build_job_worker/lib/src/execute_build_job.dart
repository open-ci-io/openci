import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:openci_shared/openci_shared.dart';

import 'checkout_repository.dart';
import 'complete_build_job.dart';
import 'complete_build_run.dart';
import 'complete_github_check_run.dart';
import 'config.dart';
import 'create_build_run.dart';
import 'fetch_job_secrets.dart';
import 'loki/push_log_to_loki.dart';
import 'orchard/orchard_api_client.dart';
import 'orchard/prepare_vm.dart';
import 'resolve_github_installation_token.dart';
import 'run_workflow.dart';

/// Executes one claimed job and attempts all completion and VM cleanup steps.
///
/// The returned status describes execution, even if saving it or cleanup fails.
/// [onError] reports execution, log, completion and cleanup errors and must not
/// throw. The caller owns the clients and closes them after all jobs finish.
Future<BuildJobStatus> executeBuildJob({
  required OpenCiApiService api,
  required OrchardApiClient orchardApi,
  required http.Client lokiClient,
  required Config config,
  required BuildJob job,
  required void Function(Object error, StackTrace stackTrace) onError,
  Duration finalizationTimeout = const Duration(seconds: 10),
}) async {
  if (job.status != BuildJobStatus.IN_PROGRESS) {
    throw ArgumentError.value(job.status, 'job.status', 'Job must be claimed.');
  }
  if (finalizationTimeout <= Duration.zero) {
    throw ArgumentError.value(
      finalizationTimeout,
      'finalizationTimeout',
      'Must be positive.',
    );
  }

  final runId =
      'run-${DateTime.now().microsecondsSinceEpoch}-'
      '${Random.secure().nextInt(1 << 32).toRadixString(16)}';
  final vmName = 'openci-vm-$runId';
  var status = BuildJobStatus.FAILURE;
  var runCreated = false;
  String? leaseId;
  final errors = <(Object, StackTrace)>[];

  Future<void> reportVmStep(BuildStep step) async {
    try {
      await pushLogToLoki(
        client: lokiClient,
        lokiUrl: config.internalLokiUrl,
        runId: runId,
        jobId: job.id,
        stepId: step.id,
        type: 'step_event',
        message: jsonEncode(step.toJson()),
      ).timeout(const Duration(seconds: 10));
    } catch (error, stackTrace) {
      errors.add((error, stackTrace));
    }
  }

  try {
    await createBuildRun(api: api, jobId: job.id, runId: runId);
    runCreated = true;
    final token = await resolveGitHubInstallationToken(api: api, jobId: job.id);
    final startedAt = DateTime.now().toUtc();
    final vmStep = BuildStep(
      id: 'prepare_vm',
      runId: runId,
      name: 'Set up VM',
      status: BuildJobStatus.IN_PROGRESS,
      durationMs: 0,
      stepOrder: 0,
      createdAt: startedAt,
      updatedAt: startedAt,
    );
    await reportVmStep(vmStep);
    final stopwatch = Stopwatch()..start();
    try {
      final lease = await prepareVm(
        api: orchardApi,
        baseVmName: config.baseVmName,
        vmName: vmName,
      );
      leaseId = lease.id.isNotEmpty ? lease.id : vmName;
    } finally {
      stopwatch.stop();
      await reportVmStep(
        vmStep.copyWith(
          status: leaseId == null
              ? BuildJobStatus.FAILURE
              : BuildJobStatus.SUCCESS,
          durationMs: stopwatch.elapsedMilliseconds,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
    }

    await checkoutRepository(
      api: orchardApi,
      lokiClient: lokiClient,
      lokiUrl: config.internalLokiUrl,
      vmName: vmName,
      job: job,
      token: token,
      runId: runId,
      onLogError: onError,
    );
    final secretsContent = await fetchJobSecrets(api: api, jobId: job.id);
    final exitCode = await runWorkflow(
      api: orchardApi,
      lokiClient: lokiClient,
      lokiUrl: config.internalLokiUrl,
      vmLokiUrl: config.lokiUrl,
      vmName: vmName,
      job: job,
      runId: runId,
      secretsContent: secretsContent,
      onLogError: onError,
    );
    status = exitCode == 0 ? BuildJobStatus.SUCCESS : BuildJobStatus.FAILURE;
  } catch (error, stackTrace) {
    errors.add((error, stackTrace));
  } finally {
    final completedAt = DateTime.now().toUtc();
    final vmToDelete = leaseId;
    for (final action in <Future<void> Function()>[
      if (runCreated)
        () => completeBuildRun(
          api: api,
          jobId: job.id,
          runId: runId,
          status: status,
        ),
      () => completeBuildJob(
        api: api,
        jobId: job.id,
        status: status,
        completedAt: completedAt,
      ),
      () => completeGitHubCheckRun(api: api, jobId: job.id, status: status),
      if (vmToDelete != null) () => orchardApi.deleteLease(vmToDelete),
    ]) {
      try {
        await action().timeout(finalizationTimeout);
      } catch (error, stackTrace) {
        errors.add((error, stackTrace));
      }
    }
  }

  // Error reporting must not interrupt the remaining completion/cleanup steps.
  for (final (error, stackTrace) in errors) {
    onError(error, stackTrace);
  }
  return status;
}
