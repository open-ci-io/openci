import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:meta/meta.dart';

import '../../i18n/i18n.dart';
import 'check_tart_base_image.dart';
import 'find_project_root.dart';
import 'seed_local_data.dart';
import 'setup_orchard_context.dart';
import 'start_docker_compose.dart';
import 'start_orchard_worker.dart';

typedef ProjectRootFinder = Directory? Function();
typedef TartBaseImageChecker = Future<bool> Function(Logger logger);
typedef DockerComposeStarter =
    Future<bool> Function(Logger logger, Directory projectRoot);
typedef OrchardContextSetup = Future<bool> Function(Logger logger);
typedef LocalDataSeeder =
    Future<bool> Function(Logger logger, {required SeedJobOptions job});
typedef OrchardWorkerStarter = Future<int> Function(Logger logger);

const _seedOptions = [
  'repo',
  'commit-sha',
  'workflow',
  'installation-id',
  'branch',
];

class DevStartCommand extends Command<int> {
  @override
  final String name = 'start';

  @override
  String get description => t.dev.start.description;

  final Logger _logger;
  final ProjectRootFinder _projectRootFinder;
  final TartBaseImageChecker _tartBaseImageChecker;
  final DockerComposeStarter _dockerComposeStarter;
  final OrchardContextSetup _orchardContextSetup;
  final LocalDataSeeder _localDataSeeder;
  final OrchardWorkerStarter _orchardWorkerStarter;

  DevStartCommand({
    required Logger logger,
    @visibleForTesting ProjectRootFinder projectRootFinder = findProjectRoot,
    @visibleForTesting
    TartBaseImageChecker tartBaseImageChecker = checkTartBaseImage,
    @visibleForTesting
    DockerComposeStarter dockerComposeStarter = startDockerCompose,
    @visibleForTesting
    OrchardContextSetup orchardContextSetup = setupOrchardContext,
    @visibleForTesting LocalDataSeeder localDataSeeder = seedLocalData,
    @visibleForTesting
    OrchardWorkerStarter orchardWorkerStarter = startOrchardWorker,
  }) : _logger = logger,
       _projectRootFinder = projectRootFinder,
       _tartBaseImageChecker = tartBaseImageChecker,
       _dockerComposeStarter = dockerComposeStarter,
       _orchardContextSetup = orchardContextSetup,
       _localDataSeeder = localDataSeeder,
       _orchardWorkerStarter = orchardWorkerStarter {
    argParser
      ..addFlag('seed', negatable: false, help: t.dev.start.flags.seed)
      ..addOption('repo', help: t.dev.start.flags.repo, valueHelp: 'OWNER/REPO')
      ..addOption(
        'commit-sha',
        help: t.dev.start.flags.commitSha,
        valueHelp: 'SHA',
      )
      ..addOption(
        'workflow',
        help: t.dev.start.flags.workflow,
        valueHelp: 'FILE.dart',
      )
      ..addOption('installation-id', help: t.dev.start.flags.installationId)
      ..addOption('branch', help: t.dev.start.flags.branch, defaultsTo: 'main');
  }

  @override
  Future<int> run() async {
    final seedJob = _parseSeedJob();
    _logger.stdout(t.dev.start.starting);

    final projectRoot = _projectRootFinder();
    if (projectRoot == null) {
      _logger.stderr(t.dev.start.projectRootNotFound);
      return 1;
    }

    final hasTartImage = await _tartBaseImageChecker(_logger);
    if (!hasTartImage) {
      return 1;
    }

    final didStartDockerCompose = await _dockerComposeStarter(
      _logger,
      projectRoot,
    );
    if (!didStartDockerCompose) {
      return 1;
    }

    final didSetupOrchardContext = await _orchardContextSetup(_logger);
    if (!didSetupOrchardContext) {
      return 1;
    }

    if (seedJob != null) {
      final didSeedLocalData = await _localDataSeeder(_logger, job: seedJob);
      if (!didSeedLocalData) {
        return 1;
      }
    }

    return _orchardWorkerStarter(_logger);
  }

  SeedJobOptions? _parseSeedJob() {
    final results = argResults;
    if (results == null) return null;
    if (!results.flag('seed')) {
      if (_seedOptions.any(results.wasParsed)) {
        usageException(t.dev.start.seedOptionsRequireSeed);
      }
      return null;
    }

    String readOption(String name, bool Function(String) isValid) {
      final value = results.option(name)?.trim() ?? '';
      if (!isValid(value)) {
        usageException(t.dev.start.invalidSeedOption(option: name));
      }
      return value;
    }

    final repository = readOption(
      'repo',
      (value) => RegExp(r'^[A-Za-z0-9-]+/[A-Za-z0-9_.-]+$').hasMatch(value),
    ).split('/');
    final commitSha = readOption(
      'commit-sha',
      (value) => RegExp(r'^[a-fA-F0-9]{40}$').hasMatch(value),
    );
    final workflow = readOption(
      'workflow',
      (value) =>
          value.endsWith('.dart') &&
          !value.startsWith('/') &&
          !value.startsWith('genuine_ci/') &&
          !value.split('/').contains('..') &&
          !RegExp(r'[\x00-\x1f\\]').hasMatch(value),
    );
    final installationId = readOption(
      'installation-id',
      (value) =>
          RegExp(r'^[1-9][0-9]*$').hasMatch(value) &&
          int.tryParse(value) != null &&
          value != '12345678',
    );
    final branch = readOption(
      'branch',
      (value) => value.isNotEmpty && !RegExp(r'\s').hasMatch(value),
    );
    return (
      owner: repository[0],
      repo: repository[1],
      commitSha: commitSha,
      workflowFileName: workflow,
      installationId: installationId,
      branch: branch,
    );
  }
}
