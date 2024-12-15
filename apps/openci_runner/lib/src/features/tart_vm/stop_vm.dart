import 'package:openci_runner/src/service/logger_service.dart';
import 'package:process_run/process_run.dart';

Future<void> stopVM(String vmName) async {
  final logger = loggerSignal.value;

  try {
    final shell = Shell();
    logger.info('Stopping VM: $vmName');
    final result = await shell.run('tart stop $vmName');

    if (result.first.exitCode != 0) {
      throw Exception('Failed to stop VM: ${result.first.stderr}');
    }
    logger.info('Successfully stopped VM: $vmName');
  } catch (error) {
    logger.err('Failed to stop VM: $error');
    rethrow;
  }
}
