import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:openci_runner/src/github/get_github_installation_token.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'get_github_installation_token_test.mocks.dart';

void main() {
  group('getGitHubInstallationToken', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    test('throws ArgumentError when privateKey is empty', () async {
      expect(
        () => getGitHubInstallationToken(
          installationId: 123,
          appId: 456,
          privateKey: '',
          client: mockClient,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when installationId is invalid', () async {
      expect(
        () => getGitHubInstallationToken(
          installationId: 0,
          appId: 456,
          privateKey: 'test_private_key',
          client: mockClient,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws GitHubError when API returns error', () async {
      // Arrange
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          '{"message": "Bad credentials"}',
          401,
        ),
      );

      // Act & Assert
      expect(
        () => getGitHubInstallationToken(
          installationId: 123,
          appId: 456,
          privateKey: 'test_private_key',
          client: mockClient,
        ),
        throwsA(isA<GitHubError>()),
      );
    });
  });
  group('GitHubError', () {
    test('toString returns correct format', () {
      // Arrange
      const statusCode = 404;
      const message = 'Not Found';
      final error = GitHubError(statusCode, message);

      // Act
      final result = error.toString();

      // Assert
      expect(result, equals('GitHubError: 404 - Not Found'));
    });
  });

  group('createJWT', () {
    const testAppId = 123456;

    test('throws ArgumentError when privateKey is invalid', () {
      // Act & Assert
      expect(
        () => createJWT(
          appId: testAppId,
          privateKey: 'invalid-key',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
