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
  var capacity = 0;
  for (final worker in workers) {
    if (!_isWorkerAvailable(worker, now)) continue;
    capacity += _calculateWorkerCapacity(worker, cpuCount, memoryGb);
  }
  return capacity;
}

bool _isWorkerAvailable(Map<String, dynamic> worker, DateTime now) {
  if ((worker['scheduling_paused'] as bool? ?? false) ||
      (worker['runtime'] as String? ?? 'tart') != 'tart' ||
      (worker['arch'] as String? ?? 'arm64') != 'arm64') {
    return false;
  }
  // Matches Orchard Controller's default workerOfflineTimeout.
  final cutoff = now.subtract(const Duration(minutes: 3));
  final lastSeen = DateTime.tryParse(worker['last_seen'] as String? ?? '');
  return lastSeen != null && !lastSeen.isBefore(cutoff);
}

int _calculateWorkerCapacity(
  Map<String, dynamic> worker,
  int cpuCount,
  int memoryGb,
) {
  final resources = worker['resources'];
  if (resources is! Map<String, dynamic>) return 0;

  final vmSlots = _readResource(resources, 'org.cirruslabs.tart-vms');
  final cpuSlots =
      _readResource(resources, 'org.cirruslabs.logical-cores') ~/ cpuCount;
  final memorySlots =
      _readResource(resources, 'org.cirruslabs.memory-mib') ~/
      (memoryGb * 1024);
  return min(vmSlots, min(cpuSlots, memorySlots));
}

int _readResource(Map<String, dynamic> resources, String name) {
  final value = resources[name];
  return value is int && value > 0 ? value : 0;
}
