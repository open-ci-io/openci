import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/shell/shell_result.dart';
import 'package:runner/src/services/tart/tart_command.dart';
import 'package:process_run/shell.dart' as process_run;

class TartService {
  TartService(this._shellService);

  final LocalShellService _shellService;

  final _logger = Logger();

  Future<ShellResult> _runShell(String command) =>
      _shellService.executeCommand(command);

  Future<void> stop(String vmName) => _runShell('${TartCommand.stop} $vmName');

  Future<void> run(String vmName) => _runShell('${TartCommand.run} $vmName');

  Future<void> delete(String vmName) async {
    try {
      await _runShell('${TartCommand.delete} $vmName');
    } catch (e) {
      _logger.warn(e.toString());
    }
  }

  Future<void> clone(String baseVMName, String newVMName) =>
      _runShell('${TartCommand.clone} $baseVMName $newVMName');

  Future<ShellResult> ip(String vmName) =>
      _runShell('${TartCommand.ip} $vmName');

  Future<String> getVMIp(String vmName) async {
    final vmIp = await ip(vmName);
    if (vmIp.result) {
      return vmIp.sessionResult.sessionStdout;
    } else {
      throw Exception(
        'Could not find VM IP: ${vmIp.sessionResult.sessionStderr}',
      );
    }
  }

  Future<List<ProcessResult>> tartList() async =>
      process_run.run(TartCommand.list, verbose: false);
}
