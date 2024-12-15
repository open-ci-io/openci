import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/features/get_build_jobs.dart';
import 'package:openci_runner/src/features/get_workflow.dart';
import 'package:openci_runner/src/features/run.dart';
import 'package:openci_runner/src/features/tart_vm/clone_vm.dart';
import 'package:openci_runner/src/features/tart_vm/delete_vm.dart';
import 'package:openci_runner/src/features/tart_vm/get_vm_ip.dart';
import 'package:openci_runner/src/features/tart_vm/run_vm.dart';
import 'package:openci_runner/src/features/tart_vm/stop_vm.dart';
import 'package:openci_runner/src/features/tart_vm/vm_name.dart';
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/firebase/firebase_admin.dart';
import 'package:openci_runner/src/service/github/get_github_installation_token.dart';
import 'package:signals_core/signals_core.dart';

final firestoreSignal = signal<Firestore?>(null);

/// {@template sample_command}
///
/// `openci_runner sample`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class RunnerCommand extends Command<int> {
  /// {@macro sample_command}
  RunnerCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'pem-path',
        abbr: 'p',
        help: 'GitHub App Private Key (pem) Path',
        mandatory: true,
      )
      ..addOption(
        'service-account-path',
        abbr: 's',
        help: 'Firebase Service Account Json Path',
        mandatory: true,
      );
  }

  @override
  String get description => 'OpenCI Runner command';

  @override
  String get name => 'runner';

  final Logger _logger;

  void _log(String message, {bool isSuccess = false}) {
    switch (isSuccess) {
      case true:
        _logger.success('[${DateTime.now().toIso8601String()}]: $message');
      case false:
        _logger.info('[${DateTime.now().toIso8601String()}]: $message');
    }
  }

  Future<BuildJob?> _tryGetBuildJob(Firestore firestore) async {
    final buildJob = await getBuildJob(firestore);
    if (buildJob == null) {
      _log(
        'No build jobs found. Waiting 1 second before retrying.',
      );
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    return buildJob;
  }

  @override
  Future<int> run() async {
    final pemPath = argResults?['pem-path'] as String;
    final pem = File(pemPath).readAsStringSync();
    final serviceAccountPath = argResults?['service-account-path'] as String;

    final admin = await initializeFirebaseAdminApp(
      'open-ci-release',
      serviceAccountPath,
    );
    final firestore = Firestore(admin);
    firestoreSignal.value = firestore;

    while (true) {
      final buildJob = await _tryGetBuildJob(firestore);
      if (buildJob == null) continue;
      _log('Found ${buildJob.toJson()} build jobs');
      try {
        await updateBuildStatus(
          jobId: buildJob.id,
        );

        final workflow = await getWorkflowModel(firestore, buildJob.workflowId);
        if (workflow == null) {
          _log('Workflow not found');
          throw Exception('Workflow not found');
        }

        final token = await getGitHubInstallationToken(
          installationId: buildJob.github.installationId,
          appId: buildJob.github.appId,
          privateKey: pem,
        );
        _log('Successfully got GitHub access token: $token', isSuccess: true);

        final vmName = getVMName();

        await cloneVM(vmName);
        unawaited(runVM(vmName));
        final vmIp = await getVMIp(vmName);
        _log('VM IP: $vmIp');
        _log('VM is ready', isSuccess: true);

        final client = SSHClient(
          await SSHSocket.connect(vmIp, 22),
          username: 'admin',
          onPasswordRequest: () => 'admin',
        );

        final repoUrl = buildJob.github.repositoryUrl;
        final cloneCommand =
            'git clone https://x-access-token:$token@${repoUrl.replaceFirst("https://", "")}';
        await runCommand(
          client: client,
          command: cloneCommand,
          currentWorkingDirectory: null,
        );

        final commandsList = workflow.steps.map((e) => e.command).toList();

        for (final command in commandsList) {
          await runCommand(
            client: client,
            command: command,
            currentWorkingDirectory: workflow.currentWorkingDirectory,
          );
        }

        await stopVM(vmName);
        await deleteVM(vmName);
        await updateBuildStatus(
          jobId: buildJob.id,
          status: OpenCIGitHubChecksStatus.success,
        );
      } catch (e) {
        await updateBuildStatus(
          jobId: buildJob.id,
          status: OpenCIGitHubChecksStatus.failure,
        );
        _log('Error: $e, Try to run again');
      }
    }
  }
}
