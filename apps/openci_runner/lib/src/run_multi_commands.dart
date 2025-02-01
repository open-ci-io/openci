import 'dart:async';

import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/env.dart';
import 'package:openci_runner/src/features/get_workflow.dart';
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/handle_flutter_builld_ipa.dart';
import 'package:openci_runner/src/log.dart';
import 'package:openci_runner/src/run_command.dart';
import 'package:openci_runner/src/secrets.dart';

Future<void> runMultiCommands(
  Firestore firestore,
  String logId,
  String jobId,
  SSHClient client,
  BuildJob buildJob,
) async {
  final workflow = await getWorkflowModel(firestore, buildJob.workflowId);
  if (workflow == null) {
    log('Workflow not found');
    throw Exception('Workflow not found');
  }

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

    if (processedCommand.contains('flutter build ipa')) {
      await handleFlutterBuildIpa(
        logId,
        client,
        workflow,
        buildJob,
        firestore,
      );
    }

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
