import 'dart:async';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:openci_models/openci_models.dart';
import 'package:runner/src/commands/handle_exception.dart';
import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/features/build_job/fetch_workflow.dart';
import 'package:runner/src/features/build_job/find_job.dart';
import 'package:runner/src/features/build_job/initialize_firestore.dart';
import 'package:runner/src/features/build_job/update_checks.dart';
import 'package:runner/src/features/command_args/initialize_args.dart';
import 'package:runner/src/services/logger/logger_service.dart';
import 'package:runner/src/services/process/process_service.dart';
import 'package:runner/src/services/sentry/sentry_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';

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
    initializeFirestore(appArgs);

    await sentryServiceSignal.value.initializeSentry(appArgs.sentryDSN);

    processServiceSignal.value.watchKeyboardSignals();

    while (!shouldExitSignal.value) {
      await Future<void>.delayed(const Duration(seconds: 1));
      final job = await findJob();
      if (job == null) {
        loggerSignal.value.info('No job found: ${DateTime.now()}');
        continue;
      }
      final workflow = await fetchWorkflow(job.workflowId);
      final steps = workflow.steps;
      try {
        await updateChecks(
          jobId: job.id,
          status: OpenCIGitHubChecksStatus.inProgress,
        );
        final vmIp = await vmServiceSignal.value.startVM();
        await sshServiceSignal.value.sshToServer(vmIp);

        for (final step in steps) {
          for (final command in step.commands) {
            await sshSignal.executeCommandV2(command);
          }
        }

        await vmServiceSignal.value.stopVM();
        await updateChecks(
          jobId: job.id,
          status: OpenCIGitHubChecksStatus.success,
        );
      } catch (error, stackTrace) {
        await handleException(error, stackTrace);
        await updateChecks(
          jobId: job.id,
          status: OpenCIGitHubChecksStatus.failure,
        );
        continue;
      } finally {
        await Future<void>.delayed(const Duration(seconds: 10));
      }
    }

    exit(0);
  }
}
