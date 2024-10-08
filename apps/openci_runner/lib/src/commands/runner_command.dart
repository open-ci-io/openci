// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:runner/src/commands/handle_exception.dart';
import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/features/build_job/fetch_workflow.dart';
import 'package:runner/src/features/build_job/find_job.dart';
import 'package:runner/src/features/build_job/finish_job.dart';
import 'package:runner/src/features/build_job/run_command.dart';
import 'package:runner/src/features/build_job/update_checks.dart';
import 'package:runner/src/features/command_args/initialize_args.dart';
import 'package:runner/src/services/logger/logger_service.dart';

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
    await initializeApp(argResults);
    while (!shouldExitSignal.value) {
      await Future<void>.delayed(const Duration(seconds: 1));
      final job = await findJob();
      if (job == null) {
        loggerSignal.value.info('No job found: ${DateTime.now()}');
        continue;
      }
      final workflow = await fetchWorkflow(job.workflowId);
      try {
        await setInProgress(job.id);
        await vmServiceSignal.value.startVM();
        for (final step in workflow.steps) {
          await executeStepCommands(step.commands, job.github.installationId);
        }
        await finishJob(job.id);
      } catch (error, stackTrace) {
        await handleException(error, stackTrace, job.id);
        continue;
      } finally {
        await Future<void>.delayed(const Duration(seconds: 10));
      }
    }

    exit(0);
  }
}
