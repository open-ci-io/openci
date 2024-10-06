import 'package:args/args.dart';
import 'package:runner/src/features/command_args/app_args.dart';
import 'package:runner/src/services/logger/logger_service.dart';

Future<AppArgs> initializeApp(ArgResults? argResults) async {
  if (argResults == null) {
    throw Exception('ArgResults is null');
  }
  final firebaseProjectName = argResults['firebaseProjectName'] as String;
  final sentryDSN = argResults['sentryDSN'] as String?;
  final firebaseServiceAccountFileRelativePath =
      argResults['firebaseServiceAccountFileRelativePath'] as String;
  loggerSignal.value.success('Argument check passed.');

  return AppArgs(
    firebaseProjectName: firebaseProjectName,
    sentryDSN: sentryDSN,
    firebaseServiceAccountFileRelativePath:
        firebaseServiceAccountFileRelativePath,
  );
}
