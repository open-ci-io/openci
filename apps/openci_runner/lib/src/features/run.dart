import 'package:dartssh2/dartssh2.dart';
import 'package:openci_runner/src/commands/runner_command.dart';
import 'package:openci_runner/src/service/dartssh2/dartssh2_service.dart';

Future<void> runCommand({
  required SSHClient client,
  required String command,
  required String? currentWorkingDirectory,
}) async {
  final dartSSH2Service = dartSSH2ServiceSignal.value;
  final firestore = firestoreSignal.value!;
  await dartSSH2Service.executeCommand(
    client: client,
    command: command,
    currentWorkingDirectory: currentWorkingDirectory,
    onDoneError: (result) async {
      final ref = firestore.collection('logsV2').doc();
      await ref.set({
        'log': result.stderr,
        'createdAt': DateTime.now(),
      });
    },
    onDoneSuccess: (result) async {
      final ref = firestore.collection('logsV2').doc();
      await ref.set({
        'log': result.stderr,
        'createdAt': DateTime.now(),
      });
    },
  );
}
