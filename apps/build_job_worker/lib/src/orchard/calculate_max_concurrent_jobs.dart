import 'dart:math';

/// Total job capacity; currently running jobs must be counted by the caller.
int calculateMaxConcurrentJobs({
  required List<Map<String, dynamic>> workers,
  required int cpuCount,
  required int memoryGb,
  required DateTime now,
}) {
  if (cpuCount <= 0 || memoryGb <= 0) {
    throw ArgumentError('VM CPU and memory must be positive.');
  }
  // Matches Orchard Controller's default workerOfflineTimeout.
  final cutoff = now.subtract(const Duration(minutes: 3));
  var capacity = 0;
  for (final worker in workers) {
    if ((worker['scheduling_paused'] as bool? ?? false) ||
        (worker['runtime'] as String? ?? 'tart') != 'tart' ||
        (worker['arch'] as String? ?? 'arm64') != 'arm64') {
      continue;
    }
    final lastSeen = DateTime.tryParse(worker['last_seen'] as String? ?? '');
    if (lastSeen == null || lastSeen.isBefore(cutoff)) continue;
    final resources = worker['resources'];
    if (resources is! Map<String, dynamic>) continue;

    int resource(String name) {
      final value = resources[name];
      return value is int && value > 0 ? value : 0;
    }

    capacity += min(
      resource('org.cirruslabs.tart-vms'),
      min(
        resource('org.cirruslabs.logical-cores') ~/ cpuCount,
        resource('org.cirruslabs.memory-mib') ~/ (memoryGb * 1024),
      ),
    );
  }
  return capacity;
}
