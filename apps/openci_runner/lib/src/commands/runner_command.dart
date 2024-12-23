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
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/firebase/firebase_admin.dart';
import 'package:openci_runner/src/service/github/clone_command.dart';
import 'package:openci_runner/src/service/github/get_github_installation_token.dart';
import 'package:openci_runner/src/service/uuid_service.dart';
import 'package:signals_core/signals_core.dart';

final firestoreSignal = signal<Firestore?>(null);

class RunnerCommand extends Command<int> {
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

  Future<Map<String, String>> _fetchSecrets({
    required String workflowId,
    required Firestore firestore,
    required List<String> owners,
  }) async {
    final secretsSnapshot = await firestore
        .collection(secretsCollectionPath)
        .where('owners', WhereFilter.arrayContainsAny, owners)
        .get();

    return Map.fromEntries(
      secretsSnapshot.docs.map(
        (doc) => MapEntry(
          doc.data()['key']! as String,
          doc.data()['value']! as String,
        ),
      ),
    );
  }

  String _replaceEnvironmentVariables({
    required String command,
    required Map<String, String> secrets,
  }) {
    var processedCommand = command;
    for (final entry in secrets.entries) {
      processedCommand = processedCommand.replaceAll(
        '\$${entry.key}',
        entry.value,
      );
    }
    return processedCommand;
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
      final buildJob = await tryGetBuildJob(
        firestore: firestore,
        log: () =>
            _log('No build jobs found. Waiting 1 second before retrying.'),
      );
      if (buildJob == null) continue;
      _log('Found ${buildJob.toJson()} build jobs');
      final vmName = generateUUID;
      final logId = generateUUID;
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
        final secrets = await _fetchSecrets(
          workflowId: workflow.id,
          firestore: firestore,
          owners: workflow.owners,
        );

        for (final command in commandsList) {
          final processedCommand = _replaceEnvironmentVariables(
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
      } catch (e) {
        await updateBuildStatus(
          jobId: buildJob.id,
          status: OpenCIGitHubChecksStatus.failure,
        );
        _log('Error: $e, Try to run again');
      } finally {
        try {
          await stopVM(vmName);
          await deleteVM(vmName);
        } catch (e) {
          _log('Error: $e, Try to run again');
        }
      }
      continue;
    }
  }
}
