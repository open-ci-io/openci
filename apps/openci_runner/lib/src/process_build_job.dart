import 'dart:async';

import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/env.dart';
import 'package:openci_runner/src/features/get_workflow.dart';
import 'package:openci_runner/src/features/run.dart';
import 'package:openci_runner/src/features/tart_vm/clone_vm.dart';
import 'package:openci_runner/src/features/tart_vm/get_vm_ip.dart';
import 'package:openci_runner/src/features/tart_vm/run_vm.dart';
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/log.dart';
import 'package:openci_runner/src/secrets.dart';
import 'package:openci_runner/src/service/github/clone_command.dart';
import 'package:openci_runner/src/service/github/get_github_installation_token.dart';

Future<void> processBuildJob(
  BuildJob buildJob,
  Firestore firestore,
  String pem,
  String vmName,
  String logId,
) async {
  final workflow = await getWorkflowModel(firestore, buildJob.workflowId);
  if (workflow == null) {
    log('Workflow not found');
    throw Exception('Workflow not found');
  }

  final token = await getGitHubInstallationToken(
    installationId: buildJob.github.installationId,
    appId: buildJob.github.appId,
    privateKey: pem,
  );
  log('Successfully got GitHub access token: $token', isSuccess: true);

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
}
