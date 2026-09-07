import 'dart:convert';

import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

void main() {
  group('ClaimJobRequest JSON', () {
    test('accepts a claim without worker metadata or a concurrency limit', () {
      final request = ClaimJobRequest.fromJson({});

      expect(request.vmName, isNull);
      expect(request.workerHost, isNull);
      expect(request.maxConcurrentJobs, isNull);
    });

    test('preserves worker metadata and the integer concurrency limit', () {
      const request = ClaimJobRequest(
        vmName: 'vm-1',
        workerHost: 'worker-1',
        maxConcurrentJobs: 2,
      );
      final encoded = jsonDecode(jsonEncode(request)) as Map<String, dynamic>;

      expect(encoded, {
        'vmName': 'vm-1',
        'workerHost': 'worker-1',
        'maxConcurrentJobs': 2,
      });
      expect(ClaimJobRequest.fromJson(encoded), request);
    });
  });
}
