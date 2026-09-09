import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:genuineci_cli/src/commands/dev/dev_start_command.dart';
import 'package:genuineci_cli/src/i18n/i18n.dart';
import 'package:test/test.dart';

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

const seedArgs = [
  '--seed',
  '--seed-repository=example/project',
  '--seed-sha=0123456789012345678901234567890123456789',
  '--seed-workflow=smoke.dart',
  '--seed-installation-id=42',
  '--seed-branch=develop',
];

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
    required void Function() onSeed,
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
          localDataSeeder: (_, job) async {
            expect(job, {
              'owner': 'example',
              'repo': 'project',
              'commitSha': '0123456789012345678901234567890123456789',
              'workflowFileName': 'smoke.dart',
              'workflowName': 'smoke.dart',
              'installationId': '42',
              'branch': 'develop',
            });
            onSeed();
            return seedSucceeds;
          },
          orchardWorkerStarter: orchardWorkerStarter ?? (_) async => 0,
        ),
      );

    return runner.run(['start', if (shouldSeed) ...seedArgs]);
  }

  for (final args in [
    ['--seed'],
    for (var i = 1; i < seedArgs.length; i++)
      [...seedArgs.take(i), ...seedArgs.skip(i + 1)],
    ['--seed-repository=example/project'],
    for (final invalid in [
      '--seed-repository=invalid',
      '--seed-repository=../project',
      '--seed-sha=main',
      '--seed-workflow=../smoke.dart',
      '--seed-workflow=ci.yml',
      '--seed-installation-id=0',
      '--seed-installation-id=abc',
      '--seed-installation-id=0x2a',
      '--seed-installation-id=-1',
      '--seed-installation-id=999999999999999999999999',
      '--seed-installation-id=12345678',
      '--seed-branch= ',
    ])
      [
        ...seedArgs.where(
          (arg) => arg.split('=').first != invalid.split('=').first,
        ),
        invalid,
      ],
  ]) {
    test('rejects invalid seed arguments before setup: $args', () async {
      final runner = CommandRunner<int>('genuineci', 'CLI')
        ..addCommand(
          DevStartCommand(
            logger: _RecordingLogger(),
            projectRootFinder: () => fail('Must validate before setup'),
          ),
        );
      await expectLater(
        runner.run(['start', ...args]),
        throwsA(isA<UsageException>()),
      );
    });
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
      onSeed: () => seedCallCount++,
    );

    expect(result, equals(0));
    expect(seedCallCount, equals(0));
  });

  test('seeds local data when --seed is specified', () async {
    var seedCallCount = 0;

    final result = await runStart(
      shouldSeed: true,
      seedSucceeds: true,
      onSeed: () => seedCallCount++,
    );

    expect(result, equals(0));
    expect(seedCallCount, equals(1));
  });

  test('returns 1 when seeding local data fails', () async {
    var seedCallCount = 0;

    final result = await runStart(
      shouldSeed: true,
      seedSucceeds: false,
      onSeed: () => seedCallCount++,
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
            localDataSeeder: (_, _) async => recordStep('seed'),
            orchardWorkerStarter: (workerLogger) async {
              expect(workerLogger, same(logger));
              calls.add('worker');
              return 17;
            },
          ),
        );

      expect(await runner.run(['start', if (shouldSeed) ...seedArgs]), 17);
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
}
