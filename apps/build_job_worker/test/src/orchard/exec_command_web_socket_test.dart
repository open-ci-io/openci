import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build_job_worker/build_job_worker.dart';
import 'package:test/test.dart';

void main() {
  late HttpServer server;
  late OrchardApiClient api;
  late List<Object> frames;
  late List<WebSocket> sockets;
  late List<(String, String)> logs;
  late Completer<void> peerClosed;
  late bool closeBeforeExit;
  late bool rejectUpgrade;

  setUp(() async {
    frames = [];
    sockets = [];
    logs = [];
    peerClosed = Completer<void>();
    closeBeforeExit = false;
    rejectUpgrade = false;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    api = OrchardApiClient(
      config: Config(
        serverUrl: 'http://localhost:8080',
        internalApiKey: 'test-api-key',
        orchardApiUrl: 'http://127.0.0.1:${server.port}/orchard/',
        orchardServiceAccountName: 'worker',
        orchardServiceAccountToken: 'test-token',
      ),
    );
    server.listen((request) async {
      expect(request.uri.pathSegments, [
        'orchard',
        'v1',
        'vms',
        'vm /?#1',
        'exec',
      ]);
      expect(request.uri.queryParameters, {
        'command': 'echo "hello & world"',
        'wait': '120',
      });
      expect(
        request.headers.value(HttpHeaders.authorizationHeader),
        'Basic ${base64Encode(utf8.encode('worker:test-token'))}',
      );
      if (rejectUpgrade) {
        request.response.statusCode = HttpStatus.unauthorized;
        await request.response.close();
        return;
      }
      final socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      socket.listen(
        (_) {},
        onDone: () {
          if (!peerClosed.isCompleted) peerClosed.complete();
        },
      );
      for (final frame in frames) {
        socket.add(frame);
      }
      if (closeBeforeExit) await socket.close();
    });
  });

  tearDown(() async {
    api.close();
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
  });

  Future<int> execute({void Function(String, String)? onLog}) =>
      api.execCommandWebSocket(
        vmName: 'vm /?#1',
        command: 'echo "hello & world"',
        waitSeconds: 120,
        onLog: onLog ?? (line, stream) => logs.add((line, stream)),
      );

  Future<void> expectClosed() =>
      peerClosed.future.timeout(const Duration(seconds: 5));

  test(
    'decodes split UTF-8, separates streams, and flushes final lines',
    () async {
      final japanese = utf8.encode('日本語');
      frames = [
        _output('stdout', [...utf8.encode('hello\n\n'), ...japanese.take(2)]),
        utf8.encode(_output('stderr', utf8.encode('warning\r\n'))),
        _output('stdout', [
          ...japanese.skip(2),
          ...utf8.encode('\r\nfinal-out'),
        ]),
        _output('stderr', utf8.encode('final-err')),
        jsonEncode({'type': 'heartbeat'}),
        jsonEncode({
          'type': 'exit',
          'exit': {'code': 23},
        }),
      ];

      expect(await execute(), 23);
      expect(logs, [
        ('hello', 'stdout'),
        ('warning', 'stderr'),
        ('日本語', 'stdout'),
        ('final-out', 'stdout'),
        ('final-err', 'stderr'),
      ]);
      await expectClosed();
    },
  );

  test('returns zero for a silent command and closes the connection', () async {
    frames = [
      jsonEncode({
        'type': 'exit',
        'exit': {'code': 0},
      }),
    ];
    expect(await execute(), 0);
    expect(logs, isEmpty);
    await expectClosed();
  });

  for (final frame in [
    'not json',
    '[]',
    jsonEncode({'type': 'stdout', 'data': 42}),
    jsonEncode({'type': 'stderr', 'data': '%%%'}),
    jsonEncode({'type': 'exit', 'exit': null}),
    jsonEncode({
      'type': 'exit',
      'exit': {'code': '0'},
    }),
  ]) {
    test(
      'rejects malformed message $frame and closes the connection',
      () async {
        frames = [frame];
        await expectLater(execute(), throwsFormatException);
        expect(logs, isEmpty);
        await expectClosed();
      },
    );
  }

  test('reports an Orchard error and flushes buffered output', () async {
    frames = [
      _output('stderr', utf8.encode('last diagnostic')),
      jsonEncode({'type': 'error', 'error': 'execution denied'}),
    ];
    await expectLater(
      execute(),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('execution denied'),
        ),
      ),
    );
    expect(logs, [('last diagnostic', 'stderr')]);
    await expectClosed();
  });

  test(
    'rejects a connection closed before exit and retains final output',
    () async {
      frames = [_output('stdout', utf8.encode('partial output'))];
      closeBeforeExit = true;
      await expectLater(
        execute(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('closed before exit'),
          ),
        ),
      );
      expect(logs, [('partial output', 'stdout')]);
      await expectClosed();
    },
  );

  test('closes the socket when the log callback throws', () async {
    frames = [_output('stdout', utf8.encode('line\n'))];
    final error = StateError('log consumer failed');
    await expectLater(
      execute(onLog: (_, _) => throw error),
      throwsA(same(error)),
    );
    await expectClosed();
  });

  test('propagates a rejected WebSocket handshake without logging', () async {
    rejectUpgrade = true;
    await expectLater(execute(), throwsA(isA<WebSocketException>()));
    expect(logs, isEmpty);
    expect(sockets, isEmpty);
  });
}

String _output(String stream, List<int> bytes) =>
    jsonEncode({'type': stream, 'data': base64Encode(bytes)});
