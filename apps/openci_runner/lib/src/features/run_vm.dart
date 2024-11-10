import 'package:process_run/process_run.dart';

Future<void> runVM(String vmName) async {
  try {
    await run('tart run $vmName');
  } catch (error) {
    print('Command execution error: $error');
  }
}
