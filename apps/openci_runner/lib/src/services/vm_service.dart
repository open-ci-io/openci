import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/process_run.dart';
import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/services/logger/logger_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:runner/src/services/tart/tart_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';

class VMService {
  VMService(this._tartService);

  final TartService _tartService;

  Logger get _logger => loggerSignal.value;

  Future<void> waitForTartIP(String workingVMName) async {
    while (true) {
      final shell = Shell();
      List<ProcessResult>? result;
      try {
        result = await shell.run('tart ip $workingVMName');
      } catch (e) {
        result = null;
      }
      if (result != null) {
        break;
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  void _createNewVMName() =>
      workingVMNameSignal.value = UuidService.generateV4();

  Future<void> startVM() async {
    _createNewVMName();
    final workingVMName = workingVMNameSignal.value;
    await cloneVM(workingVMName);
    unawaited(launchVM(workingVMName));
    await waitForTartIP(workingVMName);

    _logger.success('VM is ready');
    final vmIp = await fetchIpAddress(workingVMName);
    await sshServiceSignal.value.sshToServer(vmIp);
  }

  Future<void> cloneVM(String workingVMName) async {
    const baseVMName = 'sonoma';
    await _tartService.clone(baseVMName, workingVMName);
  }

  Future<void> launchVM(String workingVMName) =>
      _tartService.run(workingVMName);

  Future<void> stopVM() async {
    final workingVMName = workingVMNameSignal.value;
    await _tartService.stop(workingVMName);
    await cleanupVMs();
  }

  Future<bool> cleanupVMs() async {
    final result = await _tartService.tartList();
    final lines = const LineSplitter().convert(result.first.stdout as String);

    for (final line in lines) {
      if (line.contains('stopped')) {
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length > 1) {
          final uuid = parts[1];
          // UUID v4パターンに一致するか確認
          if (RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-'
            r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ).hasMatch(uuid)) {
            // 一致する場合、'tart delete'コマンドを実行
            Logger().info('Deleting: $uuid');
            await _tartService.delete(uuid);
          }
        }
      }
    }
    _logger.success('tart VMs cleanup completed');
    return true;
  }

  Future<String> fetchIpAddress(String workingVMName) async {
    try {
      final ip = await _tartService.getVMIp(workingVMName);
      final ipRegex =
          RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'); // 正規表現でIPv4をマッチング

      final Iterable<Match> matches = ipRegex.allMatches(ip);

      if (matches.length == 1) {
        _logger.info('Found IP Address: ${matches.first.group(0)}');
      } else if (matches.length > 1) {
        _logger.warn('More than one IP addresses found.');
      } else {
        _logger.alert('No IP addresses found.');
      }
      return matches.first.group(0)!;
    } catch (e) {
      _logger.err(e.toString());
      rethrow;
    }
  }
}
