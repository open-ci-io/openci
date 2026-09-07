import 'dart:convert';

import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

void main() {
  group('WebhookTask JSON', () {
    test('defaults a newly received task to pending with no retries', () {
      final task = WebhookTask.fromJson(_taskJson());

      expect(task.id, 'task-1');
      expect(task.deliveryId, 'delivery-1');
      expect(task.eventType, 'push');
      expect(task.status, 'pending');
      expect(task.retryCount, 0);
      expect(task.errorMessage, isNull);
      expect(task.createdAt, DateTime.utc(2026, 9, 7));
      expect(task.updatedAt, DateTime.utc(2026, 9, 7, 0, 1));
      expect(task.toJson()['status'], 'pending');
      expect(task.toJson()['retryCount'], 0);
    });

    test('preserves retry state and the JSON payload as a string', () {
      final json = {
        ..._taskJson(),
        'status': 'failed',
        'retryCount': 2,
        'errorMessage': 'Workflow could not be parsed',
      };

      final task = WebhookTask.fromJson(json);

      expect(task.status, 'failed');
      expect(task.retryCount, 2);
      expect(task.errorMessage, 'Workflow could not be parsed');
      expect(task.payload, '{"ref":"refs/heads/main","message":"テスト"}');
      expect(jsonDecode(jsonEncode(task)), json);
    });

    test('rejects an object where the payload must be a JSON string', () {
      expect(
        () => WebhookTask.fromJson({
          ..._taskJson(),
          'payload': {'ref': 'refs/heads/main'},
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });
}

Map<String, Object?> _taskJson() => {
  'id': 'task-1',
  'deliveryId': 'delivery-1',
  'eventType': 'push',
  'payload': '{"ref":"refs/heads/main","message":"テスト"}',
  'createdAt': '2026-09-07T00:00:00.000Z',
  'updatedAt': '2026-09-07T00:01:00.000Z',
};
