import 'package:dart_firebase_admin/firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:runner/src/features/build_job/models/job_status.dart';

part 'build_job.freezed.dart';
part 'build_job.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
      );

  @override
  Timestamp toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

@freezed
class BuildJob with _$BuildJob {
  const factory BuildJob({
    required String id,
    @TimestampConverter() required DateTime createdAt,
    required JobStatus status,
  }) = _BuildJob;
  factory BuildJob.fromJson(Map<String, Object?> json) =>
      _$BuildJobFromJson(json);
}
