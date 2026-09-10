import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import '../../routes/_middleware.dart';
import '../../routes/internal/build_jobs.dart' as build_jobs;
import '../../routes/internal/seed/index.dart' as seed;
import '../../routes/internal/seed/jobs.dart' as seed_jobs;
import '../../routes/internal/seed/teams.dart' as seed_teams;

void main() {
  group('internalRoutesMiddleware', () {
    for (final (path, method, route) in <(String, HttpMethod, Handler)>[
      ('/internal/build_jobs', HttpMethod.delete, build_jobs.onRequest),
      ('/internal/seed', HttpMethod.post, seed.onRequest),
      ('/internal/seed/teams', HttpMethod.post, seed_teams.onRequest),
      ('/internal/seed/jobs', HttpMethod.post, seed_jobs.onRequest),
      ('/internal/seed/jobs', HttpMethod.delete, seed_jobs.onRequest),
    ]) {
      test(
        'blocks ${method.name} $path before accessing the database',
        () async {
          final context = TestRequestContext(path: path, method: method);
          final handler = internalRoutesMiddleware(environment: const {})(
            route,
          );

          final response = await handler(context.context);

          expect(response.statusCode, HttpStatus.notFound);
        },
      );
    }

    for (final value in [null, '', 'false', 'TRUE', '1', ' true ', 'invalid']) {
      test(
        'disables internal routes when ENABLE_INTERNAL_API is $value',
        () async {
          final context = TestRequestContext(path: '/internal/seed');
          final handler = internalRoutesMiddleware(
            environment: {'ENABLE_INTERNAL_API': ?value},
          )((_) => throw StateError('Disabled route must not run'));

          final response = await handler(context.context);

          expect(response.statusCode, HttpStatus.notFound);
          expect(await response.body(), isEmpty);
        },
      );
    }

    for (final method in HttpMethod.values) {
      test('blocks ${method.name} even with an internal API key', () async {
        final context = TestRequestContext(
          path: '/internal/seed/jobs',
          method: method,
          headers: {'Authorization': 'Bearer test-internal-key'},
        );
        final handler = internalRoutesMiddleware(
          environment: const {'INTERNAL_API_KEY': 'test-internal-key'},
        )((_) => throw StateError('Disabled route must not run'));

        final response = await handler(context.context);

        expect(response.statusCode, HttpStatus.notFound);
      });
    }

    test('covers the internal root and future nested routes', () async {
      final handler = internalRoutesMiddleware(environment: const {})(
        (_) => throw StateError('Disabled route must not run'),
      );

      for (final path in ['/internal', '/internal/', '/internal/new/nested']) {
        final context = TestRequestContext(path: path);
        expect(
          (await handler(context.context)).statusCode,
          HttpStatus.notFound,
          reason: path,
        );
      }
    });

    test(
      'preserves the handler and response when explicitly enabled',
      () async {
        final context = TestRequestContext(
          path: '/internal/seed',
          method: HttpMethod.post,
        ).context;
        final expected = Response(
          statusCode: HttpStatus.created,
          body: 'seeded',
        );
        var calls = 0;
        final handler =
            internalRoutesMiddleware(
              environment: const {'ENABLE_INTERNAL_API': 'true'},
            )((actualContext) {
              calls++;
              expect(actualContext, same(context));
              return expected;
            });

        expect(await handler(context), same(expected));
        expect(calls, 1);
      },
    );

    test('preserves routes outside the internal path segment', () async {
      final expected = Response(statusCode: HttpStatus.accepted);
      final handler = internalRoutesMiddleware(environment: const {})(
        (_) => expected,
      );

      for (final path in [
        '/',
        '/webhook',
        '/webhooks/claim',
        '/builds/claim',
        '/teams',
        '/internal-other',
      ]) {
        final context = TestRequestContext(path: path);
        expect(await handler(context.context), same(expected), reason: path);
      }
    });

    test(
      'rejects disabled routes before CORS can answer a preflight',
      () async {
        final context = TestRequestContext(
          path: '/internal/seed',
          method: HttpMethod.options,
          headers: {'Origin': 'https://dashboard.openci.org'},
        );
        Handler handler = (_) =>
            throw StateError('Disabled route must not run');
        handler = handler
            .use(corsMiddleware(environment: const {}))
            .use(internalRoutesMiddleware(environment: const {}));

        final response = await handler(context.context);

        expect(response.statusCode, HttpStatus.notFound);
        expect(
          response.headers,
          isNot(contains('Access-Control-Allow-Origin')),
        );
      },
    );
  });
}
