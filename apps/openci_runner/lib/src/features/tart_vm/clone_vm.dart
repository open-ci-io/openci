import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/service/logger_service.dart';
import 'package:process_run/process_run.dart';

Future<void> cloneVM(String vmName) async {
  final logger = loggerSignal.value;

  try {
    final shell = Shell();
    logger.info('Cloning VM: $vmBaseName to $vmName');
    final result = await shell.run('tart clone $vmBaseName $vmName');

    if (result.first.exitCode != 0) {
      throw Exception('Failed to clone VM: ${result.first.stderr}');
    }
    logger.info('Successfully cloned VM: $vmName');
  } catch (error) {
    logger.err('Failed to clone VM: $error');
    rethrow;
  }
}
