import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/models/build_job/build_job.dart';
import 'package:runner/src/services/process/process_service.dart';
import 'package:runner/src/services/supabase/supabase_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';
import 'package:signals_core/signals_core.dart';
import 'package:supabase/supabase.dart';

Future<String> execCommand(
  SSHClient client,
  String command, {
  String? input,
}) async {
  final result = await client.execute(command);

  if (input != null) {
    result.stdin.add(utf8.encode(input));
    await result.stdin.close();
  }

  final output = await result.stdout.transform(utf8Decoder).join();
  final error = await result.stderr.transform(utf8Decoder).join();
  if (error.isNotEmpty) {
    throw Exception('Command failed: $command (Exit code: ${result.exitCode})');
  }

  if (result.exitCode != 0) {
    throw Exception('Command failed: $command (Exit code: ${result.exitCode})');
  }

  return output;
}

final utf8Decoder = StreamTransformer<Uint8List, String>.fromHandlers(
  handleData: (data, sink) {
    sink.add(utf8.decode(data));
  },
);

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

final isDebugSignal = signal(false);

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
    _logger.success('Argument check passed.');

    final supabaseClient = await supabaseServiceSignal.value.initSupabase(
      url: appArgs.supabaseUrl,
      key: appArgs.supabaseAPIKey,
    );

    processServiceSignal.value.watchKeyboardSignals();

    while (!shouldExitSignal.value) {
      await Future<void>.delayed(const Duration(seconds: 1));
      await findJob(supabaseClient, _logger);
      // if (!isJobAvailable) {
      //   continue;
      // }
    }

    exit(0);
  }
}

Future<void> findJob(SupabaseClient supabaseClient, Logger logger) async {
  final data = await supabaseClient.from('build_jobs').select();
  data.map(BuildJob.fromJson).toList();
}

Future<void> setCompleted(SupabaseClient supabase) async {
  await supabase
      .from('jobs')
      .update({'status': 'completed'}).eq('id', supabaseRowIdSignal.value!);
}

Future<void> handleException(dynamic e, StackTrace s, Logger logger) async {
  logger
    ..err('CLI crashed: $e')
    ..err('StackTrace: $s');

  await Future<void>.delayed(const Duration(seconds: 2));

  logger.warn('Restarting the CLI...');
}

enum JobStatus {
  waiting,
  processing,
  success,
  failure,
}
