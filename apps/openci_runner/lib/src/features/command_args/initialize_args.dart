import 'package:args/args.dart';
import 'package:runner/src/features/build_job/initialize_firestore.dart';
import 'package:runner/src/features/command_args/app_args.dart';
import 'package:runner/src/services/logger/logger_service.dart';
import 'package:runner/src/services/process/process_service.dart';
import 'package:runner/src/services/sentry/sentry_service.dart';

Future<void> initializeApp(ArgResults? argResults) async {
  if (argResults == null) {
    throw Exception('ArgResults is null');
  }
  final firebaseProjectName = argResults['firebaseProjectName'] as String;
  final sentryDSN = argResults['sentryDSN'] as String?;
  final firebaseServiceAccountFileRelativePath =
      argResults['firebaseServiceAccountFileRelativePath'] as String;
  loggerSignal.value.success('Argument check passed.');

  final appArgs = AppArgs(
    firebaseProjectName: firebaseProjectName,
    sentryDSN: sentryDSN,
    firebaseServiceAccountFileRelativePath:
        firebaseServiceAccountFileRelativePath,
  );

  initializeFirestore(appArgs);
  await sentryServiceSignal.value.initializeSentry(appArgs.sentryDSN);
  processServiceSignal.value.watchKeyboardSignals();
}
