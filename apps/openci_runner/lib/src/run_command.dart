import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/exceptions/command_execution_exception.dart';
import 'package:openci_runner/src/firebase.dart';
import 'package:openci_runner/src/service/dartssh2/dartssh2_service.dart';
import 'package:openci_runner/src/service/logger_service.dart';

Future<SessionResult> runCommand({
  required SSHClient client,
  required String command,
  required String? currentWorkingDirectory,
  required String jobId,
  required String logId,
}) async {
  final dartSSH2Service = dartSSH2ServiceSignal.value;
  final firestore = firestoreSignal.value!;
  final logger = loggerSignal.value;
  final ref = firestore
      .collection(buildJobsCollectionPath)
      .doc(jobId)
      .collection('logs')
      .doc(logId);

  final docs = await ref.get();
  if (!docs.exists) {
    await ref.set({
      'logs': [],
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  try {
    return await dartSSH2Service.executeCommand(
      client: client,
      command: command,
      currentWorkingDirectory: currentWorkingDirectory,
      onDoneError: (result) async {
        final log = CommandLog(
          command: command,
          logStdout: result.stdout,
          logStderr: result.stderr,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          exitCode: result.exitCode,
        );

        await ref.update({
          'logs': FieldValue.arrayUnion([log.toJson()]),
        });

        logger.err(
          'Command execution failed with exit code ${result.exitCode}: stdout: ${result.stdout}, stderr: ${result.stderr}',
        );
        throw CommandExecutionException(
          command: command,
          stdout: result.stdout,
          stderr: result.stderr,
          exitCode: result.exitCode,
        );
      },
      onDoneSuccess: (result) async {
        final log = CommandLog(
          command: command,
          logStdout: result.stdout,
          logStderr: result.stderr,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          exitCode: result.exitCode,
        );

        await ref.update({
          'logs': FieldValue.arrayUnion([log.toJson()]),
        });
        logger.info(
          'Command executed successfully: stdout: ${result.stdout}, stderr: ${result.stderr}',
        );
      },
    );
  } catch (e) {
    logger.err('Failed to execute command: $command');
    rethrow;
  }
}
