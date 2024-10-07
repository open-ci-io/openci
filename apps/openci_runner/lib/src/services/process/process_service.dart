import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/commands/signals.dart';
import 'package:runner/src/services/logger/logger_service.dart';
import 'package:signals_core/signals_core.dart';

final processServiceSignal = signal(ProcessService());

class ProcessService {
  Logger get _logger => loggerSignal.value;

  void _watchSIGTERM() {
    ProcessSignal.sigterm.watch().listen((signal) {
      _logger.warn('Received SIGTERM. Terminating the CLI...');
    });
  }

  void _watchSIGINT() {
    ProcessSignal.sigint.watch().listen((signal) {
      _logger.warn('Received SIGINT. Terminating the CLI...');
      shouldExitSignal.value = true;
      exit(0);
    });
  }

  void watchKeyboardSignals() {
    _watchSIGTERM();
    _watchSIGINT();
  }
}
