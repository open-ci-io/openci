import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:drift/native.dart';
import 'package:firebase_admin_sdk/auth.dart';
import 'package:firebase_admin_sdk/firebase_admin_sdk.dart';
import 'package:mocktail/mocktail.dart';
import 'package:openci_server/database.dart';
import 'package:test/test.dart';

import '../../routes/_middleware.dart';

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockAuth extends Mock implements Auth {}

class MockDecodedIdToken extends Mock implements DecodedIdToken {}

class MockRequestContext extends Mock implements RequestContext {}

class MockRequest extends Mock implements Request {}

void main() {
  setUpAll(() {
    registerFallbackValue(() => 'dummy');
  });

  test(
    'databaseProvider makes the same database available downstream',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final context = MockRequestContext();
      registerFallbackValue(() => db);
      when(() => context.provide<AppDatabase>(any())).thenAnswer((invocation) {
        final create =
            invocation.positionalArguments.single as AppDatabase Function();
        expect(create(), same(db));
        return context;
      });
      final handler = databaseProvider(db)(
        (_) => Response(statusCode: 201, body: 'created'),
      );
      final response = await handler(context);
      expect(response.statusCode, 201);
      expect(await response.body(), 'created');
    },
  );

  group('sentryMiddleware', () {
    test('preserves a successful downstream response', () async {
      final context = TestRequestContext(path: '/');
      final expected = Response(statusCode: 202, body: 'accepted');
      final handler = sentryMiddleware()((_) => expected);
      expect(await handler(context.context), same(expected));
    });

    test(
      'returns a generic error without exposing exception details',
      () async {
        final context = TestRequestContext(path: '/');
        final handler = sentryMiddleware()((_) async {
          throw StateError('private exception detail');
        });
        final response = await handler(context.context);
        expect(response.statusCode, HttpStatus.internalServerError);
        expect(await response.json(), {
          'success': false,
          'error': 'Internal server error',
        });
      },
    );

    test('propagates hijack exceptions for streaming responses', () async {
      final context = TestRequestContext(path: '/');
      final error = StateError('request hijack');
      final handler = sentryMiddleware()((_) async => throw error);
      await expectLater(handler(context.context), throwsA(same(error)));
    });
  });

  group('corsMiddleware', () {
    late MockRequestContext mockContext;
    late MockRequest mockRequest;

    setUp(() {
      mockContext = MockRequestContext();
      mockRequest = MockRequest();
      when(() => mockContext.request).thenReturn(mockRequest);
    });

    test(
      'OPTIONS request returns 200 with CORS headers for allowed origin',
      () async {
        final middleware = corsMiddleware(
          environment: {'ALLOWED_ORIGINS': 'https://custom.example.com'},
        );
        final handler = middleware((context) => Response());

        when(() => mockRequest.method).thenReturn(HttpMethod.options);
        when(() => mockRequest.headers).thenReturn({
          'Origin': 'https://custom.example.com',
        });

        final response = await handler(mockContext);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          response.headers['Access-Control-Allow-Origin'],
          equals('https://custom.example.com'),
        );
        expect(
          response.headers['Access-Control-Allow-Credentials'],
          equals('true'),
        );
      },
    );

    test('GET request adds CORS headers for allowed origin', () async {
      final middleware = corsMiddleware(
        environment: {'ALLOWED_ORIGINS': 'https://custom.example.com'},
      );
      final handler = middleware((context) => Response(body: 'ok'));

      when(() => mockRequest.method).thenReturn(HttpMethod.get);
      when(() => mockRequest.headers).thenReturn({
        'Origin': 'https://custom.example.com',
      });

      final response = await handler(mockContext);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.headers['Access-Control-Allow-Origin'],
        equals('https://custom.example.com'),
      );
    });

    test(
      'GET request does not add CORS headers for disallowed origin',
      () async {
        final middleware = corsMiddleware(
          environment: {'ALLOWED_ORIGINS': 'https://custom.example.com'},
        );
        final handler = middleware((context) => Response(body: 'ok'));

        when(() => mockRequest.method).thenReturn(HttpMethod.get);
        when(() => mockRequest.headers).thenReturn({
          'Origin': 'https://evil.com',
        });

        final response = await handler(mockContext);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.headers['Access-Control-Allow-Origin'], isNull);
      },
    );
  });

  group('authProvider', () {
    late MockRequestContext mockContext;
    late MockRequest mockRequest;
    late MockFirebaseApp mockFirebaseApp;
    late MockAuth mockAuth;
    late MockDecodedIdToken mockToken;

    setUp(() {
      mockContext = MockRequestContext();
      mockRequest = MockRequest();
      mockFirebaseApp = MockFirebaseApp();
      mockAuth = MockAuth();
      mockToken = MockDecodedIdToken();

      when(() => mockContext.request).thenReturn(mockRequest);
      when(() => mockRequest.headers).thenReturn({});
      when(() => mockContext.provide<String?>(any())).thenReturn(mockContext);
    });

    test(
      'provides test-uid when firebaseApp is null and allowTestUid is true',
      () async {
        final middleware = authProvider(null, allowTestUid: true);

        when(
          () => mockRequest.uri,
        ).thenReturn(Uri.parse('http://localhost/teams'));

        var handlerCalled = false;
        final handler = middleware((context) {
          handlerCalled = true;
          return Response();
        });

        await handler(mockContext);
        expect(handlerCalled, isTrue);

        final captured =
            verify(
                  () => mockContext.provide<String?>(captureAny()),
                ).captured.single
                as String? Function();
        expect(captured(), equals('test-uid'));
      },
    );

    test(
      'provides null when firebaseApp is null and allowTestUid is false',
      () async {
        final middleware = authProvider(null, allowTestUid: false);

        when(
          () => mockRequest.uri,
        ).thenReturn(Uri.parse('http://localhost/teams'));

        var handlerCalled = false;
        final handler = middleware((context) {
          handlerCalled = true;
          return Response();
        });

        await handler(mockContext);
        expect(handlerCalled, isTrue);

        final captured =
            verify(
                  () => mockContext.provide<String?>(captureAny()),
                ).captured.single
                as String? Function();
        expect(captured(), isNull);
      },
    );

    test('provides null when path is root (/)', () async {
      final middleware = authProvider(null);

      when(() => mockRequest.uri).thenReturn(Uri.parse('http://localhost/'));

      var handlerCalled = false;
      final handler = middleware((context) {
        handlerCalled = true;
        return Response();
      });

      await handler(mockContext);
      expect(handlerCalled, isTrue);

      final captured =
          verify(
                () => mockContext.provide<String?>(captureAny()),
              ).captured.single
              as String? Function();
      expect(captured(), isNull);
    });

    test('provides uid when valid token is provided via FirebaseApp', () async {
      when(() => mockFirebaseApp.auth()).thenReturn(mockAuth);
      when(
        () => mockAuth.verifyIdToken(
          any(),
          checkRevoked: any(named: 'checkRevoked'),
        ),
      ).thenAnswer((_) async => mockToken);
      when(() => mockToken.uid).thenReturn('user-firebase-123');

      final middleware = authProvider(mockFirebaseApp);

      when(
        () => mockRequest.uri,
      ).thenReturn(Uri.parse('http://localhost/teams'));
      when(() => mockRequest.headers).thenReturn({
        'Authorization': 'Bearer valid-token',
      });

      var handlerCalled = false;
      final handler = middleware((context) {
        handlerCalled = true;
        return Response();
      });

      await handler(mockContext);
      expect(handlerCalled, isTrue);

      final captured =
          verify(
                () => mockContext.provide<String?>(captureAny()),
              ).captured.single
              as String? Function();
      expect(captured(), equals('user-firebase-123'));
    });

    test('does not retry an authenticated handler when it throws', () async {
      when(() => mockFirebaseApp.auth()).thenReturn(mockAuth);
      when(
        () => mockAuth.verifyIdToken('valid-token', checkRevoked: false),
      ).thenAnswer((_) async => mockToken);
      when(() => mockToken.uid).thenReturn('user-1');
      when(
        () => mockRequest.uri,
      ).thenReturn(Uri.parse('http://localhost/teams'));
      when(() => mockRequest.headers).thenReturn({
        'authorization': 'Bearer valid-token',
      });
      final error = StateError('downstream request failed');
      var handlerCalls = 0;
      final handler = authProvider(mockFirebaseApp)((_) async {
        handlerCalls++;
        throw error;
      });

      await expectLater(handler(mockContext), throwsA(same(error)));
      expect(handlerCalls, 1);
      final captured =
          verify(
                () => mockContext.provide<String?>(captureAny()),
              ).captured.single
              as String? Function();
      expect(captured(), 'user-1');
    });

    test(
      'provides null when invalid token is provided via FirebaseApp',
      () async {
        when(() => mockFirebaseApp.auth()).thenReturn(mockAuth);
        when(
          () => mockAuth.verifyIdToken(
            any(),
            checkRevoked: any(named: 'checkRevoked'),
          ),
        ).thenThrow(Exception('Token invalid'));

        final middleware = authProvider(mockFirebaseApp);

        when(
          () => mockRequest.uri,
        ).thenReturn(Uri.parse('http://localhost/teams'));
        when(() => mockRequest.headers).thenReturn({
          'Authorization': 'Bearer invalid-token',
        });

        var handlerCalled = false;
        final handler = middleware((context) {
          handlerCalled = true;
          return Response();
        });

        await handler(mockContext);
        expect(handlerCalled, isTrue);

        final captured =
            verify(
                  () => mockContext.provide<String?>(captureAny()),
                ).captured.single
                as String? Function();
        expect(captured(), isNull);
      },
    );

    test('provides null when Authorization header is missing', () async {
      final middleware = authProvider(mockFirebaseApp);

      when(
        () => mockRequest.uri,
      ).thenReturn(Uri.parse('http://localhost/teams'));
      when(() => mockRequest.headers).thenReturn({});

      var handlerCalled = false;
      final handler = middleware((context) {
        handlerCalled = true;
        return Response();
      });

      await handler(mockContext);
      expect(handlerCalled, isTrue);

      final captured =
          verify(
                () => mockContext.provide<String?>(captureAny()),
              ).captured.single
              as String? Function();
      expect(captured(), isNull);
    });

    test(
      'provides system-job-processor when Authorization header matches INTERNAL_API_KEY',
      () async {
        final middleware = authProvider(null);

        when(
          () => mockRequest.uri,
        ).thenReturn(Uri.parse('http://localhost/teams'));
        when(() => mockRequest.headers).thenReturn({
          'Authorization': 'Bearer my-internal-key',
        });
        when(
          () => mockContext.read<Map<String, String>>(),
        ).thenReturn({'INTERNAL_API_KEY': 'my-internal-key'});

        var handlerCalled = false;
        final handler = middleware((context) {
          handlerCalled = true;
          return Response();
        });

        await handler(mockContext);
        expect(handlerCalled, isTrue);

        final captured =
            verify(
                  () => mockContext.provide<String?>(captureAny()),
                ).captured.single
                as String? Function();
        expect(captured(), equals('system-job-processor'));
      },
    );

    test(
      'provides null when Authorization header does not match INTERNAL_API_KEY',
      () async {
        final middleware = authProvider(null);

        when(
          () => mockRequest.uri,
        ).thenReturn(Uri.parse('http://localhost/teams'));
        when(() => mockRequest.headers).thenReturn({
          'Authorization': 'Bearer wrong-internal-key',
        });
        when(
          () => mockContext.read<Map<String, String>>(),
        ).thenReturn({'INTERNAL_API_KEY': 'my-internal-key'});

        var handlerCalled = false;
        final handler = middleware((context) {
          handlerCalled = true;
          return Response();
        });

        await handler(mockContext);
        expect(handlerCalled, isTrue);

        final captured =
            verify(
                  () => mockContext.provide<String?>(captureAny()),
                ).captured.single
                as String? Function();
        expect(captured(), isNull);
      },
    );
  });
}
