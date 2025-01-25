import 'dart:async';

import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/commands/runner_command.dart';
import 'package:openci_runner/src/env.dart';
import 'package:openci_runner/src/features/get_build_jobs.dart';
import 'package:openci_runner/src/features/get_workflow.dart';
import 'package:openci_runner/src/features/run.dart';
import 'package:openci_runner/src/features/tart_vm/clone_vm.dart';
import 'package:openci_runner/src/features/tart_vm/delete_vm.dart';
import 'package:openci_runner/src/features/tart_vm/get_vm_ip.dart';
import 'package:openci_runner/src/features/tart_vm/run_vm.dart';
import 'package:openci_runner/src/features/tart_vm/stop_vm.dart';
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/firebase/firebase_admin.dart';
import 'package:openci_runner/src/log.dart';
import 'package:openci_runner/src/secrets.dart';
import 'package:openci_runner/src/sentry.dart';
import 'package:openci_runner/src/service/github/clone_command.dart';
import 'package:openci_runner/src/service/github/get_github_installation_token.dart';
import 'package:openci_runner/src/service/uuid_service.dart';
import 'package:sentry/sentry.dart';

Future<void> runApp({
  required String serviceAccountPath,
  required String pem,
  String? sentryDsn,
}) async {
  await initSentry(
    sentryDsn: sentryDsn ?? '',
    appRunner: () async {
      final admin = await initializeFirebaseAdminApp(
        'open-ci-release',
        serviceAccountPath,
      );
      final firestore = Firestore(admin);
      firestoreSignal.value = firestore;

      while (true) {
        final buildJob = await tryGetBuildJob(
          firestore: firestore,
          log: () => log(
            'No build jobs found. Waiting ${pollingInterval.inSeconds} seconds before retrying.',
          ),
        );
        if (buildJob == null) continue;
        log('Found ${buildJob.toJson()} build jobs');
        final vmName = generateUUID;
        final logId = generateUUID;
        try {
          final workflow =
              await getWorkflowModel(firestore, buildJob.workflowId);
          if (workflow == null) {
            log('Workflow not found');
            throw Exception('Workflow not found');
          }

          final token = await getGitHubInstallationToken(
            installationId: buildJob.github.installationId,
            appId: buildJob.github.appId,
            privateKey: pem,
          );
          log(
            'Successfully got GitHub access token: $token',
            isSuccess: true,
          );

          await cloneVM(vmName);
          unawaited(runVM(vmName));
          final vmIp = await getVMIp(vmName);
          log('VM IP: $vmIp');
          log('VM is ready', isSuccess: true);

          final client = SSHClient(
            await SSHSocket.connect(vmIp, 22),
            username: 'admin',
            onPasswordRequest: () => 'admin',
          );

          final repoUrl = buildJob.github.repositoryUrl;

          await runCommand(
            logId: logId,
            client: client,
            command: cloneCommand(
              repoUrl,
              buildJob.github.buildBranch,
              token,
            ),
            currentWorkingDirectory: null,
            jobId: buildJob.id,
          );

          final commandsList = workflow.steps.map((e) => e.command).toList();
          final secrets = await fetchSecrets(
            workflowId: workflow.id,
            firestore: firestore,
            owners: workflow.owners,
          );

          for (final command in commandsList) {
            final processedCommand = replaceEnvironmentVariables(
              command: command,
              secrets: secrets,
            );

            await runCommand(
              logId: logId,
              client: client,
              command: processedCommand,
              currentWorkingDirectory: workflow.currentWorkingDirectory,
              jobId: buildJob.id,
            );
          }

          await updateBuildStatus(
            jobId: buildJob.id,
            status: OpenCIGitHubChecksStatus.success,
          );
        } catch (e, stackTrace) {
          await updateBuildStatus(
            jobId: buildJob.id,
            status: OpenCIGitHubChecksStatus.failure,
          );
          await Sentry.captureException(e, stackTrace: stackTrace);
          log('Error: $e, Try to run again');
        } finally {
          try {
            await stopVM(vmName);
            await cleanUpVMs();
          } catch (e, stackTrace) {
            await updateBuildStatus(
              jobId: buildJob.id,
              status: OpenCIGitHubChecksStatus.failure,
            );
            await Sentry.captureException(e, stackTrace: stackTrace);
            log('Failed to stop or delete VM, $e');
          }
        }
        continue;
      }
    },
  );
}
