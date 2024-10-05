import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:runner/src/features/build_job/models/job_status.dart';

part 'build_job.freezed.dart';
part 'build_job.g.dart';

@freezed
class BuildJob with _$BuildJob {
  const factory BuildJob({
    required int id,
    required DateTime createdAt,
    required JobStatus statusV2,
  }) = _BuildJob;
  factory BuildJob.fromJson(Map<String, Object?> json) =>
      _$BuildJobFromJson(json);
}
