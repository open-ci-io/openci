import 'dart:math';

import 'package:meta/meta.dart';

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
    if (!isWorkerAvailable(worker, now)) continue;
    capacity += calculateWorkerCapacity(worker, cpuCount, memoryGb);
  }
  return capacity;
}

@visibleForTesting
bool isWorkerAvailable(Map<String, dynamic> worker, DateTime now) {
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

@visibleForTesting
int calculateWorkerCapacity(
  Map<String, dynamic> worker,
  int cpuCount,
  int memoryGb,
) {
  final resources = worker['resources'];
  if (resources is! Map<String, dynamic>) return 0;

  final vmSlots = readResource(resources, 'org.cirruslabs.tart-vms');
  final cpuSlots =
      readResource(resources, 'org.cirruslabs.logical-cores') ~/ cpuCount;
  final memorySlots =
      readResource(resources, 'org.cirruslabs.memory-mib') ~/ (memoryGb * 1024);
  return min(vmSlots, min(cpuSlots, memorySlots));
}

@visibleForTesting
int readResource(Map<String, dynamic> resources, String name) {
  final value = resources[name];
  return value is int && value > 0 ? value : 0;
}
