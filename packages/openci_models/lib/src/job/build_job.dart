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
abstract class BuildJob with _$BuildJob {
  const factory BuildJob({
    required OpenCIGitHubChecksStatus buildStatus,
    required OpenCIGithub github,
    required String id,
    required String workflowId,
    @Default(null) int? createdAt,
  }) = _BuildJob;

  factory BuildJob.fromJson(Map<String, dynamic> json) =>
      _$BuildJobFromJson(json);
}

@freezed
abstract class OpenCIGithub with _$OpenCIGithub {
  OpenCIGithub._();
  const factory OpenCIGithub({
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

  String get repoFullName => 'https://github.com/$owner/$repositoryName';
}
