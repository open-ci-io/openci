import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/commands/runner_command.dart';
import 'package:openci_runner/src/service/dartssh2/dartssh2_service.dart';
import 'package:openci_runner/src/service/logger_service.dart';

const int _maxDocumentSize = 1000000; // 1MB in bytes

Future<void> _saveLog(
  CommandLog log,
  String jobId,
) async {
  final firestore = firestoreSignal.value!;
  final logsRef = firestore
      .collection(buildJobsCollectionPath)
      .doc(jobId)
      .collection('logs');

  final logJson = log.toJson();
  final logSize = utf8.encode(json.encode(logJson)).length;

  if (logSize < _maxDocumentSize) {
    await logsRef.add(logJson);
    return;
  }

  // Split large logs into chunks
  final chunks = _splitLogIntoChunks(log);
  for (final chunk in chunks) {
    await logsRef.add(chunk.toJson());
  }
}

Future<void> runCommand({
  required SSHClient client,
  required String command,
  required String? currentWorkingDirectory,
  required String jobId,
}) async {
  final dartSSH2Service = dartSSH2ServiceSignal.value;
  final logger = loggerSignal.value;

  await dartSSH2Service.executeCommand(
    client: client,
    command: command,
    currentWorkingDirectory: currentWorkingDirectory,
    onDoneSuccess: (result) async {
      final log = CommandLog(
        command: command,
        logStdout: result.stdout,
        logStderr: result.stderr,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        exitCode: result.exitCode,
      );

      logger.info(
        'Command executed successfully: stdout: ${result.stdout}, stderr: ${result.stderr}',
      );

      await _saveLog(log, jobId);
    },
    onDoneError: (result) async {
      final log = CommandLog(
        command: command,
        logStdout: result.stdout,
        logStderr: result.stderr,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        exitCode: result.exitCode,
      );

      logger.err(
        'Command failed: stdout: ${result.stdout}, stderr: ${result.stderr}',
      );

      await _saveLog(log, jobId);

      throw Exception(
        'Command failed: stdout: ${result.stdout}, stderr: ${result.stderr}',
      );
    },
  );
}

List<CommandLog> _splitLogIntoChunks(CommandLog log) {
  const maxChunkSize = _maxDocumentSize ~/ 2; // Safe margin for metadata
  final chunks = <CommandLog>[];

  String splitOutput(String output) {
    if (output.isEmpty) return '';

    var start = 0;
    while (start < output.length) {
      final end = start + maxChunkSize;
      final chunk = output.substring(start, end.clamp(0, output.length));
      chunks.add(
        CommandLog(
          command: '${log.command} (part ${chunks.length + 1})',
          logStdout: log.logStdout.isNotEmpty ? chunk : '',
          logStderr: log.logStderr.isNotEmpty ? chunk : '',
          createdAt: log.createdAt,
          exitCode: log.exitCode,
        ),
      );
      start = end;
    }
    return output;
  }

  if (log.logStdout.isNotEmpty) {
    splitOutput(log.logStdout);
  }
  if (log.logStderr.isNotEmpty) {
    splitOutput(log.logStderr);
  }

  return chunks;
}
