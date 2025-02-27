import 'package:dashboard/src/services/app_store_connect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getASCKeyId', () {
    test('extracts key ID from correctly formatted filename', () {
      // Arrange
      const fileName = 'AuthKey_TVVJSBM7TY.p8';

      // Act
      final result = getASCKeyId(fileName);

      // Assert
      expect(result, 'TVVJSBM7TY');
    });

    test('extracts different key IDs correctly', () {
      // Arrange
      const fileName = 'AuthKey_ABC123XYZ9.p8';

      // Act
      final result = getASCKeyId(fileName);

      // Assert
      expect(result, 'ABC123XYZ9');
    });

    test('extracts key ID from filename with (1) etc.', () {
      // Arrange
      const fileName = 'AuthKey_1234567890(1).p8';

      // Act
      final result = getASCKeyId(fileName);

      // Assert
      expect(result, '1234567890');
    });
  });
}
