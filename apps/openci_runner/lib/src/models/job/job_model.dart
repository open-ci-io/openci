import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required int id,
    required DateTime created_at,
    required DateTime updated_at,
    required JobStatus status,
    required String github_org_name,
    required String github_repo_name,
    required int workflow_run_id,
    required int github_installation_id,
  }) = _JobModel;
  factory JobModel.fromJson(Map<String, Object?> json) =>
      _$JobModelFromJson(json);
}

enum JobStatus {
  queued,
  processing,
  completed,
}
