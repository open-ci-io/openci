import 'dart:async';
import 'dart:convert';

import 'package:build_job_worker/build_job_worker.dart';
import 'package:build_job_worker/src/send_step_log_chunk.dart'
    show buildStepLogPayload;
import 'package:mocktail/mocktail.dart';
import 'package:openci_shared/openci_shared.dart';
import 'package:openci_shared/test_helpers.dart';
import 'package:test/test.dart';

class _MockOpenCiApiService extends Mock implements OpenCiApiService {}

void main() {
  late OpenCiApiService api;
  const lines = ['first', '', '日本語のログ', 'first'];
  const payload = {
    'logs': [
      {'message': 'first'},
      {'message': ''},
      {'message': '日本語のログ'},
      {'message': 'first'},
    ],
  };

  Future<void> send(List<String> lines) => sendStepLogChunk(
    api: api,
    jobId: 'job-1',
    runId: 'run-1',
    stepId: 'step-1',
    lines: lines,
  );

  group('buildStepLogPayload', () {
    test('returns an empty logs list for empty input', () {
      expect(buildStepLogPayload([]), {'logs': <Map<String, String>>[]});
    });

    test('wraps one line in a message entry', () {
      expect(buildStepLogPayload(['build started']), {
        'logs': [
          {'message': 'build started'},
        ],
      });
    });

    test('preserves line order and repeated messages', () {
      expect(buildStepLogPayload(lines), payload);
    });

    test('preserves empty and whitespace-only lines without trimming', () {
      expect(buildStepLogPayload(['', ' ', '\t', '  indented  ']), {
        'logs': [
          {'message': ''},
          {'message': ' '},
          {'message': '\t'},
          {'message': '  indented  '},
        ],
      });
    });

    test('preserves special characters through JSON encoding', () {
      const message =
          '日本語 🚀 "quoted" \\path\nnext\r\n\t\u001b[31mred\u001b[0m';
      const expected = {
        'logs': [
          {'message': message},
        ],
      };

      final result = buildStepLogPayload([message]);

      expect(result, expected);
      expect(jsonDecode(jsonEncode(result)), expected);
    });

    test('leaves the input intact and snapshots it before later changes', () {
      final buffer = ['first', 'second'];

      final result = buildStepLogPayload(buffer);

      expect(buffer, ['first', 'second']);
      buffer[0] = 'changed';
      buffer.add('late');
      expect(result, {
        'logs': [
          {'message': 'first'},
          {'message': 'second'},
        ],
      });
    });
  });

  group('sendStepLogChunk', () {
    setUp(() => api = _MockOpenCiApiService());

    test(
      'sends all lines in one request, preserving order and blanks',
      () async {
        when(
          () => api.appendStepLog('job-1', 'run-1', 'step-1', payload),
        ).thenAnswer((_) async => createMockResponse<void>(null));

        await send(lines);

        verify(
          () => api.appendStepLog('job-1', 'run-1', 'step-1', payload),
        ).called(1);
        verifyNoMoreInteractions(api);
      },
    );

    test('does not send an empty chunk', () async {
      await send([]);

      verifyZeroInteractions(api);
    });

    test(
      'reports an HTTP failure without exposing the response body',
      () async {
        when(
          () => api.appendStepLog('job-1', 'run-1', 'step-1', payload),
        ).thenAnswer(
          (_) async => createMockResponse<void>(
            null,
            statusCode: 503,
          ).copyWith<void>(bodyError: 'private response body'),
        );

        await expectLater(
          send(lines),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              'Failed to send step log chunk: HTTP 503.',
            ),
          ),
        );
        verify(
          () => api.appendStepLog('job-1', 'run-1', 'step-1', payload),
        ).called(1);
        verifyNoMoreInteractions(api);
      },
    );

    test('reports a transport failure and preserves its stack', () async {
      final stackTrace = StackTrace.fromString('Log delivery failed here');
      when(
        () => api.appendStepLog('job-1', 'run-1', 'step-1', payload),
      ).thenAnswer(
        (_) => Future.error(
          TimeoutException('private request details'),
          stackTrace,
        ),
      );

      try {
        await send(lines);
        fail('Expected log delivery to fail');
      } on StateError catch (error, actualStackTrace) {
        expect(
          error.message,
          'Failed to send step log chunk: TimeoutException.',
        );
        expect(actualStackTrace.toString(), stackTrace.toString());
      }
      verify(
        () => api.appendStepLog('job-1', 'run-1', 'step-1', payload),
      ).called(1);
      verifyNoMoreInteractions(api);
    });
  });
}
