import 'package:mason_logger/mason_logger.dart';
import 'package:openci_runner/src/service/logger_service.dart';
import 'package:process_run/process_run.dart';

Future<void> deleteVM(String vmName) async {
  final logger = loggerSignal.value;
  try {
    final shell = Shell();
    logger.info('Deleting VM: $vmName');
    final result = await shell.run('tart delete $vmName');

    if (result.first.exitCode != 0) {
      throw Exception('Failed to delete VM: ${result.first.stderr}');
    }
    logger.info('Successfully deleted VM: $vmName');
  } catch (error) {
    logger.err('Failed to delete VM: $error');
    rethrow;
  }
}

Future<void> cleanUpVMs() async {
  final logger = Logger();
  final shell = Shell();

  try {
    final result = await shell.run('tart list');
    final output = result.first.stdout.toString();

    final lines = output.split('\n').skip(1); // Skip header line
    for (final line in lines) {
      final parts = line.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        final vmName = parts[1];
        if (vmName != 'sonoma') {
          logger.info('Deleting VM: $vmName');
          try {
            await deleteVM(vmName);
            logger.success('Successfully deleted $vmName');
          } catch (error) {
            logger.warn('Error deleting $vmName: $error');
          }
        }
      }
    }

    logger.success('All VMs cleanup completed');
  } catch (error) {
    logger.err('Failed to list VMs: $error');
    rethrow;
  }
}
