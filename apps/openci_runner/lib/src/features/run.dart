import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/commands/runner_command.dart';
import 'package:openci_runner/src/service/dartssh2/dartssh2_service.dart';
import 'package:openci_runner/src/service/logger_service.dart';

Future<void> runCommand({
  required SSHClient client,
  required String command,
  required String? currentWorkingDirectory,
  required String jobId,
}) async {
  final dartSSH2Service = dartSSH2ServiceSignal.value;
  final firestore = firestoreSignal.value!;
  final logger = loggerSignal.value;
  final ref = firestore
      .collection(buildJobsCollectionPath)
      .doc(jobId)
      .collection('logs')
      .doc();
  await dartSSH2Service.executeCommand(
    client: client,
    command: command,
    currentWorkingDirectory: currentWorkingDirectory,
    onDoneError: (result) async {
      final log = CommandLog(
        command: command,
        log: result.stderr,
        createdAt: DateTime.now(),
      );

      await ref.set(log.toJson());
      logger.err(
        'Command failed: stdout: ${result.stdout}, stderr: ${result.stderr}',
      );
      throw Exception(
        'Command failed: stdout: ${result.stdout}, stderr: ${result.stderr}',
      );
    },
    onDoneSuccess: (result) async {
      final log = CommandLog(
        command: command,
        log: result.stderr,
        createdAt: DateTime.now(),
      );

      await ref.set(log.toJson());
      logger.info(
        'Command executed successfully: stdout: ${result.stdout}, stderr: ${result.stderr}',
      );
    },
  );
}
