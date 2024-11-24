import 'package:openci_runner/src/service/logger_service.dart';
import 'package:process_run/process_run.dart';

Future<void> runVM(String vmName) async {
  final logger = loggerSignal.value;
  try {
    await run('tart run $vmName');
  } catch (error) {
    logger.err('Command execution error: $error');
  }
}
