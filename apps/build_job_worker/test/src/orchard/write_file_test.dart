import 'dart:convert';
import 'dart:io';

import 'package:build_job_worker/build_job_worker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockOrchardApiClient extends Mock implements OrchardApiClient {}

void main() {
  late OrchardApiClient api;
  const content = 'SECRET=test-only-secret';

  setUpAll(() {
    registerFallbackValue((String line, String stream) {});
  });

  setUp(() {
    api = _MockOrchardApiClient();
  });

  tearDown(() => verifyNever(api.close));

  Future<void> write() => writeFile(
    api: api,
    vmName: 'vm-1',
    filePath: '/tmp/workspace/.env',
    content: content,
  );

  group('writeFile', () {
    for (final (description, filePath) in [
      ('an empty path', ''),
      ('a path containing NUL', 'file\u0000.txt'),
    ]) {
      test('rejects $description before contacting Orchard', () async {
        await expectLater(
          writeFile(
            api: api,
            vmName: 'vm-1',
            filePath: filePath,
            content: content,
          ),
          throwsArgumentError,
        );

        verifyZeroInteractions(api);
      });
    }

    test(
      'reports a non-zero exit code without including file content',
      () async {
        when(
          () => api.execCommandWebSocket(
            vmName: 'vm-1',
            command: any(named: 'command'),
            onLog: any(named: 'onLog'),
          ),
        ).thenAnswer((invocation) async {
          final onLog =
              invocation.namedArguments[#onLog]
                  as void Function(String, String);
          onLog(content, 'stdout');
          onLog(content, 'stderr');
          return 23;
        });

        await expectLater(
          write(),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              'Failed to write file on Orchard VM (vm-1): exit code 23.',
            ),
          ),
        );
      },
    );

    test('redacts exec failures while preserving their stack trace', () async {
      final encoded = base64Encode(utf8.encode(content));
      final stackTrace = StackTrace.fromString('Orchard execution failed here');
      when(
        () => api.execCommandWebSocket(
          vmName: 'vm-1',
          command: any(named: 'command'),
          onLog: any(named: 'onLog'),
        ),
      ).thenAnswer(
        (_) => Future.error(
          WebSocketException('Rejected command containing $encoded ($content)'),
          stackTrace,
        ),
      );

      try {
        await write();
        fail('Expected the write to fail');
      } on StateError catch (error, actualStackTrace) {
        expect(
          error.message,
          'Failed to write file on Orchard VM (vm-1): WebSocketException.',
        );
        expect(actualStackTrace.toString(), stackTrace.toString());
      }
    });
  });
}
