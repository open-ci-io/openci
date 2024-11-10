import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    test('responds with not implemented message', () async {
      // Arrange
      final context = _MockRequestContext();

      // Act
      final response = await route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(200));
      expect(
        await response.body(),
        equals('Root path is not implemented yet'),
      );
    });
  });
}
