import 'package:dartssh2/dartssh2.dart';
import 'package:runner/src/services/shell/shell_result.dart';

import 'package:runner/src/services/ssh/ssh_service.dart';

class SSHShellService {
  SSHShellService(this._sshService);
  final SSHService _sshService;

  Future<ShellResult> executeCommand(
    String command,
    SSHClient sshClient,
    String jobId,
    String workingVMName,
  ) async =>
      _sshService.shellV2(command, sshClient, jobId, workingVMName);
}
