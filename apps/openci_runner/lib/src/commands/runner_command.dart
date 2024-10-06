import 'dart:async';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/commands/handle_exception.dart';
import 'package:runner/src/features/build_job/find_job.dart';
import 'package:runner/src/features/command_args/initialize_args.dart';
import 'package:runner/src/services/logger/logger_service.dart';
import 'package:runner/src/services/process/process_service.dart';
import 'package:runner/src/services/sentry/sentry_service.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:runner/src/services/tart/tart_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';
import 'package:runner/src/services/vm_service.dart';
import 'package:signals_core/signals_core.dart';

final shouldExitSignal = signal(false);
final isSearchingSignal = signal(false);
final progressSignal = signal<Progress?>(null);
final workingVMNameSignal = signal(UuidService.generateV4());
final supabaseRowIdSignal = signal<int?>(null);
final sshClientSignal = signal<SSHClient?>(null);
final localShellServiceSignal = signal(LocalShellService());
final tartServiceSignal = signal(TartService(localShellServiceSignal.value));
final vmServiceSignal = signal(VMService(tartServiceSignal.value));
final sshSignal = sshShellServiceSignal.value;
final isDebugMode = signal(true);

final isDebugSignal = signal(false);
final firestoreClientSignal = signal<Firestore?>(null);

final nonNullFirestoreClientSignal = computed(() {
  final client = firestoreClientSignal.value;
  if (client == null) {
    throw Exception('Firestore client is not initialized');
  }
  return client;
});

class RunnerCommand extends Command<int> {
  RunnerCommand() {
    argParser
      ..addOption(
        'firebaseProjectName',
        help: 'Firebase Project Name',
        abbr: 'f',
      )
      ..addOption(
        'sentryDSN',
        help: 'Sentry DSN',
        abbr: 's',
      )
      ..addOption(
        'firebaseServiceAccountFileRelativePath',
        help: 'Firebase Service Account File Relative Path',
        abbr: 'p',
      );
  }

  @override
  String get description => 'Open CI core command';

  @override
  String get name => 'run';

  @override
  Future<int> run() async {
    final appArgs = await initializeApp(argResults);

    final admin = FirebaseAdminApp.initializeApp(
      appArgs.firebaseProjectName,
      Credential.fromServiceAccount(
        File(appArgs.firebaseServiceAccountFileRelativePath),
      ),
    );
    firestoreClientSignal.value = Firestore(admin);

    await sentryServiceSignal.value.initializeSentry(appArgs.sentryDSN);

    processServiceSignal.value.watchKeyboardSignals();

    while (!shouldExitSignal.value) {
      try {
        await Future<void>.delayed(const Duration(seconds: 1));
        final job = await findJob();
        if (job == null) {
          loggerSignal.value.info('No job found');
          continue;
        }
        print('job: $job');
        final vmIp = await vmServiceSignal.value.startVM();
        await sshServiceSignal.value.sshToServer(vmIp);
        await sshSignal.executeCommandV2(
          'ls',
        );

        await vmServiceSignal.value.cleanupVMs();
      } catch (error, stackTrace) {
        await handleException(error, stackTrace);
        continue;
      } finally {
        await Future<void>.delayed(const Duration(seconds: 10));
      }
    }

    exit(0);
  }
}
