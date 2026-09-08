import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

const _waitTimeout = Duration(seconds: 15);

void main() {
  const environment = {
    'OPENCI_SERVER_URL': 'http://127.0.0.1:1',
    'INTERNAL_API_KEY': 'test-api-key',
    'ORCHARD_SERVICE_ACCOUNT_NAME': 'bootstrap-admin',
    'ORCHARD_SERVICE_ACCOUNT_TOKEN': 'test-orchard-token',
  };

  for (final signal in [ProcessSignal.sigterm, ProcessSignal.sigint]) {
    test(
      'claims jobs and stops gracefully on $signal while idle',
      () async {
        final claimed = Completer<void>();
        var claims = 0;
        final server = await _serve((request) async {
          expect(request.method, 'POST');
          expect(request.uri.path, '/builds/claim');
          expect(
            request.headers.value(HttpHeaders.authorizationHeader),
            'Bearer ${environment['INTERNAL_API_KEY']}',
          );
          expect(await _body(request), isEmpty);
          claims++;
          await _reply(request, {'job': null});
          if (!claimed.isCompleted) claimed.complete();
        });
        final worker = await _startWorker({
          ...environment,
          'OPENCI_SERVER_URL': _url(server),
          'SENTRY_DSN': '',
        });

        await claimed.future.timeout(_waitTimeout);
        expect(worker.process.kill(signal), isTrue);
        final result = await worker.finish();

        expect(result.exitCode, 0);
        expect(result.stdout, contains('Starting build job worker...'));
        expect(
          result.stdout,
          contains('Waiting for the current job to finish.'),
        );
        expect(result.stdout, contains('Build job worker stopped.'));
        expect(result.stderr, isEmpty);
        expect(claims, 1);
        _expectNoCredentials(result, environment);
      },
      skip: Platform.isWindows,
    );
  }

  test('keeps polling when Sentry rejects errors', () async {
    final nextClaim = Completer<HttpRequest>();
    final reports = <Map<String, dynamic>>[];
    final sentry = await _serve((request) async {
      reports.add(await _sentryEvent(request));
      await _reply(request, null, statusCode: 503);
    });
    var claims = 0;
    final server = await _serve((request) async {
      expect(request.uri.path, '/builds/claim');
      await request.drain<void>();
      if (++claims == 1) {
        await _reply(request, {'error': 'unavailable'}, statusCode: 503);
      } else {
        nextClaim.complete(request);
      }
    });
    final worker = await _startWorker({
      ...environment,
      'OPENCI_SERVER_URL': _url(server),
      'SENTRY_DSN': _sentryDsn(sentry),
    });

    final request = await nextClaim.future.timeout(_waitTimeout);
    expect(worker.process.kill(ProcessSignal.sigterm), isTrue);
    await worker.waitForOutput('Waiting for the current job to finish.');
    await _reply(request, {'job': null});
    final result = await worker.finish();

    expect(result.exitCode, 0);
    expect(result.stderr, contains('Build job worker error:'));
    expect(result.stderr, contains('HTTP 503'));
    expect(result.stderr, contains('claimNextBuildJob'));
    expect(claims, 2);
    _expectSentryException(reports.single, 'StateError', 'HTTP 503');
    _expectNoCredentials(result, environment);
  }, skip: Platform.isWindows);

  test(
    'finishes a job claimed during shutdown and waits for its Sentry report',
    () async {
      final claim = Completer<HttpRequest>();
      final completed = <String>[];
      final report = Completer<(HttpRequest, Map<String, dynamic>)>();
      final sentry = await _serve((request) async {
        report.complete((request, await _sentryEvent(request)));
      });
      final server = await _serve((request) async {
        final path = request.uri.path;
        final body = await _body(request);
        switch ((request.method, path)) {
          case ('POST', '/builds/claim'):
            claim.complete(request);
          case ('POST', '/builds/job-1/runs'):
            completed.add('createRun');
            await _reply(request, null, statusCode: 503);
          case ('PATCH', '/builds/job-1'):
            expect(body['status'], 'FAILURE');
            completed.add('completeJob');
            await _reply(request, null, statusCode: 204);
          case ('POST', '/builds/job-1/check-run'):
            expect(body, {'status': 'completed', 'conclusion': 'failure'});
            completed.add('completeCheck');
            await _reply(request, null, statusCode: 204);
          default:
            fail('Unexpected request: ${request.method} $path');
        }
      });
      final worker = await _startWorker({
        ...environment,
        'OPENCI_SERVER_URL': _url(server),
        'SENTRY_DSN': _sentryDsn(sentry),
      });

      final request = await claim.future.timeout(_waitTimeout);
      expect(worker.process.kill(ProcessSignal.sigint), isTrue);
      await worker.waitForOutput('Waiting for the current job to finish.');
      await _reply(request, {'job': _job().toJson()});
      final (sentryRequest, event) = await report.future.timeout(_waitTimeout);
      await worker.waitForOutput('Build job worker stopped.');
      await expectLater(
        worker.exited.timeout(const Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );
      _expectSentryException(event, 'StateError', 'Failed to create build run');
      await _reply(sentryRequest, {});
      final result = await worker.finish();

      expect(result.exitCode, 0);
      expect(completed, ['createRun', 'completeJob', 'completeCheck']);
      expect(result.stderr, contains('Failed to create build run: HTTP 503.'));
      expect(result.stdout, contains('Build job worker stopped.'));
      _expectNoCredentials(result, environment);
    },
    skip: Platform.isWindows,
  );

  for (final workflowExitCode in [0, 23]) {
    test(
      'waits for workflow exit $workflowExitCode and VM cleanup before stopping',
      () async {
        final workflowStarted = Completer<void>();
        final finishWorkflow = Completer<void>();
        final deletion = Completer<HttpRequest>();
        final updates = <(String, Map<String, dynamic>)>[];
        final logs = <Map<String, dynamic>>[];
        var claims = 0;
        late String runId;
        late String vmName;
        addTearDown(() {
          if (!finishWorkflow.isCompleted) finishWorkflow.complete();
        });

        final server = await _serve((request) async {
          expect(
            request.headers.value(HttpHeaders.authorizationHeader),
            'Bearer ${environment['INTERNAL_API_KEY']}',
          );
          final path = request.uri.path;
          switch ((request.method, path)) {
            case ('POST', '/builds/claim'):
              await request.drain<void>();
              claims++;
              await _reply(request, {
                'job': claims == 1 ? _job().toJson() : null,
              });
            case ('POST', '/builds/job-1/runs'):
              runId = (await _body(request))['id'] as String;
              await _reply(request, null, statusCode: 201);
            case ('GET', '/builds/job-1/token'):
              await _reply(request, {'token': 'test-github-token'});
            case ('GET', '/builds/job-1/secrets'):
              await _reply(request, {
                'success': true,
                'secretsContent': 'TEST_SECRET=test-secret-value',
              });
            case ('PATCH', final path) when path == '/builds/job-1/runs/$runId':
              updates.add(('run', await _body(request)));
              await _reply(request, null, statusCode: 204);
            case ('PATCH', '/builds/job-1'):
              updates.add(('job', await _body(request)));
              await _reply(request, null, statusCode: 204);
            case ('POST', '/builds/job-1/check-run'):
              updates.add(('check', await _body(request)));
              await _reply(request, null, statusCode: 204);
            default:
              fail('Unexpected request: ${request.method} $path');
          }
        });
        final orchard = await _serve((request) async {
          expect(
            request.headers.value(HttpHeaders.authorizationHeader),
            'Basic ${base64Encode(utf8.encode('bootstrap-admin:test-orchard-token'))}',
          );
          final path = request.uri.path;
          switch ((request.method, path)) {
            case ('POST', '/v1/vms'):
              final body = await _body(request);
              expect(body['image'], 'test-base-macos');
              vmName = body['name'] as String;
              await _reply(request, {'id': 'lease-1', 'vm_name': vmName});
            case ('GET', '/v1/vms/lease-1'):
              await _reply(request, {
                'id': 'lease-1',
                'vm_name': vmName,
                'status': 'running',
              });
            case ('GET', final path) when path == '/v1/vms/$vmName/exec':
              final socket = await WebSocketTransformer.upgrade(request);
              addTearDown(() => socket.close());
              final closed = socket.drain<void>();
              final command = request.uri.queryParameters['command'];
              final isWorkflow =
                  command == "/bin/sh '/tmp/workspace.workflow.sh'";
              final isCheckout =
                  command == "/bin/sh '/tmp/workspace.checkout.sh'";
              if (isWorkflow) {
                workflowStarted.complete();
                await finishWorkflow.future;
              }
              if (isWorkflow || isCheckout) {
                socket.add(
                  jsonEncode({
                    'type': 'stdout',
                    'data': base64Encode(
                      utf8.encode(
                        isWorkflow ? 'workflow output\n' : 'checkout output\n',
                      ),
                    ),
                  }),
                );
              }
              socket.add(
                jsonEncode({
                  'type': 'exit',
                  'exit': {'code': isWorkflow ? workflowExitCode : 0},
                }),
              );
              await closed;
            case ('DELETE', '/v1/vms/lease-1'):
              deletion.complete(request);
            default:
              fail('Unexpected Orchard request: ${request.method} $path');
          }
        });
        final loki = await _serve((request) async {
          expect(request.method, 'POST');
          expect(request.uri.path, '/loki/api/v1/push');
          logs.add(await _body(request));
          await _reply(request, null, statusCode: 204);
        });
        final worker = await _startWorker({
          ...environment,
          'OPENCI_SERVER_URL': _url(server),
          'ORCHARD_API_URL': _url(orchard),
          'LOKI_URL': _url(loki),
          'BASE_VM_NAME': 'test-base-macos',
        });

        await workflowStarted.future.timeout(_waitTimeout);
        expect(worker.process.kill(ProcessSignal.sigterm), isTrue);
        await worker.waitForOutput('Waiting for the current job to finish.');
        expect(worker.exitCode, isNull);
        expect(updates, isEmpty);
        expect(deletion.isCompleted, isFalse);

        finishWorkflow.complete();
        final deleteRequest = await deletion.future.timeout(_waitTimeout);
        expect(worker.exitCode, isNull);
        expect(claims, 1);
        final conclusion = workflowExitCode == 0 ? 'success' : 'failure';
        expect(updates.map((update) => update.$1), ['run', 'job', 'check']);
        expect(updates[0].$2, {
          'status': 'completed',
          'conclusion': conclusion,
        });
        expect(updates[1].$2['status'], conclusion.toUpperCase());
        expect(
          DateTime.parse(updates[1].$2['completedAt'] as String).isUtc,
          isTrue,
        );
        expect(updates[2].$2, {
          'status': 'completed',
          'conclusion': conclusion,
        });
        expect(logs, hasLength(4));
        for (final (index, log) in logs.take(2).indexed) {
          final stream =
              (log['streams'] as List<dynamic>).single as Map<String, dynamic>;
          expect(stream['stream'], {
            'stream': 'stdout',
            'type': 'step_event',
            'run_id': runId,
            'build_job_id': 'job-1',
            'step_id': 'prepare_vm',
          });
          final values =
              (stream['values'] as List<dynamic>).single as List<dynamic>;
          final step = BuildStep.fromJson(
            jsonDecode(values[1] as String) as Map<String, dynamic>,
          );
          expect(step.runId, runId);
          expect(
            step.status,
            index == 0 ? BuildJobStatus.IN_PROGRESS : BuildJobStatus.SUCCESS,
          );
        }
        final outputLogs = logs.skip(2).toList();
        for (var index = 0; index < outputLogs.length; index++) {
          final stream =
              (outputLogs[index]['streams'] as List<dynamic>).single
                  as Map<String, dynamic>;
          expect(stream['stream'], {
            'stream': 'stdout',
            'type': 'step_log',
            'run_id': runId,
            'build_job_id': 'job-1',
            'step_id': index == 0 ? 'checkout' : 'run_workflow',
          });
          expect(
            (stream['values'] as List<dynamic>).single[1],
            index == 0 ? 'checkout output' : 'workflow output',
          );
        }

        await _reply(deleteRequest, null, statusCode: 204);
        final result = await worker.finish();

        expect(result.exitCode, 0);
        expect(result.stderr, isEmpty);
        expect(result.stdout, contains('Build job worker stopped.'));
        expect(result.stdout, isNot(contains('test-github-token')));
        expect(result.stdout, isNot(contains('test-secret-value')));
        expect(claims, 1);
        _expectNoCredentials(result, environment);
      },
      skip: Platform.isWindows,
    );
  }

  for (final key in environment.keys) {
    test('exits with an error when $key is missing', () async {
      final worker = await _startWorker({...environment}..remove(key));
      final result = await worker.finish();

      expect(result.exitCode, 1);
      expect(result.stdout, isEmpty);
      expect(
        result.stderr,
        contains('Required environment variable $key is not set.'),
      );
      _expectNoCredentials(result, environment);
    });
  }

  for (final key in ['OPENCI_SERVER_URL', 'ORCHARD_API_URL']) {
    test('exits with an error if $key prevents client creation', () async {
      final reports = <Map<String, dynamic>>[];
      final sentry = await _serve((request) async {
        reports.add(await _sentryEvent(request));
        await _reply(request, {});
      });
      final worker = await _startWorker({
        ...environment,
        key: 'http://[',
        'SENTRY_DSN': _sentryDsn(sentry),
      });
      final result = await worker.finish();

      expect(result.exitCode, 1);
      expect(result.stdout, isEmpty);
      expect(result.stderr, contains('Build job worker error:'));
      expect(result.stderr, contains('FormatException'));
      _expectSentryException(reports.single, 'FormatException', 'http://[');
      _expectNoCredentials(result, environment);
    });
  }

  test('stops when Sentry does not respond', () async {
    final reports = <Map<String, dynamic>>[];
    final sentry = await _serve((request) async {
      reports.add(await _sentryEvent(request));
    });
    final worker = await _startWorker({
      ...environment,
      'ORCHARD_API_URL': 'http://[',
      'SENTRY_DSN': _sentryDsn(sentry),
    });
    final result = await worker.finish();

    expect(result.exitCode, 1);
    expect(
      result.stderr,
      contains('Timed out sending worker errors to Sentry.'),
    );
    _expectSentryException(reports.single, 'FormatException', 'http://[');
    _expectNoCredentials(result, environment);
  });
}

Future<_WorkerProcess> _startWorker(Map<String, String> environment) async {
  final processEnvironment = {...Platform.environment}
    ..remove('OPENCI_SERVER_URL')
    ..remove('INTERNAL_API_KEY')
    ..remove('ORCHARD_SERVICE_ACCOUNT_NAME')
    ..remove('ORCHARD_SERVICE_ACCOUNT_TOKEN')
    ..remove('SENTRY_DSN')
    ..addAll({
      'ORCHARD_API_URL': 'http://127.0.0.1:1',
      'LOKI_URL': 'http://127.0.0.1:1',
      'LOKI_URL_FOR_VM': 'http://127.0.0.1:1',
    })
    ..addAll(environment);

  final process = await Process.start(
    Platform.resolvedExecutable,
    ['run', 'bin/main.dart'],
    environment: processEnvironment,
    includeParentEnvironment: false,
  );
  final worker = _WorkerProcess(process);
  addTearDown(() async {
    if (worker.exitCode == null) process.kill(ProcessSignal.sigkill);
    await worker.finish();
    await worker.outputLines.close();
  });
  return worker;
}

class _WorkerProcess {
  _WorkerProcess(this.process) {
    stdoutDone = process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach((line) {
          output.writeln(line);
          outputLines.add(line);
        });
    stderrDone = process.stderr.transform(utf8.decoder).forEach(errors.write);
    exited = process.exitCode.then((code) {
      exitCode = code;
      return code;
    });
  }

  final Process process;
  final output = StringBuffer();
  final errors = StringBuffer();
  final outputLines = StreamController<String>.broadcast();
  late final Future<void> stdoutDone;
  late final Future<void> stderrDone;
  late final Future<int> exited;
  int? exitCode;

  Future<void> waitForOutput(String text) async {
    if (output.toString().contains(text)) return;
    await outputLines.stream
        .firstWhere((line) => line.contains(text))
        .timeout(_waitTimeout);
  }

  Future<ProcessResult> finish() async {
    final code = await exited.timeout(_waitTimeout);
    await Future.wait([stdoutDone, stderrDone]).timeout(_waitTimeout);
    return ProcessResult(
      process.pid,
      code,
      output.toString(),
      errors.toString(),
    );
  }
}

Future<HttpServer> _serve(Future<void> Function(HttpRequest) handler) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen(handler);
  addTearDown(() => server.close(force: true));
  return server;
}

String _url(HttpServer server) => 'http://127.0.0.1:${server.port}';

String _sentryDsn(HttpServer server) =>
    'http://public@127.0.0.1:${server.port}/1';

Future<Map<String, dynamic>> _sentryEvent(HttpRequest request) async {
  expect(request.method, 'POST');
  expect(request.uri.path, '/api/1/envelope/');
  var bytes = await request.fold(<int>[], (body, chunk) => body..addAll(chunk));
  if (request.headers.value(HttpHeaders.contentEncodingHeader) == 'gzip') {
    bytes = gzip.decode(bytes);
  }
  final lines = const LineSplitter().convert(utf8.decode(bytes));
  expect(jsonDecode(lines[1]), containsPair('type', 'event'));
  return jsonDecode(lines[2]) as Map<String, dynamic>;
}

void _expectSentryException(
  Map<String, dynamic> event,
  String type,
  String message,
) {
  final exceptions = event['exception'] as Map<String, dynamic>;
  final exception =
      (exceptions['values'] as List<dynamic>).single as Map<String, dynamic>;
  expect(exception['type'], type);
  expect(exception['value'], contains(message));
  final stackTrace = exception['stacktrace'] as Map<String, dynamic>;
  expect(stackTrace['frames'], isNotEmpty);
}

Future<Map<String, dynamic>> _body(HttpRequest request) async =>
    jsonDecode(await utf8.decoder.bind(request).join()) as Map<String, dynamic>;

Future<void> _reply(
  HttpRequest request,
  Object? body, {
  int statusCode = 200,
}) async {
  request.response.statusCode = statusCode;
  if (body != null) {
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(body));
  }
  await request.response.close();
}

BuildJob _job() => BuildJob(
  id: 'job-1',
  status: BuildJobStatus.IN_PROGRESS,
  owner: 'acme',
  repo: 'app',
  workflowName: 'CI',
  workflowFileName: 'ci.dart',
  createdAt: DateTime.utc(2026, 9, 7),
  updatedAt: DateTime.utc(2026, 9, 7),
);

void _expectNoCredentials(
  ProcessResult result,
  Map<String, String> environment,
) {
  final output = '${result.stdout}\n${result.stderr}';
  expect(output, isNot(contains(environment['INTERNAL_API_KEY'])));
  expect(output, isNot(contains(environment['ORCHARD_SERVICE_ACCOUNT_TOKEN'])));
}
