import 'package:openci_shared/openci_shared.dart';
import 'package:test/test.dart';

void main() {
  test('uses secure WebSockets for an HTTPS server', () {
    expect(
      buildWebSocketUri('https://api.openci.test', '/builds/commits/stream'),
      Uri.parse('wss://api.openci.test/builds/commits/stream'),
    );
  });

  test('preserves the port of a local HTTP server', () {
    expect(
      buildWebSocketUri('http://localhost:8080', '/worker/jobs/stream'),
      Uri.parse('ws://localhost:8080/worker/jobs/stream'),
    );
  });

  test('preserves an explicit HTTPS port and encodes query values', () {
    final uri = buildWebSocketUri(
      'https://api.openci.test:8443/old-path?old=value#fragment',
      '/builds/commits/stream',
      queryParameters: {'teamId': 'team / one', 'token': 'value+with&symbols='},
    );

    expect(uri.scheme, 'wss');
    expect(uri.host, 'api.openci.test');
    expect(uri.port, 8443);
    expect(uri.path, '/builds/commits/stream');
    expect(Uri.parse(uri.toString()).queryParameters, {
      'teamId': 'team / one',
      'token': 'value+with&symbols=',
    });
    expect(uri.hasFragment, isFalse);
  });

  test('omits the query delimiter when parameters are empty', () {
    final uri = buildWebSocketUri(
      'https://api.openci.test',
      '/builds/commits/stream',
      queryParameters: {},
    );

    expect(uri.hasQuery, isFalse);
    expect(uri.toString(), 'wss://api.openci.test/builds/commits/stream');
  });
}
