import 'package:process_run/process_run.dart';
import 'package:uuid/uuid.dart';

Future<void> cloneVM(String vmName) async {
  const baseVMName = 'sonoma';

  try {
    final shell = Shell();
    final result = await shell.run('tart clone $baseVMName $vmName');

    if (result.first.exitCode != 0) {
      throw Exception('Failed to clone VM: ${result.first.stderr}');
    }
  } catch (error) {
    print('Command execution error: $error');
    rethrow;
  }
}
