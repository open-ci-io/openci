import 'dart:convert';

import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'CicdCommitGroup preserves nested stages and duration in microseconds',
    () {
      final json = {
        'branch': 'main',
        'commitSha': 'abc123',
        'commitMessage': 'Add CI tests',
        'status': 'IN_PROGRESS',
        'createdAt': '2026-09-07T00:00:00.000Z',
        'workflows': [
          {
            'fileName': 'ci.dart',
            'status': 'IN_PROGRESS',
            'duration': 1500001,
            'stages': [
              [
                {'id': 'lint', 'label': 'Analyze', 'status': 'SUCCESS'},
                {'id': 'test', 'label': 'Test', 'status': 'SUCCESS'},
              ],
              [
                {'id': 'build', 'label': 'Build', 'status': 'IN_PROGRESS'},
              ],
            ],
          },
        ],
      };

      final group = CicdCommitGroup.fromJson(json);

      expect(group.commitSha, 'abc123');
      expect(group.status, BuildJobStatus.IN_PROGRESS);
      expect(group.createdAt, DateTime.utc(2026, 9, 7));
      final workflow = group.workflows.single;
      expect(workflow.fileName, 'ci.dart');
      expect(workflow.status, BuildJobStatus.IN_PROGRESS);
      expect(workflow.duration, const Duration(microseconds: 1500001));
      expect(workflow.stages.map((stage) => stage.map((job) => job.id)), [
        ['lint', 'test'],
        ['build'],
      ]);
      expect(workflow.stages.first.first.label, 'Analyze');
      expect(workflow.stages.first.first.status, BuildJobStatus.SUCCESS);
      expect(workflow.stages.last.single.status, BuildJobStatus.IN_PROGRESS);
      expect(jsonDecode(jsonEncode(group)), json);
    },
  );

  test('CicdWorkflowGroup accepts zero duration and empty stages', () {
    final workflow = CicdWorkflowGroup.fromJson({
      'fileName': 'ci.dart',
      'status': 'QUEUED',
      'duration': 0,
      'stages': [],
    });

    expect(workflow.status, BuildJobStatus.QUEUED);
    expect(workflow.duration, Duration.zero);
    expect(workflow.stages, isEmpty);
  });
}
