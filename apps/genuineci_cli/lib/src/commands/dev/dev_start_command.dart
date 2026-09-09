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
    Future<bool> Function(Logger logger, Map<String, String> job);
typedef OrchardWorkerStarter = Future<int> Function(Logger logger);

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
    argParser.addFlag('seed', negatable: false, help: t.dev.start.flags.seed);
    for (final entry in const {
      'seed-repository': 'GitHub repository: owner/repo',
      'seed-sha': 'Full commit SHA to check out',
      'seed-workflow':
          'Dart filename inside genuine_ci/ (e.g. worker_smoke.dart)',
      'seed-installation-id': 'GitHub App installation ID',
      'seed-branch': 'Branch containing the commit',
    }.entries) {
      argParser.addOption(
        entry.key,
        help: '${entry.value} (required with --seed)',
      );
    }
  }

  @override
  Future<int> run() async {
    final shouldSeedLocalData = argResults?['seed'] as bool? ?? false;
    final job = <String, String>{};
    for (final option in argParser.options.keys.where(
      (name) => name.startsWith('seed-'),
    )) {
      final value = argResults?[option] as String?;
      if (shouldSeedLocalData && (value == null || value.trim().isEmpty)) {
        usageException('--$option is required with --seed.');
      }
      if (!shouldSeedLocalData && value != null) {
        usageException('--$option requires --seed.');
      }
      if (value != null) job[option] = value.trim();
    }
    if (shouldSeedLocalData) {
      if (!RegExp(
        r'^[A-Za-z0-9][A-Za-z0-9-]*/[A-Za-z0-9_.-]+$',
      ).hasMatch(job['seed-repository']!)) {
        usageException('--seed-repository must be owner/repo.');
      }
      if (!RegExp(r'^[a-fA-F0-9]{40}$').hasMatch(job['seed-sha']!)) {
        usageException('--seed-sha must be a full 40-character commit SHA.');
      }
      if (!RegExp(
        r'^[A-Za-z0-9_-][A-Za-z0-9_.-]*\.dart$',
      ).hasMatch(job['seed-workflow']!)) {
        usageException(
          '--seed-workflow must be a Dart filename inside genuine_ci/.',
        );
      }
      final installationId = int.tryParse(job['seed-installation-id']!);
      if (!RegExp(r'^[1-9][0-9]*$').hasMatch(job['seed-installation-id']!) ||
          installationId == null ||
          installationId <= 0 ||
          installationId == 12345678) {
        usageException(
          '--seed-installation-id must be a real positive installation ID.',
        );
      }
    }
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

    if (shouldSeedLocalData) {
      final didSeedLocalData = await _localDataSeeder(_logger, {
        'owner': job['seed-repository']!.split('/').first,
        'repo': job['seed-repository']!.split('/').last,
        'commitSha': job['seed-sha']!,
        'workflowFileName': job['seed-workflow']!,
        'workflowName': job['seed-workflow']!,
        'installationId': job['seed-installation-id']!,
        'branch': job['seed-branch']!,
      });
      if (!didSeedLocalData) {
        return 1;
      }
    }

    return _orchardWorkerStarter(_logger);
  }
}
