import 'dart:async';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/features/build_job/find_job.dart';
import 'package:runner/src/features/command_args/initialize_args.dart';
import 'package:runner/src/services/logger/logger_service.dart';
import 'package:runner/src/services/process/process_service.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:runner/src/services/supabase/supabase_service.dart';
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

class RunnerCommand extends Command<int> {
  RunnerCommand() {
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

  @override
  Future<int> run() async {
    final appArgs = await initializeApp(argResults);

    final supabaseClient = await supabaseServiceSignal.value.initSupabase(
      url: appArgs.supabaseUrl,
      key: appArgs.supabaseAPIKey,
    );

    processServiceSignal.value.watchKeyboardSignals();

    while (!shouldExitSignal.value) {
      await Future<void>.delayed(const Duration(seconds: 1));
      final job = await findJob(supabaseClient);
      if (job == null) {
        loggerSignal.value.info('No job found');
        continue;
      }
      final vmIp = await vmServiceSignal.value.startVM();
      await sshServiceSignal.value.sshToServer(vmIp);
      await sshSignal.executeCommandV2(
        'ls',
      );
      await Future<void>.delayed(const Duration(seconds: 10));

      await vmServiceSignal.value.cleanupVMs();
    }

    exit(0);
  }
}
