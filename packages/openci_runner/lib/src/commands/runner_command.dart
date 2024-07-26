import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/models/job/job_model.dart';
import 'package:runner/src/services/process/process_service.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:runner/src/services/supabase/supabase_service.dart';
import 'package:runner/src/services/tart/tart_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';
import 'package:runner/src/services/vm_service.dart';
import 'package:signals_core/signals_core.dart';
import 'package:supabase/supabase.dart';

class AppArgs {
  AppArgs({
    required this.supabaseUrl,
    required this.supabaseAPIKey,
  });
  final String supabaseUrl;
  final String supabaseAPIKey;
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

final shouldExitSignal = signal(false);
final isSearchingSignal = signal(false);
final progressSignal = signal<Progress?>(null);
final workingVMNameSignal = signal(UuidService.generateV4());
final supabaseRowIdSignal = signal<int?>(null);
final sshClientSignal = signal<SSHClient?>(null);

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
      );
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

    processServiceSignal.value.watchKeyboardSignals();
    final vmService = _vmService;
    final sshShellService = sshShellServiceSignal.value;

    while (!shouldExitSignal.value) {
      try {
        final isJobAvailable = await startJobSearch(supabaseClient);
        if (isJobAvailable == false) {
          continue;
        }

        final vmIP = await vmService.startVM();
        await sshServiceSignal.value.sshToServer(vmIP);

        await sshShellService.executeCommandV2('cd ~/Desktop && touch test.ts');
        // await Future<void>.delayed(const Duration(seconds: 10));

        await vmService.stopVM();
        await setCompleted(supabaseClient);
      } catch (e, s) {
        handleException(e, s, _logger);
        await setCompleted(supabaseClient);
        continue;
      }
    }
    exit(0);
  }

  Future<void> setCompleted(SupabaseClient supabase) async {
    await supabase
        .from('jobs')
        .update({'status': 'completed'}).eq('id', supabaseRowIdSignal.value!);
  }

  void handleException(dynamic e, StackTrace s, Logger logger) async {
    logger
      ..err('CLI crashed: $e')
      ..err('StackTrace: $s');

    await Future<void>.delayed(const Duration(seconds: 2));

    logger.warn('Restarting the CLI...');
  }

  VMService get _vmService {
    final localShellService = LocalShellService();
    final tartService = TartService(localShellService);
    return VMService(tartService);
  }

  Future<bool> startJobSearch(SupabaseClient supabaseClient) async {
    if (!isSearchingSignal.value) {
      _logger.info('Starting job search');
      progressSignal.value = _logger.progress('Searching for new job');
      isSearchingSignal.value = true;
    }

    final data = await supabaseClient
        .from('jobs')
        .update({'status': 'processing'})
        .eq('status', 'queued')
        .order('created_at', ascending: true)
        .limit(1)
        .select();

    if (data.isEmpty && progressSignal.value != null) {
      progressSignal.value
          ?.update('No jobs were found, retrying in 10 seconds');

      await Future<void>.delayed(const Duration(seconds: 10));
      return false;
    }
    supabaseRowIdSignal.value = data.first['id'] as int;
    final job = JobModel.fromJson(data.first);
    progressSignal.value?.complete('New job found: $job');
    isSearchingSignal.value = false;
    return true;
  }
}
