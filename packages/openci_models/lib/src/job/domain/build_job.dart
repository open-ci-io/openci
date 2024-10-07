import 'package:dart_firebase_admin/firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'build_job.freezed.dart';
part 'build_job.g.dart';

enum OpenCIGitHubChecksStatus {
  queued,
  inProgress,
  failure,
  success,
}

@freezed
class BuildJob with _$BuildJob {
  const factory BuildJob({
    required OpenCIGitHubChecksStatus buildStatus,
    required OpenCIGithub github,
    required String id,
    required String workflowId,
    @TimestampConverter() @Default(null) Timestamp? createdAt,
  }) = _BuildJob;

  factory BuildJob.fromJson(Map<String, dynamic> json) =>
      _$BuildJobFromJson(json);
}

@freezed
class OpenCIGithub with _$OpenCIGithub {
  const factory OpenCIGithub({
    required String repositoryUrl,
    required String owner,
    required String repositoryName,
    required int installationId,
    required int appId,
    required int checkRunId,
    @Default(null) int? issueNumber,
    required String baseBranch,
    required String buildBranch,
  }) = _OpenCIGithub;

  factory OpenCIGithub.fromJson(Map<String, dynamic> json) =>
      _$OpenCIGithubFromJson(json);
}

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
