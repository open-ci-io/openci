import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:meta/meta.dart';

import '../../i18n/i18n.dart';

typedef DockerComposeProcessRunner =
    Future<int> Function(
      String executable,
      List<String> arguments, {
      required String workingDirectory,
      required Map<String, String> environment,
    });

const _dockerComposeArguments = [
  'compose',
  'up',
  '-d',
  '--build',
  'server',
  'build-job-planner',
  'build-job-worker',
  'loki',
];

Future<bool> startDockerCompose(
  Logger logger,
  Directory projectRoot, {
  @visibleForTesting
  DockerComposeProcessRunner processRunner = _runDockerComposeProcess,
  @visibleForTesting Map<String, String>? environment,
}) async {
  logger.stdout('\n${t.dev.start.stepDockerCompose}');

  final composeEnvironment = environment ?? Platform.environment;

  try {
    final exitCode = await processRunner(
      'docker',
      _dockerComposeArguments,
      workingDirectory: projectRoot.path,
      environment: composeEnvironment,
    );
    if (exitCode != 0) {
      logger.stderr(t.dev.start.stepDockerComposeFailed);
      return false;
    }
  } on ProcessException catch (error) {
    logger.stderr('${t.dev.start.stepDockerComposeFailed}\n${error.message}');
    return false;
  }

  logger.stdout(t.dev.start.stepDockerComposeStarted);
  return true;
}

Future<int> _runDockerComposeProcess(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
  required Map<String, String> environment,
}) async {
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
    includeParentEnvironment: false,
    mode: ProcessStartMode.inheritStdio,
  );
  return process.exitCode;
}
