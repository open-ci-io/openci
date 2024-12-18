import 'package:dart_firebase_admin/firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, Timestamp> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Timestamp timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

  @override
  Timestamp toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}
