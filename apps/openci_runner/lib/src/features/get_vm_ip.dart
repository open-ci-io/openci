import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/process_run.dart';

/// Returns the IP address of the VM with the given name.
///
/// Continuously polls the VM until an IP address is returned.
Future<String> getVMIp(String vmName, Logger logger) async {
  while (true) {
    try {
      final result = await run('tart ip $vmName');
      final output = result.first.stdout.toString().trim();

      if (output.isNotEmpty) {
        return output;
      }

      print('output: $output');

      logger.info('Waiting for VM to start...');
      await Future<void>.delayed(const Duration(seconds: 1));
    } catch (error) {
      print('Error: $error');
      continue;
    }
  }
}
