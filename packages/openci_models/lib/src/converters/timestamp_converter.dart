import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<Timestamp, Object> {
  const TimestampConverter();
  @override
  Timestamp fromJson(Object json) {
    if (json is Timestamp) {
      return json;
    }
    if (json is Map<String, dynamic>) {
      final seconds = json['seconds'] as int;
      return Timestamp.fromMillis(seconds * 1000);
    }
    throw Exception('Incompatible Timestamp format');
  }

  @override
  Object toJson(Timestamp timestamp) => timestamp;
}
