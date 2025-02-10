import 'dart:async';

import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/env.dart';
import 'package:openci_runner/src/features/get_workflow.dart';
import 'package:openci_runner/src/features/update_build_status.dart';
import 'package:openci_runner/src/firebase.dart';
import 'package:openci_runner/src/handle_flutter_builld_ipa.dart';
import 'package:openci_runner/src/log.dart';
import 'package:openci_runner/src/run_command.dart';
import 'package:openci_runner/src/secrets.dart';

bool doesSecretContainIOSBuildNumber(Map<String, dynamic> secrets) {
  if (secrets.keys.any((key) => key.contains('IOS_BUILD_NUMBER')) == true) {
    return true;
  }
  return false;
}

Future<void> incrementBuildNumber(String secretKey) async {
  final firestore = firestoreSignal.value!;
  final qs = firestore
      .collection(secretsCollectionPath)
      .where('key', WhereFilter.equal, secretKey);
  final docs = await qs.get();
  final data = docs.docs.first.data();
  final buildNumber = data['value'] as String?;
  if (buildNumber == null) {
    throw Exception('BUILD_NUMBER is not found');
  }
  final incrementedBuildNumber = int.parse(buildNumber) + 1;
  await firestore
      .collection(secretsCollectionPath)
      .doc(docs.docs.first.id)
      .update({
    'value': incrementedBuildNumber.toString(),
  });
}

bool _doesCommandContainBuildNumber(String command) {
  return command.contains('--build-number');
}

Future<void> runMultiCommands(
  Firestore firestore,
  String logId,
  String jobId,
  SSHClient client,
  BuildJob buildJob,
) async {
  final workflow = await getWorkflowModel(firestore, buildJob.workflowId);
  if (workflow == null) {
    openciLog('Workflow not found');
    throw Exception('Workflow not found');
  }

  final commandsList = workflow.steps.map((e) => e.command).toList();
  final secrets = await fetchSecrets(
    workflowId: workflow.id,
    firestore: firestore,
    owners: workflow.owners,
  );

  for (final command in commandsList) {
    final replacementResult = replaceEnvironmentVariables(
      command: command,
      secrets: secrets,
    );

    if (replacementResult.replacedCommand.contains('flutter build ipa')) {
      if (doesSecretContainIOSBuildNumber(secrets) &&
          _doesCommandContainBuildNumber(replacementResult.replacedCommand)) {
        await incrementBuildNumber('IOS_BUILD_NUMBER');
      }

      await handleFlutterBuildIpa(
        logId,
        client,
        workflow,
        buildJob,
        firestore,
        replacementResult,
      );
    } else {
      await runCommand(
        logId: logId,
        client: client,
        command: replacementResult.replacedCommand,
        currentWorkingDirectory: workflow.currentWorkingDirectory,
        jobId: buildJob.id,
      );
    }
  }

  await updateBuildStatus(
    jobId: buildJob.id,
    status: OpenCIGitHubChecksStatus.success,
  );
}
