import 'package:uuid/uuid.dart';

class UuidService {
  static String generateV4() {
    return const Uuid().v4();
  }
}
