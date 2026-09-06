import 'dart:convert';
import 'dart:io';

import 'package:build_job_worker/build_job_worker.dart';
import 'package:test/test.dart';

void main() {
  late Directory workspace;
  late OrchardApiClient api;
  late Future<void> serverDone;

  setUp(() async {
    workspace = await Directory.systemTemp.createTemp('worker-write-file-');
    addTearDown(() => workspace.delete(recursive: true));
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    api = OrchardApiClient(
      config: Config(
        serverUrl: 'http://server:8080',
        internalApiKey: 'test-api-key',
        orchardApiUrl: 'http://127.0.0.1:${server.port}',
        orchardServiceAccountName: 'worker',
        orchardServiceAccountToken: 'orchard-token',
      ),
    );
    addTearDown(api.close);
    serverDone = _serveWrite(server, workspace.path);
  });

  Future<void> write({
    required String filePath,
    required String content,
    String? mode,
  }) async {
    try {
      await writeFile(
        api: api,
        vmName: 'vm-1',
        filePath: filePath,
        content: content,
        mode: mode,
      );
    } finally {
      await serverDone;
    }
  }

  group('writeFile over WebSocket', () {
    test(
      'creates parents and preserves UTF-8, newlines, and shell literals',
      () async {
        final file = File('${workspace.path}/nested/workspace/.env');
        const content =
            r'''SECRET="日本語 🚀"
LITERAL='$HOME $(touch injected) `touch injected` %s'
'''
            '\r\n\u0000last line';

        await write(filePath: file.path, content: content);

        expect(await file.readAsBytes(), utf8.encode(content));
        expect((await file.stat()).mode & 0x49, 0);
        expect(await File('${workspace.path}/injected').exists(), isFalse);
      },
    );

    test(
      'handles relative paths containing shell syntax and leading hyphens',
      () async {
        const filePath =
            r'''-dir ' " $(touch injected) `touch injected`/file ' " $(touch injected) `touch injected`.txt''';

        await write(filePath: filePath, content: 'literal path');

        expect(
          await File('${workspace.path}/$filePath').readAsString(),
          'literal path',
        );
        expect(await File('${workspace.path}/injected').exists(), isFalse);
      },
    );

    for (final content in ['', 'replacement']) {
      test('replaces an existing file with ${content.length} bytes', () async {
        final file = File('${workspace.path}/existing');
        await file.writeAsString('previous longer content');

        await write(filePath: 'existing', content: content);

        expect(await file.readAsString(), content);
      });
    }

    for (final mode in ['+x', '600']) {
      test('applies chmod mode $mode', () async {
        final file = File('${workspace.path}/script.sh');

        await write(filePath: file.path, content: 'exit 0\n', mode: mode);

        final permissions = (await file.stat()).mode;
        if (mode == '+x') {
          expect(permissions & 0x40, 0x40);
        } else {
          expect(permissions & 0x1ff, 0x180);
        }
      });
    }

    test('reports failure to create a parent directory', () async {
      final parent = File('${workspace.path}/parent');
      await parent.writeAsString('existing file');

      await expectLater(
        write(filePath: '${parent.path}/file', content: 'new content'),
        throwsStateError,
      );

      expect(await parent.readAsString(), 'existing file');
    });

    test('reports failure to write to a directory', () async {
      await expectLater(
        write(filePath: workspace.path, content: 'new content'),
        throwsStateError,
      );
    });

    test(
      'reports invalid chmod modes without executing their contents',
      () async {
        await expectLater(
          write(
            filePath: 'file',
            content: 'new content',
            mode: '+x; touch injected',
          ),
          throwsStateError,
        );

        expect(await File('${workspace.path}/injected').exists(), isFalse);
      },
    );
  }, timeout: const Timeout(Duration(seconds: 5)));
}

Future<void> _serveWrite(HttpServer server, String workingDirectory) async {
  final request = await server.first;
  final socket = await WebSocketTransformer.upgrade(request);
  addTearDown(() => socket.close());
  final closed = socket.drain<void>();
  final result = await Process.run('/bin/sh', [
    '-c',
    request.uri.queryParameters['command']!,
  ], workingDirectory: workingDirectory);
  for (final (stream, output) in [
    ('stdout', result.stdout as String),
    ('stderr', result.stderr as String),
  ]) {
    socket.add(
      jsonEncode({'type': stream, 'data': base64Encode(utf8.encode(output))}),
    );
  }
  socket.add(
    jsonEncode({
      'type': 'exit',
      'exit': {'code': result.exitCode},
    }),
  );
  await closed;
}
