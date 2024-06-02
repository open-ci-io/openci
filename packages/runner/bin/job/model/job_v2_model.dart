import 'package:dart_firebase_admin/firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../workflow/model/workflow_model.dart';

part 'job_v2_model.freezed.dart';
part 'job_v2_model.g.dart';

@freezed
class BuildStatus with _$BuildStatus {
  const factory BuildStatus({
    @Default(false) bool processing,
    @Default(false) bool failure,
    @Default(false) bool success,
  }) = _BuildStatus;

  factory BuildStatus.fromJson(Map<String, dynamic> json) =>
      _$BuildStatusFromJson(json);
}

@freezed
class Branch with _$Branch {
  const factory Branch({
    required String baseBranch,
    required String buildBranch,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}

@freezed
class GithubChecks with _$GithubChecks {
  const factory GithubChecks({
    required int checkRunId,
    @Default(null) int? issueNumber,
  }) = _GithubChecks;

  factory GithubChecks.fromJson(Map<String, dynamic> json) =>
      _$GithubChecksFromJson(json);
}

@freezed
class Github with _$Github {
  const factory Github({
    required String repositoryUrl,
    required String owner,
    required String repositoryName,
    required int installationId,
    required int appId,
  }) = _Github;

  factory Github.fromJson(Map<String, dynamic> json) => _$GithubFromJson(json);
}

@freezed
class JobV2Model with _$JobV2Model {
  const factory JobV2Model({
    required BuildStatus buildStatus,
    required Branch branch,
    required GithubChecks githubChecks,
    required Github github,
    required String documentId,
    required TargetPlatform platform,
    required String workflowId,
    @TimestampConverter() @Default(null) Timestamp? createdAt,
  }) = _JobV2Model;

  factory JobV2Model.fromJson(Map<String, dynamic> json) =>
      _$JobV2ModelFromJson(json);
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
