import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/models/job/job_model.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:runner/src/services/supabase/supabase_service.dart';
import 'package:runner/src/services/tart/tart_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';
import 'package:runner/src/services/vm_service.dart';
import 'package:process_run/shell.dart';
import 'package:sentry/sentry.dart';

class AppArgs {
  AppArgs({
    required this.supabaseUrl,
    required this.supabaseAPIKey,
  });
  final String supabaseUrl;
  final String supabaseAPIKey;
}

bool shouldExit = false;

class RunnerCommand extends Command<int> {
  RunnerCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'supabaseUrl',
        help: 'Supabase URL',
        abbr: 'u',
      )
      ..addOption(
        'supabaseAPIKey',
        help: 'Supabase API Key',
        abbr: 'k',
      )
      ..addOption(
        'sentryDSN',
        help: "Sentry's DSN",
        abbr: 'd',
      );
  }

  Future<AppArgs> initializeApp(ArgResults? argResults) async {
    if (argResults == null) {
      throw Exception('ArgResults is null');
    }
    final supabaseUrl = argResults['supabaseUrl'] as String;
    final supabaseAPIKey = argResults['supabaseAPIKey'] as String;

    return AppArgs(
      supabaseUrl: supabaseUrl,
      supabaseAPIKey: supabaseAPIKey,
    );
  }

  Future<void> initializeSentry(String? sentryDSN) async {
    if (sentryDSN != null) {
      await Sentry.init((options) {
        options
          ..dsn = sentryDSN
          ..tracesSampleRate = 1.0;
      });
    }
  }

  @override
  String get description => 'Open CI core command';

  @override
  String get name => 'run';

  final Logger _logger;

  @override
  Future<int> run() async {
    final appArgs = await initializeApp(argResults);
    final supabaseService = supabaseServiceSignal.value;
    final supabaseClient = await supabaseService.initSupabase(
      url: appArgs.supabaseUrl,
      key: appArgs.supabaseAPIKey,
    );
    _logger.success('Argument check passed.');

    var isSearching = false;

    Progress? progress;

    ProcessSignal.sigterm.watch().listen((signal) {
      _logger.warn('Received SIGTERM. Terminating the CLI...');
    });

    ProcessSignal.sigint.watch().listen((signal) {
      _logger.warn('Received SIGINT. Terminating the CLI...');
      shouldExit = true;
      exit(0);
    });

    while (!shouldExit) {
      try {
        if (isSearching == false) {
          _logger.info('Searching new job');
          progress = _logger.progress('Searching new job');

          isSearching = true;
        }

        final data = await supabaseClient
            .from('jobs')
            .select('*')
            .limit(1)
            .order('created_at');

        if (data.isEmpty && progress != null) {
          progress.update('No jobs were found, retrying in 10 seconds');

          await Future<void>.delayed(const Duration(seconds: 10));
          continue;
        }

        final job = JobModel.fromJson(data.first);

        progress!.complete('New job found: $job');

        isSearching = false;

        // prepare service classes
        final localShellService = LocalShellService();
        final tartService = TartService(localShellService);
        final vmService = VMService(tartService);

        final workingVMName = UuidService.generateV4();
        await vmService.cleanupVMs();
        await vmService.cloneVM(workingVMName);
        unawaited(vmService.launchVM(workingVMName));
        while (true) {
          final shell = Shell();
          List<ProcessResult>? result;
          try {
            result = await shell.run('tart ip $workingVMName');
          } catch (e) {
            result = null;
          }
          if (result != null) {
            break;
          }
          await Future<void>.delayed(const Duration(seconds: 1));
        }
        _logger.success('VM is ready');
        final vmIP = await vmService.fetchIpAddress(workingVMName);
        await Future<void>.delayed(const Duration(seconds: 10));
        print('vmIP: $vmIP');

        final sshService = sshServiceSignal.value;

        final sshClient = await sshService.sshToServer(vmIP);
        if (sshClient == null) {
          throw Exception('ssh client is null');
        }
        final sshShellService = sshShellServiceSignal.value;
        await sshShellService.executeCommandV2(
            'cd ~/Desktop && touch test.ts', sshClient, workingVMName);

        _logger.success('whole build process completed');

        await vmService.stopVM(workingVMName);
      } catch (e, s) {
        _logger
          ..err('CLI crashed: $e')
          ..err('StackTrace: $s');

        await Sentry.captureException(
          e,
          stackTrace: s,
        );

        await Future<void>.delayed(const Duration(seconds: 2));

        _logger.warn('Restarting the CLI...');
        continue;
      }
    }
    exit(0);
  }
}
