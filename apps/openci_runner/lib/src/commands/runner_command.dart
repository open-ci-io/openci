import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
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
    final client = SSHClient(
      await SSHSocket.connect('192.168.64.2', 22),
      username: 'admin',
      onPasswordRequest: () => 'admin',
    );

    final shell = await client.shell();

    final result = await client.execute('ls -l');
    // stdout.addStream(shell.stdout); // listening for stdout
    // stderr.addStream(shell.stderr); // listening for stderr
    // stdin.cast<Uint8List>().listen(shell.write); // writing to stdin

    // final session = await client.execute('ls');
    // await session.stdin.addStream(session.stdout);
    // await session.stdin.addStream(session.stderr);

    // await session.stdin
    //     .close(); // Close the sink to send EOF to the remote process.

    // await session
    //     .done; // Wait for session to exit to ensure all data is flushed to the remote process.
    // print(session.exitCode); //

    // while (!shouldExitSignal.value) {
    //   await Future<void>.delayed(const Duration(seconds: 1));
    //   final job = await findJob();
    //   if (job == null) {
    //     loggerSignal.value.info('No job found: ${DateTime.now()}');
    //     continue;
    //   }

    //   try {
    //     final workflow = await fetchWorkflow(job.workflowId);
    //     await setInProgress(job.id);
    //     await vmServiceSignal.value.startVM();
    //     for (final step in workflow.steps) {
    //       await executeStepCommands(step.commands, job.github.installationId);
    //     }
    //     // TODO: Androidのビルド
    //     // TODO: ビルドのFADへのアップロード
    //     // TODO: 現場HubでOpenCIへ移行
    //     await finishJob(job.id);
    //   } catch (error, stackTrace) {
    //     await handleException(error, stackTrace, job.id);
    //     continue;
    //   } finally {
    //     await Future<void>.delayed(const Duration(seconds: 10));
    //   }
    // }

    exit(0);
  }
}
