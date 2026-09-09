import 'dart:async';
import 'dart:convert';

import 'package:cli_util/cli_logging.dart';
import 'package:genuineci_cli/src/commands/dev/seed_local_data.dart';
import 'package:genuineci_cli/src/i18n/i18n.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

class _RecordingLogger implements Logger {
  final stdoutMessages = <String>[];
  final stderrMessages = <String>[];

  @override
  void stdout(String message) => stdoutMessages.add(message);

  @override
  void stderr(String message) => stderrMessages.add(message);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const job = {
  'owner': 'example',
  'repo': 'project',
  'commitSha': '0123456789012345678901234567890123456789',
  'workflowFileName': 'smoke.dart',
  'installationId': '42',
  'branch': 'develop',
};

void main() {
  group('seedLocalData', () {
    late _RecordingLogger logger;

    setUp(() {
      logger = _RecordingLogger();
    });

    test('submits exactly one configured job', () async {
      final requests = <http.Request>[];
      final result = await seedLocalData(
        logger,
        job,
        client: MockClient((request) async {
          requests.add(request);
          return http.Response('{}', 200);
        }),
        environment: {'OPENCI_SERVER_URL': 'http://localhost:9090'},
      );
      expect(result, isTrue);
      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.url.toString(), 'http://localhost:9090/internal/seed');
      expect(request.headers['content-type'], 'application/json');
      expect(jsonDecode(request.body), job);
      expect(logger.stderrMessages, isEmpty);
      expect(logger.stdoutMessages.last, t.dev.start.stepSeedCompleted);
    });

    test('returns false when the seed request fails', () async {
      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        return http.Response('seed failed', 500);
      });

      final result = await seedLocalData(
        logger,
        job,
        client: client,
        environment: const {},
      );

      expect(result, isFalse);
      expect(requestCount, equals(1));
      expect(
        logger.stderrMessages.single,
        contains(t.dev.start.stepSeedFailed),
      );
      expect(logger.stderrMessages.single, contains('Status: 500'));
      expect(logger.stderrMessages.single, contains('Body: seed failed'));
      expect(logger.stdoutMessages, ['\n${t.dev.start.stepSeed}']);
    });

    test('returns false when an HTTP request throws', () async {
      final client = MockClient(
        (_) async => throw Exception('connection failed'),
      );

      final result = await seedLocalData(
        logger,
        job,
        client: client,
        environment: const {},
      );

      expect(result, isFalse);
      expect(
        logger.stderrMessages.single,
        contains(t.dev.start.stepSeedFailed),
      );
      expect(logger.stderrMessages.single, contains('connection failed'));
      expect(logger.stdoutMessages, ['\n${t.dev.start.stepSeed}']);
    });

    test('returns false when seed request times out', () async {
      final client = MockClient((_) => Completer<http.Response>().future);

      final result = await seedLocalData(
        logger,
        job,
        client: client,
        environment: const {},
        timeout: const Duration(milliseconds: 50),
      );

      expect(result, isFalse);
      expect(
        logger.stderrMessages.single,
        contains(t.dev.start.stepSeedFailed),
      );
      expect(logger.stderrMessages.single, contains('TimeoutException'));
      expect(logger.stdoutMessages, ['\n${t.dev.start.stepSeed}']);
    });
  });
}
