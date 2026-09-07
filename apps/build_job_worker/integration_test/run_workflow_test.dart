import 'dart:convert';
import 'dart:io';

import 'package:build_job_worker/build_job_worker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

class _MockOrchardApiClient extends Mock implements OrchardApiClient {}

void main() {
  late Directory temporary;
  late String workspace;
  late String vmHome;
  late File records;
  late OrchardApiClient api;
  late http.Client lokiClient;
  late BuildJob job;
  late Map<String, String> environment;
  late List<http.Request> requests;
  const secret =
      r'''test-only-secret 日本語 $HOME $(touch injected) `touch injected` ' " a=b''';
  const runId = r'''run ' " $(touch injected)''';
  const vmLokiUrl = 'http://vm-loki:3100';

  Future<int> run({String secretsContent = ''}) => runWorkflow(
    api: api,
    lokiClient: lokiClient,
    lokiUrl: 'http://loki:3100',
    vmLokiUrl: vmLokiUrl,
    vmName: 'vm-1',
    job: job,
    runId: runId,
    secretsContent: secretsContent,
    workspacePath: workspace,
    vmHomePath: vmHome,
    onLogError: (error, _) => fail('Unexpected Loki error: $error'),
  );

  Future<List<Map<String, dynamic>>> calls() async => [
    for (final line in await records.readAsLines())
      jsonDecode(line) as Map<String, dynamic>,
  ];

  setUpAll(() => registerFallbackValue((String line, String stream) {}));

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('worker-run-workflow-');
    addTearDown(() => temporary.delete(recursive: true));
    workspace =
        temporary.path +
        r'''/workspace ' " $(touch injected) `touch injected`''';
    vmHome = '${temporary.path}/home with spaces';
    await Directory(workspace).create();
    final flutterBin = Directory('$vmHome/fvm/default/bin');
    await flutterBin.create(recursive: true);
    final recorder = File('${temporary.path}/record_flutter.dart');
    await recorder.writeAsString(_recorderSource);
    final flutter = File('${flutterBin.path}/flutter');
    await flutter.writeAsString(
      '#!/bin/sh\nexec ${_shellQuote(Platform.resolvedExecutable)} ${_shellQuote(recorder.path)} "\$@"\n',
    );
    expect((await Process.run('chmod', ['+x', flutter.path])).exitCode, 0);
    records = File('${temporary.path}/calls.jsonl');
    environment = {
      'PATH': Platform.environment['PATH'] ?? '/usr/bin:/bin',
      'WORKER_TEST_RECORDS': records.path,
    };
    final now = DateTime.utc(2026, 9, 7);
    job = BuildJob(
      id: r'''job ' " $(touch injected)''',
      status: BuildJobStatus.IN_PROGRESS,
      owner: 'acme',
      repo: 'app',
      workflowName: 'CI',
      workflowFileName: r'''CI ' " $(touch injected) `touch injected`.dart''',
      createdAt: now,
      updatedAt: now,
    );
    requests = [];
    lokiClient = MockClient((request) async {
      requests.add(request);
      return http.Response('', 204);
    });
    addTearDown(lokiClient.close);
    api = _MockOrchardApiClient();
    when(
      () => api.execCommandWebSocket(
        vmName: 'vm-1',
        command: any(named: 'command'),
        onLog: any(named: 'onLog'),
      ),
    ).thenAnswer((invocation) async {
      final result = await Process.run(
        '/bin/sh',
        ['-c', invocation.namedArguments[#command] as String],
        workingDirectory: temporary.path,
        environment: environment,
        includeParentEnvironment: false,
      );
      final onLog =
          invocation.namedArguments[#onLog] as void Function(String, String);
      for (final (stream, output) in [
        ('stdout', result.stdout as String),
        ('stderr', result.stderr as String),
      ]) {
        for (final line in const LineSplitter().convert(output)) {
          onLog(line, stream);
        }
      }
      return result.exitCode;
    });
  });

  tearDown(() async {
    expect(await File('$workspace/.env').exists(), isFalse);
    expect(await File('$workspace.workflow.sh').exists(), isFalse);
    expect(await File('${temporary.path}/injected').exists(), isFalse);
    expect(await File('$workspace/injected').exists(), isFalse);
    expect(
      requests.map((request) => request.body).join(),
      isNot(contains('test-only-secret')),
    );
  });

  group('runWorkflow script', () {
    test(
      'loads literal secrets and runs the configured workflow after pub get',
      () async {
        expect(
          await run(
            secretsContent:
                'WORKER_TEST_SECRET=$secret\r\n\r\nWORKER_TEST_EMPTY=\r\nWORKER_TEST_ESCAPED=first\\nsecond\nWORKER_TEST_CARRIAGE=first\rsecond\nassignment=kept',
          ),
          0,
        );

        final recorded = await calls();
        expect(recorded, hasLength(2));
        expect(recorded[0]['arguments'], ['pub', 'get']);
        expect(recorded[1]['arguments'], [
          'pub',
          'run',
          'genuine_ci/${job.workflowFileName}',
        ]);
        for (final call in recorded) {
          expect(
            call['cwd'],
            await Directory(workspace).resolveSymbolicLinks(),
          );
          expect(call['envMode'], 0x180);
          expect(call['scriptMode'], 0x180);
          final env = call['environment'] as Map<String, dynamic>;
          expect(env['WORKER_TEST_SECRET'], secret);
          expect(env['WORKER_TEST_EMPTY'], '');
          expect(env['WORKER_TEST_ESCAPED'], r'first\nsecond');
          expect(env['WORKER_TEST_CARRIAGE'], 'first\rsecond');
          expect(env['assignment'], 'kept');
          expect(env['HOME'], vmHome);
          expect(env['FLUTTER_ROOT'], '$vmHome/fvm/default');
          expect(
            env['PATH'],
            startsWith(
              '$vmHome/fvm/default/bin:$vmHome/.pub-cache/bin:/opt/homebrew/bin:/usr/local/bin:',
            ),
          );
          expect(env['GENUINE_CI_RUN_ID'], runId);
          expect(env['GENUINE_CI_BUILD_JOB_ID'], job.id);
          expect(env['LOKI_URL'], vmLokiUrl);
        }
        expect(requests, isNotEmpty);
      },
    );

    test('returns a pub get failure without starting the workflow', () async {
      environment['WORKER_TEST_PUB_GET_EXIT'] = '17';

      expect(await run(), 17);

      final recorded = await calls();
      expect(recorded.single['arguments'], ['pub', 'get']);
    });

    test('returns the workflow exit code', () async {
      environment['WORKER_TEST_WORKFLOW_EXIT'] = '23';

      expect(await run(), 23);

      expect(await calls(), hasLength(2));
    });

    test('overwrites an existing env file when secrets are empty', () async {
      await File(
        '$workspace/.env',
      ).writeAsString('WORKER_TEST_SECRET=test-only-secret');

      expect(await run(), 0);

      for (final call in await calls()) {
        final env = call['environment'] as Map<String, dynamic>;
        expect(env['WORKER_TEST_SECRET'], isNull);
        expect(call['envContent'], isEmpty);
      }
    });

    test(
      'keeps worker settings authoritative over secrets with the same names',
      () async {
        expect(
          await run(
            secretsContent: '''HOME=/unused
FLUTTER_ROOT=/unused
PATH=/unused
GENUINE_CI_RUN_ID=wrong-run
GENUINE_CI_BUILD_JOB_ID=wrong-job
LOKI_URL=http://wrong-loki
''',
          ),
          0,
        );

        for (final call in await calls()) {
          final env = call['environment'] as Map<String, dynamic>;
          expect(env['HOME'], vmHome);
          expect(env['FLUTTER_ROOT'], '$vmHome/fvm/default');
          expect(env['GENUINE_CI_RUN_ID'], runId);
          expect(env['GENUINE_CI_BUILD_JOB_ID'], job.id);
          expect(env['LOKI_URL'], vmLokiUrl);
        }
      },
    );
  });
}

String _shellQuote(String value) => "'${value.replaceAll("'", "'\\''")}'";

const _recorderSource = r'''
import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  final env = Platform.environment;
  final file = File(env['WORKER_TEST_RECORDS']!);
  file.writeAsStringSync('${jsonEncode({
    'arguments': arguments,
    'cwd': Directory.current.path,
    'envContent': File('.env').readAsStringSync(),
    'envMode': File('.env').statSync().mode & 0x1ff,
    'scriptMode': File('${Directory.current.path}.workflow.sh').statSync().mode & 0x1ff,
    'environment': {
      for (final key in [
        'WORKER_TEST_SECRET', 'WORKER_TEST_EMPTY', 'WORKER_TEST_ESCAPED',
        'WORKER_TEST_CARRIAGE', 'assignment',
        'HOME', 'FLUTTER_ROOT', 'PATH', 'GENUINE_CI_RUN_ID',
        'GENUINE_CI_BUILD_JOB_ID', 'LOKI_URL',
      ]) key: env[key],
    },
  })}\n', mode: FileMode.append);
  stdout.writeln('flutter ${arguments[1]} output');
  stderr.writeln('flutter ${arguments[1]} stderr');
  exitCode = int.parse(env[arguments[1] == 'get'
      ? 'WORKER_TEST_PUB_GET_EXIT'
      : 'WORKER_TEST_WORKFLOW_EXIT'] ?? '0');
}
''';
