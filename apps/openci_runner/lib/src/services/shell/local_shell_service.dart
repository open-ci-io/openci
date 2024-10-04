import 'package:process_run/shell.dart';
import 'package:runner/src/services/shell/shell_result.dart';
import 'package:runner/src/services/ssh/domain/session_result.dart';

class LocalShellService {
  Future<ShellResult> executeCommand(String command) async {
    final shell = Shell();

    await shell.run('echo $command');
    final resultList = await shell.run(command);
    final result = resultList.first;

    final exitCode = result.exitCode;
    final sessionResult = SessionResult(
      sessionStdout: result.stdout.toString(),
      sessionStderr: result.stderr.toString(),
      sessionExitCode: exitCode,
    );
    if (sessionResult.sessionExitCode == 0) {
      return ShellResult(result: true, sessionResult: sessionResult);
    } else {
      return ShellResult(result: false, sessionResult: sessionResult);
    }
  }
}
