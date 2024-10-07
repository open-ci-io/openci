import 'dart:async';

import 'package:dartssh2/dartssh2.dart';
import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/services/shell/shell_result.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:signals_core/signals_core.dart';

final sshShellServiceSignal = computed(() {
  final sshService = sshServiceSignal.value;
  return SSHShellService(sshService);
});

class SSHShellService {
  SSHShellService(this._sshService);
  final SSHService _sshService;

  SSHClient get _sshClient {
    final sshClient = sshClientSignal.value;
    if (sshClient == null) {
      throw Exception('SSHClient is null');
    }
    return sshClient;
  }

  Future<ShellResult> executeCommand(
    String command,
    SSHClient sshClient,
    String jobId,
    String workingVMName,
  ) async =>
      _sshService.shellV2(
        sshClient,
        command,
      );

  Future<ShellResult> executeCommandV2(
    String command,
  ) async =>
      _sshService.shellV2(
        _sshClient,
        command,
      );
}
