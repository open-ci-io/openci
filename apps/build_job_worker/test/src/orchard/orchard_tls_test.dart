import 'dart:io';

import 'package:build_job_worker/build_job_worker.dart';
import 'package:test/test.dart';

class _RecordingHttpClient implements HttpClient {
  @override
  bool Function(X509Certificate, String, int)? badCertificateCallback;

  bool closed = false;

  @override
  void close({bool force = false}) => closed = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Certificate implements X509Certificate {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'accepts local certificates only for the configured Orchard host and port',
    () {
      final client = _RecordingHttpClient();
      final api = HttpOverrides.runZoned(
        () => OrchardApiClient(
          config: const Config(
            serverUrl: 'http://localhost:8080',
            internalApiKey: 'test-key',
            orchardApiUrl: 'https://orchard-controller:6120',
            orchardServiceAccountName: 'worker',
            orchardServiceAccountToken: 'test-token',
          ),
        ),
        createHttpClient: (_) => client,
      );
      addTearDown(api.close);

      final accept = client.badCertificateCallback!;
      final certificate = _Certificate();
      expect(accept(certificate, 'orchard-controller', 6120), isTrue);
      expect(accept(certificate, 'other-host', 6120), isFalse);
      expect(accept(certificate, 'orchard-controller', 443), isFalse);
      expect(
        accept(certificate, 'orchard-controller.example.test', 6120),
        isFalse,
      );
    },
  );
}
