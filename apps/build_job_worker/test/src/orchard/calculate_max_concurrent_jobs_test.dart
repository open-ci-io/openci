import 'package:build_job_worker/build_job_worker.dart';
import 'package:build_job_worker/src/orchard/calculate_max_concurrent_jobs.dart'
    show calculateWorkerCapacity, isWorkerAvailable, readResource;
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 9, 10);
  const resources = <String, dynamic>{
    'org.cirruslabs.tart-vms': 2,
    'org.cirruslabs.logical-cores': 8,
    'org.cirruslabs.memory-mib': 16384,
  };
  final worker = <String, dynamic>{
    'name': 'mac-1',
    'last_seen': now.toIso8601String(),
    'resources': resources,
  };
  int capacity(
    List<Map<String, dynamic>> workers, {
    int cpu = 2,
    int memory = 4,
  }) => calculateMaxConcurrentJobs(
    workers: workers,
    cpuCount: cpu,
    memoryGb: memory,
    now: now,
  );

  group('calculateMaxConcurrentJobs', () {
    test('sums capacity per worker, including an empty cluster', () {
      final workers = [
        worker,
        {...worker, 'name': 'mac-2'},
      ];
      expect(capacity([]), 0);
      expect(capacity(workers), 4);
      expect(capacity(workers, cpu: 5), 2);
    });

    test('excludes unavailable workers and workers without capacity', () {
      expect(
        capacity([
          {...worker, 'scheduling_paused': true},
          {...worker, 'resources': null},
          worker,
        ]),
        2,
      );
    });

    for (final (cpu, memory) in [(0, 4), (-1, 4), (2, 0), (2, -1)]) {
      test('rejects a VM size of $cpu CPUs and $memory GiB', () {
        expect(
          () => capacity([], cpu: cpu, memory: memory),
          throwsArgumentError,
        );
      });
    }
  });

  group('isWorkerAvailable', () {
    test('accepts default and explicit scheduling fields', () {
      expect(isWorkerAvailable(worker, now), isTrue);
      expect(
        isWorkerAvailable({
          ...worker,
          'scheduling_paused': false,
          'runtime': 'tart',
          'arch': 'arm64',
        }, now),
        isTrue,
      );
    });

    for (final (reason, fields) in <(String, Map<String, dynamic>)>[
      ('paused', {'scheduling_paused': true}),
      (
        'offline',
        {
          'last_seen': now
              .subtract(const Duration(minutes: 3, microseconds: 1))
              .toIso8601String(),
        },
      ),
      ('missing heartbeat', {'last_seen': null}),
      ('invalid heartbeat', {'last_seen': 'invalid'}),
      ('incompatible runtime', {'runtime': 'vetu'}),
      ('incompatible architecture', {'arch': 'amd64'}),
    ]) {
      test('rejects a worker with $reason', () {
        expect(isWorkerAvailable({...worker, ...fields}, now), isFalse);
      });
    }

    test('accepts the offline boundary and timestamp offsets', () {
      for (final timestamp in [
        now.subtract(const Duration(minutes: 3)).toIso8601String(),
        '2026-09-10T09:00:00+09:00',
      ]) {
        expect(
          isWorkerAvailable({...worker, 'last_seen': timestamp}, now),
          isTrue,
        );
      }
    });
  });

  group('calculateWorkerCapacity', () {
    for (final (cpu, memory, expected) in [
      (2, 4, 2),
      (5, 4, 1),
      (2, 12, 1),
      (9, 4, 0),
      (2, 17, 0),
    ]) {
      test('fits jobs requesting $cpu CPUs and $memory GiB', () {
        expect(calculateWorkerCapacity(worker, cpu, memory), expected);
      });
    }

    for (final (reason, value) in <(String, Object?)>[
      ('missing', null),
      ('invalid', 'invalid'),
      ('empty', <String, dynamic>{}),
    ]) {
      test('returns zero for $reason resources', () {
        expect(
          calculateWorkerCapacity({...worker, 'resources': value}, 2, 4),
          0,
        );
      });
    }

    for (final name in resources.keys) {
      test('returns zero when $name is missing', () {
        expect(
          calculateWorkerCapacity(
            {
              ...worker,
              'resources': {...resources}..remove(name),
            },
            2,
            4,
          ),
          0,
        );
      });
    }
  });

  group('readResource', () {
    test('reads the requested positive integer', () {
      expect(readResource({'vm': 2, 'cpu': 8}, 'cpu'), 8);
    });

    test('returns zero for a missing resource', () {
      expect(readResource({}, 'cpu'), 0);
    });

    for (final value in <Object?>[null, 0, -1, 2.5, '2', true]) {
      test('returns zero for $value (${value.runtimeType})', () {
        expect(readResource({'cpu': value}, 'cpu'), 0);
      });
    }
  });
}
