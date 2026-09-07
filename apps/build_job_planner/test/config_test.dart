import 'package:build_job_planner/src/config.dart';
import 'package:test/test.dart';

void main() {
  const requiredEnvironment = {
    'OPENCI_SERVER_URL': 'https://ci.example.test/api',
    'INTERNAL_API_KEY': 'planner-test-key',
  };

  test('loads required settings without requiring Sentry', () {
    final config = Config.fromEnvironment(environment: requiredEnvironment);

    expect(config.serverUrl, 'https://ci.example.test/api');
    expect(config.internalApiKey, 'planner-test-key');
    expect(config.sentryDsn, isNull);
  });

  test('loads the optional Sentry DSN', () {
    final config = Config.fromEnvironment(
      environment: {
        ...requiredEnvironment,
        'SENTRY_DSN': 'https://public@sentry.example.test/1',
      },
    );

    expect(config.sentryDsn, 'https://public@sentry.example.test/1');
  });

  for (final key in requiredEnvironment.keys) {
    for (final value in [null, '']) {
      test('rejects a missing or empty $key: $value', () {
        final environment = {...requiredEnvironment}..remove(key);
        if (value != null) environment[key] = value;

        expect(
          () => Config.fromEnvironment(environment: environment),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              'Required environment variable $key is not set.',
            ),
          ),
        );
      });
    }
  }
}
