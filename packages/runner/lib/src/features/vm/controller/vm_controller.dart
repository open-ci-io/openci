import 'dart:convert';

import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/services/tart/tart_service.dart';

class VMController {
  VMController(this.workingVMName, this._tartService);
  final String workingVMName;
  final TartService _tartService;
  Logger logger = Logger();

  Future<void> get cloneVM async {
    const baseVMName = 'sonoma';
    await _tartService.clone(baseVMName, workingVMName);
  }

  Future<void> get launchVM => _tartService.run(workingVMName);

  Future<void> get stopVM async {
    await _tartService.stop(workingVMName);
    await _tartService.delete(workingVMName);
  }

  Future<bool> get cleanupVMs async {
    final result = await _tartService.tartList();
    final lines = const LineSplitter().convert(result.first.stdout as String);

    for (final line in lines) {
      if (line.contains('stopped')) {
        final parts = line.split(RegExp(r'\s+'));
        if (parts.length > 1) {
          final uuid = parts[1];
          // UUID v4パターンに一致するか確認
          if (RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ).hasMatch(uuid)) {
            // 一致する場合、'tart delete'コマンドを実行
            Logger().info('Deleting: $uuid');
            await _tartService.delete(uuid);
          }
        }
      }
    }
    logger.success('tart VMs cleanup completed');
    return true;
  }

  Future<String> get fetchIpAddress async {
    try {
      final ip = await _tartService.getVMIp(workingVMName);
      final ipRegex =
          RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'); // 正規表現でIPv4をマッチング

      final Iterable<Match> matches = ipRegex.allMatches(ip);

      if (matches.length == 1) {
        logger.info('Found IP Address: ${matches.first.group(0)}');
      } else if (matches.length > 1) {
        logger.warn('More than one IP addresses found.');
      } else {
        logger.alert('No IP addresses found.');
      }
      return matches.first.group(0)!;
    } catch (e) {
      logger.err(e.toString());
      rethrow;
    }
  }
}
