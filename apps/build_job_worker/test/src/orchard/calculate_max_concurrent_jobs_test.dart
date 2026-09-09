import 'package:build_job_worker/build_job_worker.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 9, 10);
  final worker = <String, dynamic>{
    'name': 'mac-1',
    'last_seen': now.toIso8601String(),
    'resources': {
      'org.cirruslabs.tart-vms': 2,
      'org.cirruslabs.logical-cores': 8,
      'org.cirruslabs.memory-mib': 16384,
    },
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

    for (final (cpu, memory, expected) in [
      (2, 4, 2),
      (5, 4, 1),
      (2, 12, 1),
      (9, 4, 0),
      (2, 17, 0),
    ]) {
      test('fits jobs requesting $cpu CPUs and $memory GiB', () {
        expect(capacity([worker], cpu: cpu, memory: memory), expected);
      });
    }

    for (final (reason, fields) in <(String, Map<String, dynamic>)>[
      ('paused', {'scheduling_paused': true}),
      (
        'offline',
        {
          'last_seen': now
              .subtract(const Duration(minutes: 3, seconds: 1))
              .toIso8601String(),
        },
      ),
      ('missing heartbeat', {'last_seen': null}),
      ('invalid heartbeat', {'last_seen': 'invalid'}),
      ('incompatible runtime', {'runtime': 'vetu'}),
      ('incompatible architecture', {'arch': 'amd64'}),
      ('missing resources', {'resources': null}),
      ('empty resources', {'resources': <String, dynamic>{}}),
      (
        'invalid resources',
        {
          'resources': {'org.cirruslabs.tart-vms': '2'},
        },
      ),
      (
        'negative resources',
        {
          'resources': {'org.cirruslabs.tart-vms': -1},
        },
      ),
    ]) {
      test('ignores a worker with $reason', () {
        expect(
          capacity([
            {...worker, ...fields},
            worker,
          ]),
          2,
        );
      });
    }

    test('accepts the offline boundary and timestamp offsets', () {
      for (final timestamp in [
        now.subtract(const Duration(minutes: 3)).toIso8601String(),
        '2026-09-10T09:00:00+09:00',
      ]) {
        expect(
          capacity([
            {...worker, 'last_seen': timestamp},
          ]),
          2,
        );
      }
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
}
