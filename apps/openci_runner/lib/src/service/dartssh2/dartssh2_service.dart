import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_models/openci_models.dart';
import 'package:signals_core/signals_core.dart';

final dartSSH2ServiceSignal = signal(DartSSH2Service());

class DartSSH2Service {
  final _defaultCommand = 'source ~/.zshrc';
  final _commandSeparator = ' && ';

  String _cwd(String? currentWorkingDirectory) {
    return currentWorkingDirectory == null
        ? ''
        : 'cd $currentWorkingDirectory$_commandSeparator';
  }

  Future<SessionResult> executeCommand({
    required SSHClient client,
    required String command,
    required String? currentWorkingDirectory,
    required Future<void> Function(SessionResult) onDoneError,
    required Future<void> Function(SessionResult) onDoneSuccess,
  }) async {
    final fullCommand =
        '$_defaultCommand$_commandSeparator${_cwd(currentWorkingDirectory)}$command';
    final logger = Logger()..info('Executing command: $fullCommand');
    final session = await client.execute(fullCommand);
    await session.stdin.close();

    await session.done;
    final exitCode = session.exitCode;

    final output = await _decodeStream(session.stdout);
    final error = await _decodeStream(session.stderr);

    if (exitCode == null) {
      throw Exception('exitCode is null');
    }
    logger.success('Command executed successfully');

    final result = SessionResult(
      stdout: output,
      stderr: error,
      exitCode: exitCode,
    );

    if (exitCode == 0) {
      await onDoneSuccess(result);
    } else {
      await onDoneError(result);
    }
    return result;
  }

  Future<String> _decodeStream(Stream<List<int>> stream) async {
    return utf8.decoder.bind(stream).join();
  }
}
