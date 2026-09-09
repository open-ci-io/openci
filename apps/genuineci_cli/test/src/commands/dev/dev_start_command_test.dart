import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:genuineci_cli/src/commands/dev/dev_start_command.dart';
import 'package:genuineci_cli/src/commands/dev/seed_local_data.dart';
import 'package:genuineci_cli/src/i18n/i18n.dart';
import 'package:test/test.dart';

const _seedArguments = [
  '--seed',
  '--repo=example/mobile',
  '--commit-sha=0123456789abcdef0123456789abcdef01234567',
  '--workflow=worker_smoke.dart',
  '--installation-id=42',
];

class _RecordingLogger implements Logger {
  final stdoutMessages = <String>[];
  final stderrMessages = <String>[];

  @override
  void stdout(String message) => stdoutMessages.add(message);

  @override
  void stderr(String message) => stderrMessages.add(message);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Directory originalDirectory;
  late Directory tempDirectory;

  setUp(() async {
    originalDirectory = Directory.current;
    tempDirectory = await Directory.systemTemp.createTemp(
      'dev_start_command_test_',
    );
    Directory.current = tempDirectory;
  });

  tearDown(() async {
    Directory.current = originalDirectory;
    await tempDirectory.delete(recursive: true);
  });

  Future<int?> runStart({
    required bool shouldSeed,
    required bool seedSucceeds,
    required void Function(SeedJobOptions job) onSeed,
    OrchardWorkerStarter? orchardWorkerStarter,
  }) {
    final runner = CommandRunner<int>('genuineci', 'CLI tool')
      ..addCommand(
        DevStartCommand(
          logger: _RecordingLogger(),
          projectRootFinder: () => tempDirectory,
          tartBaseImageChecker: (_) async => true,
          dockerComposeStarter: (_, _) async => true,
          orchardContextSetup: (_) async => true,
          localDataSeeder: (_, {required job}) async {
            onSeed(job);
            return seedSucceeds;
          },
          orchardWorkerStarter: orchardWorkerStarter ?? (_) async => 0,
        ),
      );

    return runner.run(['start', if (shouldSeed) ..._seedArguments]);
  }

  test('reports projectRootNotFound before checking Tart', () async {
    final logger = _RecordingLogger();

    final result = await DevStartCommand(logger: logger).run();

    expect(result, equals(1));
    expect(logger.stdoutMessages, equals([t.dev.start.starting]));
    expect(logger.stderrMessages, equals([t.dev.start.projectRootNotFound]));
  });

  test('seed flag is opt-in', () {
    final command = DevStartCommand(logger: _RecordingLogger());

    expect(command.argParser.parse([]).flag('seed'), isFalse);
    expect(command.argParser.parse(['--seed']).flag('seed'), isTrue);
    expect(command.argParser.usage, contains(t.dev.start.flags.seed));
  });

  test('does not seed local data when --seed is omitted', () async {
    var seedCallCount = 0;

    final result = await runStart(
      shouldSeed: false,
      seedSucceeds: true,
      onSeed: (_) => seedCallCount++,
    );

    expect(result, equals(0));
    expect(seedCallCount, equals(0));
  });

  test('seeds local data when --seed is specified', () async {
    final seededJobs = <SeedJobOptions>[];

    final result = await runStart(
      shouldSeed: true,
      seedSucceeds: true,
      onSeed: seededJobs.add,
    );

    expect(result, equals(0));
    expect(seededJobs, [
      (
        owner: 'example',
        repo: 'mobile',
        commitSha: '0123456789abcdef0123456789abcdef01234567',
        workflowFileName: 'worker_smoke.dart',
        installationId: '42',
        branch: 'main',
      ),
    ]);
  });

  test('returns 1 when seeding local data fails', () async {
    var seedCallCount = 0;

    final result = await runStart(
      shouldSeed: true,
      seedSucceeds: false,
      onSeed: (_) => seedCallCount++,
      orchardWorkerStarter: (_) async => fail('Worker must not start'),
    );

    expect(result, equals(1));
    expect(seedCallCount, equals(1));
  });

  for (final shouldSeed in [false, true]) {
    test('runs the worker after setup with seed=$shouldSeed', () async {
      final calls = <String>[];
      bool recordStep(String step) {
        calls.add(step);
        return true;
      }

      final logger = _RecordingLogger();
      final runner = CommandRunner<int>('genuineci', 'CLI tool')
        ..addCommand(
          DevStartCommand(
            logger: logger,
            projectRootFinder: () => tempDirectory,
            tartBaseImageChecker: (_) async => recordStep('tart'),
            dockerComposeStarter: (_, _) async => recordStep('compose'),
            orchardContextSetup: (_) async => recordStep('context'),
            localDataSeeder: (_, {required job}) async => recordStep('seed'),
            orchardWorkerStarter: (workerLogger) async {
              expect(workerLogger, same(logger));
              calls.add('worker');
              return 17;
            },
          ),
        );

      expect(
        await runner.run(['start', if (shouldSeed) ..._seedArguments]),
        17,
      );
      expect(calls, [
        'tart',
        'compose',
        'context',
        if (shouldSeed) 'seed',
        'worker',
      ]);
    });
  }

  for (final failingStep in ['tart', 'compose', 'context']) {
    test('does not start the worker when $failingStep fails', () async {
      final result = await DevStartCommand(
        logger: _RecordingLogger(),
        projectRootFinder: () => tempDirectory,
        tartBaseImageChecker: (_) async => failingStep != 'tart',
        dockerComposeStarter: (_, _) async => failingStep != 'compose',
        orchardContextSetup: (_) async => failingStep != 'context',
        orchardWorkerStarter: (_) async => fail('Worker must not start'),
      ).run();

      expect(result, 1);
    });
  }

  test('passes a nested workflow and explicit branch to the seeder', () async {
    SeedJobOptions? seededJob;
    final runner = CommandRunner<int>('genuineci', 'CLI tool')
      ..addCommand(
        DevStartCommand(
          logger: _RecordingLogger(),
          projectRootFinder: () => tempDirectory,
          tartBaseImageChecker: (_) async => true,
          dockerComposeStarter: (_, _) async => true,
          orchardContextSetup: (_) async => true,
          localDataSeeder: (_, {required job}) async {
            seededJob = job;
            return true;
          },
          orchardWorkerStarter: (_) async => 0,
        ),
      );

    expect(
      await runner.run([
        'start',
        ..._seedArguments.where((arg) => !arg.startsWith('--workflow=')),
        '--workflow= checks/smoke.dart ',
        '--branch=feature/worker',
      ]),
      0,
    );
    expect(seededJob!.workflowFileName, 'checks/smoke.dart');
    expect(seededJob!.branch, 'feature/worker');
  });

  Future<int?> runInvalidStart(List<String> arguments) {
    final runner = CommandRunner<int>('genuineci', 'CLI tool')
      ..addCommand(
        DevStartCommand(
          logger: _RecordingLogger(),
          projectRootFinder: () => fail('Setup must not start'),
        ),
      );
    return runner.run(['start', ...arguments]);
  }

  for (final option in ['repo', 'commit-sha', 'workflow', 'installation-id']) {
    test('requires --$option before starting services', () async {
      await expectLater(
        runInvalidStart([
          ..._seedArguments.where((arg) => !arg.startsWith('--$option=')),
        ]),
        throwsA(
          isA<UsageException>().having(
            (error) => error.message,
            'message',
            t.dev.start.invalidSeedOption(option: option),
          ),
        ),
      );
    });
  }

  for (final entry in {
    'repo': ['', 'openci', 'owner/repo/extra', 'https://github.com/owner/repo'],
    'commit-sha': ['main', 'abc123', 'g' * 40],
    'workflow': [
      'ci.yml',
      '/tmp/ci.dart',
      '../ci.dart',
      'nested/../../ci.dart',
      'genuine_ci/ci.dart',
      r'..\ci.dart',
      'ci\u0000.dart',
    ],
    'installation-id': ['0', '-1', 'abc', '12345678', '9' * 30],
    'branch': ['', 'two branches'],
  }.entries) {
    for (var i = 0; i < entry.value.length; i++) {
      test('rejects invalid --${entry.key} case $i before setup', () async {
        await expectLater(
          runInvalidStart([
            ..._seedArguments.where(
              (arg) => !arg.startsWith('--${entry.key}='),
            ),
            '--${entry.key}=${entry.value[i]}',
          ]),
          throwsA(
            isA<UsageException>().having(
              (error) => error.message,
              'message',
              t.dev.start.invalidSeedOption(option: entry.key),
            ),
          ),
        );
      });
    }
  }

  for (final argument in [..._seedArguments.skip(1), '--branch=develop']) {
    test('rejects $argument without --seed before setup', () async {
      await expectLater(
        runInvalidStart([argument]),
        throwsA(
          isA<UsageException>().having(
            (error) => error.message,
            'message',
            t.dev.start.seedOptionsRequireSeed,
          ),
        ),
      );
    });
  }
}
