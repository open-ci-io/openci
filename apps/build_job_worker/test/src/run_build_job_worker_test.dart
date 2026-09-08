import 'dart:async';

import 'package:build_job_worker/build_job_worker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openci_shared/openci_shared.dart';
import 'package:openci_shared/test_helpers.dart';
import 'package:test/test.dart';

class _MockOpenCiApiService extends Mock implements OpenCiApiService {}

void main() {
  const pollInterval = Duration(milliseconds: 20);
  late OpenCiApiService api;
  late BuildJob firstJob;
  late BuildJob secondJob;
  late List<BuildJob> executed;
  late List<(Object, StackTrace)> errors;
  late Future<BuildJobStatus> Function(BuildJob) executeJob;
  var stopRequested = false;

  Future<void> run({Duration interval = pollInterval}) => runBuildJobWorker(
    api: api,
    executeJob: (job) {
      executed.add(job);
      return executeJob(job);
    },
    shouldStop: () => stopRequested,
    onError: (error, stackTrace) => errors.add((error, stackTrace)),
    pollInterval: interval,
  );

  setUp(() {
    api = _MockOpenCiApiService();
    stopRequested = false;
    executed = [];
    errors = [];
    final now = DateTime.utc(2026, 9, 7);
    firstJob = BuildJob(
      id: 'job-1',
      status: BuildJobStatus.IN_PROGRESS,
      owner: 'acme',
      repo: 'app',
      workflowName: 'CI',
      workflowFileName: 'ci.dart',
      createdAt: now,
      updatedAt: now,
    );
    secondJob = firstJob.copyWith(id: 'job-2');
    executeJob = (_) async {
      stopRequested = true;
      return BuildJobStatus.SUCCESS;
    };
    when(
      () => api.claimNextJob(const {}),
    ).thenAnswer((_) async => createMockResponse({'job': firstJob.toJson()}));
  });

  group('runBuildJobWorker', () {
    test(
      'passes the claimed job to the executor and stops after it finishes',
      () async {
        await run();

        expect(executed, [firstJob]);
        expect(errors, isEmpty);
        verify(() => api.claimNextJob(const {})).called(1);
        verifyNoMoreInteractions(api);
      },
    );

    test('does not claim a job if stopping was already requested', () async {
      stopRequested = true;

      await run();

      expect(executed, isEmpty);
      expect(errors, isEmpty);
      verifyZeroInteractions(api);
    });

    for (final interval in [Duration.zero, const Duration(seconds: -1)]) {
      test('rejects a nonpositive poll interval: $interval', () async {
        await expectLater(run(interval: interval), throwsArgumentError);

        expect(executed, isEmpty);
        verifyZeroInteractions(api);
      });
    }

    test(
      'waits when the queue is empty, then processes the next job',
      () async {
        final emptyResponse = Completer<void>();
        var claims = 0;
        when(() => api.claimNextJob(const {})).thenAnswer((_) async {
          claims++;
          if (claims == 1) {
            emptyResponse.complete();
            return createMockResponse({'job': null});
          }
          return createMockResponse({'job': firstJob.toJson()});
        });

        final worker = run();
        await emptyResponse.future;
        await Future<void>.delayed(Duration.zero);

        expect(claims, 1);
        expect(executed, isEmpty);
        await worker;
        expect(claims, 2);
        expect(executed, [firstJob]);
        expect(errors, isEmpty);
      },
    );

    for (final firstResult in [
      BuildJobStatus.SUCCESS,
      BuildJobStatus.FAILURE,
    ]) {
      test('continues to another job after a $firstResult result', () async {
        var claims = 0;
        when(() => api.claimNextJob(const {})).thenAnswer((_) async {
          final job = claims++ == 0 ? firstJob : secondJob;
          return createMockResponse({'job': job.toJson()});
        });
        executeJob = (job) async {
          if (job.id == firstJob.id) return firstResult;
          stopRequested = true;
          return BuildJobStatus.SUCCESS;
        };

        await run();

        expect(executed, [firstJob, secondJob]);
        expect(claims, 2);
        expect(errors, isEmpty);
      });
    }

    test(
      'does not claim another job until execution and cleanup finish',
      () async {
        final executionStarted = Completer<void>();
        final executionFinished = Completer<void>();
        final cleanupStarted = Completer<void>();
        final cleanupFinished = Completer<void>();
        var claims = 0;
        when(() => api.claimNextJob(const {})).thenAnswer((_) async {
          final job = claims++ == 0 ? firstJob : secondJob;
          return createMockResponse({'job': job.toJson()});
        });
        executeJob = (job) async {
          if (job.id == firstJob.id) {
            executionStarted.complete();
            await executionFinished.future;
            cleanupStarted.complete();
            await cleanupFinished.future;
          } else {
            stopRequested = true;
          }
          return BuildJobStatus.SUCCESS;
        };

        final worker = run();
        await executionStarted.future;

        expect(claims, 1);
        executionFinished.complete();
        await cleanupStarted.future;
        expect(claims, 1);
        expect(executed, [firstJob]);
        cleanupFinished.complete();
        await worker;
        expect(claims, 2);
        expect(executed, [firstJob, secondJob]);
      },
    );

    test('reports an HTTP claim error, waits and continues', () async {
      final failedResponse = Completer<void>();
      var claims = 0;
      when(() => api.claimNextJob(const {})).thenAnswer((_) async {
        claims++;
        if (claims == 1) {
          failedResponse.complete();
          return createMockResponse<Map<String, dynamic>>({}, statusCode: 503);
        }
        return createMockResponse({'job': firstJob.toJson()});
      });

      final worker = run();
      await failedResponse.future;
      await Future<void>.delayed(Duration.zero);

      expect(claims, 1);
      expect(executed, isEmpty);
      expect(errors.single.$1, isA<StateError>());
      expect(errors.single.$1.toString(), contains('HTTP 503'));
      await worker;
      expect(claims, 2);
      expect(executed, [firstJob]);
    });

    test('preserves a thrown claim error and stack while continuing', () async {
      final error = StateError('Connection failed');
      final stack = StackTrace.fromString('Claim failed here');
      var claims = 0;
      when(() => api.claimNextJob(const {})).thenAnswer((_) async {
        if (claims++ == 0) Error.throwWithStackTrace(error, stack);
        return createMockResponse({'job': firstJob.toJson()});
      });

      await run();

      expect(claims, 2);
      expect(executed, [firstJob]);
      expect(errors.single.$1, same(error));
      expect(errors.single.$2.toString(), stack.toString());
    });

    test(
      'reports an executor exception, waits and continues to the next job',
      () async {
        final error = StateError('Executor failed');
        final stack = StackTrace.fromString('Execution failed here');
        final executionStarted = Completer<void>();
        var claims = 0;
        when(() => api.claimNextJob(const {})).thenAnswer((_) async {
          final job = claims++ == 0 ? firstJob : secondJob;
          return createMockResponse({'job': job.toJson()});
        });
        executeJob = (job) async {
          if (job.id == firstJob.id) {
            executionStarted.complete();
            Error.throwWithStackTrace(error, stack);
          }
          stopRequested = true;
          return BuildJobStatus.SUCCESS;
        };

        final worker = run();
        await executionStarted.future;
        await Future<void>.delayed(Duration.zero);

        expect(claims, 1);
        expect(errors.single.$1, same(error));
        expect(errors.single.$2.toString(), stack.toString());
        await worker;
        expect(claims, 2);
        expect(executed, [firstJob, secondJob]);
        expect(errors, hasLength(1));
      },
    );

    test(
      'finishes a job claimed while stopping instead of abandoning it',
      () async {
        final claimStarted = Completer<void>();
        final claimedJob = Completer<BuildJob>();
        final executionStarted = Completer<void>();
        final cleanupFinished = Completer<void>();
        var stopped = false;
        when(() => api.claimNextJob(const {})).thenAnswer((_) async {
          claimStarted.complete();
          final job = await claimedJob.future;
          return createMockResponse({'job': job.toJson()});
        });
        executeJob = (_) async {
          executionStarted.complete();
          await cleanupFinished.future;
          return BuildJobStatus.SUCCESS;
        };

        final worker = run().then((_) => stopped = true);
        await claimStarted.future;
        stopRequested = true;
        claimedJob.complete(firstJob);
        await executionStarted.future;

        expect(executed, [firstJob]);
        expect(stopped, isFalse);
        cleanupFinished.complete();
        await worker;
        expect(stopped, isTrue);
        verify(() => api.claimNextJob(const {})).called(1);
      },
    );

    test(
      'waits for the running job to finish when stopping is requested',
      () async {
        final executionStarted = Completer<void>();
        final cleanupFinished = Completer<void>();
        var stopped = false;
        executeJob = (_) async {
          executionStarted.complete();
          await cleanupFinished.future;
          return BuildJobStatus.SUCCESS;
        };

        final worker = run().then((_) => stopped = true);
        await executionStarted.future;
        stopRequested = true;
        await Future<void>.delayed(Duration.zero);

        expect(stopped, isFalse);
        cleanupFinished.complete();
        await worker;
        expect(stopped, isTrue);
        verify(() => api.claimNextJob(const {})).called(1);
      },
    );

    test(
      'does not claim again if stopping is requested during idle waiting',
      () async {
        final emptyResponse = Completer<void>();
        when(() => api.claimNextJob(const {})).thenAnswer((_) async {
          emptyResponse.complete();
          return createMockResponse({'job': null});
        });

        final worker = run();
        await emptyResponse.future;
        await Future<void>.delayed(Duration.zero);
        stopRequested = true;
        await worker;

        expect(executed, isEmpty);
        verify(() => api.claimNextJob(const {})).called(1);
      },
    );

    test(
      'skips idle waiting when stopping is requested during an empty claim',
      () async {
        when(() => api.claimNextJob(const {})).thenAnswer((_) async {
          stopRequested = true;
          return createMockResponse({'job': null});
        });

        await run(
          interval: const Duration(minutes: 1),
        ).timeout(const Duration(seconds: 1));

        expect(executed, isEmpty);
        verify(() => api.claimNextJob(const {})).called(1);
      },
    );
  });
}
