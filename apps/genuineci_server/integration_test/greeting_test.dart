import 'package:genuineci_api_client/genuineci_api_client.dart' as api;
import 'package:genuineci_server/src/generated/serverpod.dart';
import 'package:test/test.dart';

void main() {
  test('serves Hello world over HTTP', () async {
    final pod = Serverpod(['--mode=test']);
    addTearDown(() => pod.shutdown(exitProcess: false));
    await pod.start(runInGuardedZone: false);

    final client = api.Client('http://127.0.0.1:${pod.server.port}/');
    addTearDown(client.close);

    expect(await client.greeting.hello(), 'Hello world');
  });
}
