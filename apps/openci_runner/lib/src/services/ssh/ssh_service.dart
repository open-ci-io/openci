import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/services/shell/shell_result.dart';
import 'package:runner/src/services/ssh/domain/session_result.dart';
import 'package:signals_core/signals_core.dart';

final sshServiceSignal = signal(SSHService());

class SSHService {
  SSHService();

  Logger logger = Logger();
  Future<void> sshToServer(
    String vmIp, {
    String username = 'admin',
    String password = 'admin',
  }) async {
    final client = SSHClient(
      await SSHSocket.connect(vmIp, 22),
      username: username,
      onPasswordRequest: () => password,
    );
    sshClientSignal.value = client;
  }

  @Deprecated('use run()')
  Future<bool> shell(String command, SSHClient client) async {
    final logger = Logger();
    final shell = await client.shell();
    const encoder = Utf8Encoder();
    shell
      ..write(encoder.convert('$command\n'))
      ..write(encoder.convert('exit\n'));
    await stdout.addStream(shell.stdout);
    await stderr.addStream(shell.stderr);

    logger
      ..success('stdout: ${shell.stdout}')
      ..err('stderr: ${shell.stderr}');
    shell.close();
    if (shell.exitCode == null) {
      return true;
    }
    return shell.exitCode == 0;
  }

  @Deprecated('prefer use runV2')
  Future<bool> run(SSHClient client, String command) async {
    final session = await client.execute(command);
    final logger = Logger();

    final stdout = await session.stdout
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .join();
    logger.success('stdout: $stdout');

    final stderr = await session.stderr
        .cast<List<int>>()
        .transform(const Utf8Decoder())
        .join();
    logger.err('stderr: $stderr');

    if (stderr.isNotEmpty) {
      return false;
    }
    return true;
  }

  String? customInfoStyle(String? m) {
    return lightBlue.wrap(styleBold.wrap(lightBlue.wrap(m)));
  }

  Future<SessionResult> runV2(SSHClient client, String command) async {
    var sessionStdout = '';
    var sessionStderr = '';
    int? exitCode;

    logger.info('command: $command', style: customInfoStyle);
    final session = await client.execute(command);
    await session.stdin.close();
    await session.done;
    exitCode = session.exitCode;
    sessionStdout = await streamToString(session.stdout);
    sessionStderr = await streamToString(session.stderr);

    if (exitCode == 0) {
      logger
        ..success('stdout: $sessionStdout')
        ..success('stderr: $sessionStderr');
    } else {
      logger
        ..err('exitCode: $exitCode, stdout: $sessionStdout')
        ..err('exitCode: $exitCode, stderr: $sessionStderr');
    }

    return SessionResult(
      sessionExitCode: exitCode,
      sessionStdout: sessionStdout,
      sessionStderr: sessionStderr,
    );
  }

  Future<String> streamToString(Stream<Uint8List> stream) async {
    final bytes = await stream.fold<List<int>>(
      [],
      (previous, element) => previous..addAll(element),
    );

    return utf8.decode(bytes);
  }

  Future<ShellResult> shellV2(
    SSHClient sshClient,
    String command,
  ) async {
    final sessionResult = await runV2(
      sshClient,
      command,
    );

    final exitCode = sessionResult.sessionExitCode;
    if (exitCode == 0) {
      return ShellResult(result: true, sessionResult: sessionResult);
    } else {
      throw Exception('$command failed with exit code $exitCode');
    }
  }
}
