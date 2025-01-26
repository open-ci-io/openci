import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:openci_runner/src/run_app.dart';

const pollingInterval = Duration(seconds: 5);

class RunnerCommand extends Command<int> {
  RunnerCommand() {
    argParser
      ..addOption(
        'pem-path',
        abbr: 'p',
        help: 'GitHub App Private Key (pem) Path',
        mandatory: true,
      )
      ..addOption(
        'service-account-path',
        abbr: 's',
        help: 'Firebase Service Account Json Path',
        mandatory: true,
      )
      ..addOption(
        'sentry-dsn',
        abbr: 'd',
        help: 'Sentry DSN',
      );
  }

  @override
  String get description => 'OpenCI Runner command';

  @override
  String get name => 'runner';

  @override
  Future<int> run() async {
    final pemPath = argResults?['pem-path'] as String;
    final pem = File(pemPath).readAsStringSync();
    final serviceAccountPath = argResults?['service-account-path'] as String;
    final sentryDsn = argResults?['sentry-dsn'] as String?;

    await runApp(
      serviceAccountPath: serviceAccountPath,
      pem: pem,
      sentryDsn: sentryDsn,
    );
    return 0;
  }
}
