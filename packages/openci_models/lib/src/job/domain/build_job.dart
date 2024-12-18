import 'package:dart_firebase_admin/firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/src/converters/timestamp_converter.dart';

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
