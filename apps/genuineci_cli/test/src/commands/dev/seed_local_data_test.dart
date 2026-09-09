import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

void main() {
  group('seedLocalData', () {
    late _RecordingLogger logger;

    setUp(() {
      logger = _RecordingLogger();
    });

    test('requests the default seed data exactly once', () async {
      const serverUrl = 'http://localhost:9090';
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        return http.Response('{"success":true,"jobId":"job-test"}', 200);
      });

      final result = await seedLocalData(
        logger,
        client: client,
        environment: {'OPENCI_SERVER_URL': serverUrl},
      );

      expect(result, isTrue);
      expect(requests, hasLength(1));
      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.url, Uri.parse('$serverUrl/internal/seed'));
      expect(request.headers['content-type'], 'application/json');
      expect(jsonDecode(request.body), isEmpty);
      expect(logger.stderrMessages, isEmpty);
      expect(logger.stdoutMessages, [
        '\n${t.dev.start.stepSeed}',
        t.dev.start.stepSeedCompleted,
      ]);
    });

    test('uses the process server URL with the default HTTP client', () async {
      final serverUrl =
          Platform.environment['OPENCI_SERVER_URL'] ?? 'http://localhost:8080';
      var requestCount = 0;

      final result = await http.runWithClient(
        () => seedLocalData(logger),
        () => MockClient((request) async {
          requestCount++;
          expect(request.url, Uri.parse('$serverUrl/internal/seed'));
          return http.Response('{"success":true,"jobId":"job-test"}', 200);
        }),
      );

      expect(result, isTrue);
      expect(requestCount, 1);
    });

    test('returns false when the seed request fails', () async {
      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        expect(request.url, Uri.parse('http://localhost:8080/internal/seed'));
        return http.Response('seed failed', 500);
      });

      final result = await seedLocalData(
        logger,
        client: client,
        environment: const {},
      );

      expect(result, isFalse);
      expect(requestCount, 1);
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
        client: client,
        environment: const {},
      );

      expect(result, isFalse);
      expect(logger.stderrMessages.single, contains('connection failed'));
      expect(logger.stdoutMessages, ['\n${t.dev.start.stepSeed}']);
    });

    test('returns false when the seed request times out', () async {
      final client = MockClient((_) => Completer<http.Response>().future);

      final result = await seedLocalData(
        logger,
        client: client,
        environment: const {},
        timeout: const Duration(milliseconds: 50),
      );

      expect(result, isFalse);
      expect(logger.stderrMessages.single, contains('TimeoutException'));
      expect(logger.stdoutMessages, ['\n${t.dev.start.stepSeed}']);
    });
  });
}
