import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:meta/meta.dart';

import '../../i18n/i18n.dart';
import 'setup_orchard_context.dart';

typedef OrchardWorkerProcessStarter =
    Future<Process> Function(
      String executable,
      List<String> arguments, {
      required ProcessStartMode mode,
    });

Future<int> startOrchardWorker(
  Logger logger, {
  @visibleForTesting OrchardProcessRunner processRunner = Process.run,
  @visibleForTesting OrchardWorkerProcessStarter processStarter = Process.start,
  @visibleForTesting Stream<ProcessSignal>? interruptSignals,
  @visibleForTesting Stream<ProcessSignal>? terminateSignals,
}) async {
  try {
    final tokenResult = await processRunner('orchard', [
      'get',
      'bootstrap-token',
      'bootstrap-admin',
    ]);
    final token = tokenResult.stdout.toString().trim();
    if (tokenResult.exitCode != 0 || token.isEmpty) {
      logger.stderr(t.dev.start.stepOrchardWorkerFailed);
      return 1;
    }

    logger.stdout('\n${t.dev.start.stepOrchardWorker}');
    final process = await processStarter('orchard', [
      'worker',
      'run',
      'https://127.0.0.1:6120',
      '--bootstrap-token',
      token,
      '--no-pki',
    ], mode: ProcessStartMode.inheritStdio);

    ProcessSignal? stopSignal;
    void stop(ProcessSignal signal) {
      stopSignal ??= signal;
      // Orchard handles SIGINT by shutting down its worker.
      process.kill(ProcessSignal.sigint);
    }

    final interruptSubscription =
        (interruptSignals ?? ProcessSignal.sigint.watch()).listen(stop);
    final terminateSubscription =
        (terminateSignals ?? ProcessSignal.sigterm.watch()).listen(stop);
    try {
      final exitCode = await process.exitCode;
      if (stopSignal != null) {
        return 128 + stopSignal!.signalNumber;
      }
      if (exitCode != 0) {
        logger.stderr(t.dev.start.stepOrchardWorkerFailed);
      }
      return exitCode < 0 ? 128 - exitCode : exitCode;
    } finally {
      await interruptSubscription.cancel();
      await terminateSubscription.cancel();
    }
  } on ProcessException catch (error) {
    logger.stderr('${t.dev.start.stepOrchardWorkerFailed}\n${error.message}');
    return 1;
  }
}
