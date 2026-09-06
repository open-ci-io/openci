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
  late Directory fixtures;
  late Directory temporary;
  late String remote;
  late String firstSha;
  late String secondSha;
  late String workspace;
  late OrchardApiClient api;
  late http.Client lokiClient;
  late BuildJob job;
  late List<http.Request> requests;
  late Map<String, String> environment;
  const token = 'test-only-checkout-token';
  const repoUrl = 'https://github.com/acme/app.git';
  const literalBranch = r"topic'$(touch${IFS}injected)";

  Future<void> checkout() => checkoutRepository(
    api: api,
    lokiClient: lokiClient,
    lokiUrl: 'http://loki:3100',
    vmName: 'vm-1',
    job: job,
    token: token,
    runId: 'run-1',
    onLogError: (error, _) => fail('Unexpected Loki error: $error'),
    workspacePath: workspace,
  );

  setUpAll(() async {
    registerFallbackValue((String line, String stream) {});
    fixtures = await Directory.systemTemp.createTemp('worker-checkout-origin-');
    addTearDown(() => fixtures.delete(recursive: true));
    remote = '${fixtures.path}/origin';
    await _git(fixtures.path, ['init', '-b', 'develop', remote]);
    await File('$remote/version.txt').writeAsString('first');
    await _git(remote, ['add', '.']);
    await _git(remote, ['commit', '-m', 'first']);
    firstSha = await _git(remote, ['rev-parse', 'HEAD']);
    await _git(remote, ['branch', 'release', firstSha]);
    await _git(remote, ['branch', literalBranch, firstSha]);
    await File('$remote/version.txt').writeAsString('second');
    await _git(remote, ['commit', '-am', 'second']);
    secondSha = await _git(remote, ['rev-parse', 'HEAD']);
    await _git(remote, ['update-ref', 'refs/pull/42/head', secondSha]);
  });

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('worker-checkout-');
    addTearDown(() => temporary.delete(recursive: true));
    workspace =
        temporary.path +
        r'''/workspace ' " $(touch injected) `touch injected`''';
    final now = DateTime.utc(2026, 9, 7);
    job = BuildJob(
      id: 'job-1',
      status: BuildJobStatus.IN_PROGRESS,
      owner: 'acme',
      repo: 'app',
      workflowName: 'CI',
      workflowFileName: 'ci.dart',
      commitSha: firstSha,
      pullRequestNumber: 42,
      branch: 'develop',
      createdAt: now,
      updatedAt: now,
    );
    environment = {
      'GIT_CONFIG_NOSYSTEM': '1',
      'GIT_CONFIG_GLOBAL': '/dev/null',
      'GIT_CONFIG_COUNT': '1',
      'GIT_CONFIG_KEY_0': 'url.${Uri.directory(remote)}.insteadOf',
      'GIT_CONFIG_VALUE_0': repoUrl,
      'GIT_ALLOW_PROTOCOL': 'file',
    };
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
      final script = File('$workspace.checkout.sh');
      if (await script.exists()) {
        expect((await script.stat()).mode & 0x1ff, 0x180);
      }
      return result.exitCode;
    });
  });

  tearDown(() async {
    expect(await File('$workspace.checkout.sh').exists(), isFalse);
    expect(await File('${temporary.path}/injected').exists(), isFalse);
    expect(await File('$workspace/injected').exists(), isFalse);
    final logs = requests.map((request) => request.body).join();
    expect(logs, isNot(contains(token)));
    expect(
      logs,
      isNot(contains(base64Encode(utf8.encode('x-access-token:$token')))),
    );
  });

  group('checkoutRepository with Git', () {
    test('pins the commit even when the PR and branch have advanced', () async {
      await checkout();

      expect(await _git(workspace, ['rev-parse', 'HEAD']), firstSha);
      expect(await File('$workspace/version.txt').readAsString(), 'first');
      final config = await File('$workspace/.git/config').readAsString();
      expect(config, contains(repoUrl));
      expect(config, isNot(contains(token)));
      expect(config.toLowerCase(), isNot(contains('extraheader')));
      expect(requests, isNotEmpty);
    });

    test('fetches the PR head when the commit is absent', () async {
      job = job.copyWith(commitSha: null);

      await checkout();

      expect(await _git(workspace, ['rev-parse', 'HEAD']), secondSha);
    });

    test('fetches the branch when the commit and PR are absent', () async {
      job = job.copyWith(
        commitSha: null,
        pullRequestNumber: null,
        branch: 'release',
      );

      await checkout();

      expect(await _git(workspace, ['rev-parse', 'HEAD']), firstSha);
    });

    test('uses develop when the job has no checkout ref', () async {
      job = job.copyWith(commitSha: '', pullRequestNumber: null, branch: '');

      await checkout();

      expect(await _git(workspace, ['rev-parse', 'HEAD']), secondSha);
    });

    test('uses the configured GitHub Enterprise URL', () async {
      const baseUrl = 'https://github.example:8443/git/';
      job = job.copyWith(githubBaseUrl: baseUrl);
      environment['GIT_CONFIG_VALUE_0'] = '${baseUrl}acme/app.git';

      await checkout();

      expect(await _git(workspace, ['rev-parse', 'HEAD']), firstSha);
      expect(
        await _git(workspace, ['config', '--local', 'remote.origin.url']),
        '${baseUrl}acme/app.git',
      );
    });

    test(
      'sends the token as an HTTP header without logging it on failure',
      () async {
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        addTearDown(() => server.close(force: true));
        final authorizationHeaders = <String?>[];
        server.listen((request) async {
          authorizationHeaders.add(
            request.headers.value(HttpHeaders.authorizationHeader),
          );
          request.response.statusCode = HttpStatus.unauthorized;
          await request.response.close();
        });
        job = job.copyWith(githubBaseUrl: 'http://127.0.0.1:${server.port}');
        environment['GIT_ALLOW_PROTOCOL'] = 'http';

        await expectLater(checkout(), throwsStateError);

        expect(authorizationHeaders, isNotEmpty);
        expect(
          authorizationHeaders,
          everyElement(
            'Basic ${base64Encode(utf8.encode('x-access-token:$token'))}',
          ),
        );
      },
    );

    test(
      'fails for an unavailable commit without using the PR or branch',
      () async {
        job = job.copyWith(commitSha: '0' * 40);

        await expectLater(checkout(), throwsStateError);

        expect(await File('$workspace/version.txt').exists(), isFalse);
        expect(requests, isNotEmpty);
      },
    );

    test('treats shell syntax in the branch name literally', () async {
      job = job.copyWith(
        commitSha: null,
        pullRequestNumber: null,
        branch: literalBranch,
      );

      await checkout();

      expect(await _git(workspace, ['rev-parse', 'HEAD']), firstSha);
    });
  });
}

Future<String> _git(String directory, List<String> arguments) async {
  final result = await Process.run(
    'git',
    [
      '-c',
      'user.name=Worker Test',
      '-c',
      'user.email=worker@example.test',
      ...arguments,
    ],
    workingDirectory: directory,
    environment: {'GIT_CONFIG_NOSYSTEM': '1', 'GIT_CONFIG_GLOBAL': '/dev/null'},
  );
  expect(result.exitCode, 0, reason: result.stderr as String);
  return (result.stdout as String).trim();
}
