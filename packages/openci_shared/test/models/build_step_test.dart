import 'dart:convert';

import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

void main() {
  test('BuildStep preserves the run, order, and duration in milliseconds', () {
    final json = {
      'id': 'step-1',
      'runId': 'run-1',
      'name': 'Run tests',
      'status': 'SUCCESS',
      'durationMs': 1501,
      'stepOrder': 0,
      'createdAt': '2026-09-07T00:00:00.000Z',
      'updatedAt': '2026-09-07T00:00:01.501Z',
    };

    final step = BuildStep.fromJson(json);

    expect(step.id, 'step-1');
    expect(step.runId, 'run-1');
    expect(step.name, 'Run tests');
    expect(step.status, BuildJobStatus.SUCCESS);
    expect(step.durationMs, 1501);
    expect(step.stepOrder, 0);
    expect(step.createdAt, DateTime.utc(2026, 9, 7));
    expect(step.updatedAt, DateTime.utc(2026, 9, 7, 0, 0, 1, 501));
    expect(jsonDecode(jsonEncode(step)), json);
  });
}
