import 'package:uuid/uuid.dart';

// ignore: avoid_classes_with_only_static_members
class UuidService {
  static String generateV4() {
    return const Uuid().v4();
  }
}
