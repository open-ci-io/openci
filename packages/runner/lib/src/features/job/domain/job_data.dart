import 'package:dart_firebase_admin/firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_data.freezed.dart';
part 'job_data.g.dart';

@freezed
class JobData with _$JobData {
  const factory JobData({
    required String buildBranch,
    required String documentId,
    required String githubRepositoryUrl,
    required String baseBranch,
    required String githubPAT,
    required TargetPlatform platform,
    required String userId,
  }) = _JobData;

  factory JobData.fromJson(Map<String, Object?> json) =>
      _$JobDataFromJson(json);
}

enum TargetPlatform {
  android,
  ios,
}

@freezed
class JobModelV2 with _$JobModelV2 {
  const factory JobModelV2({
    required String baseBranch,
    required String buildBranch,
    // ignore: non_constant_identifier_names
    required String PAT,
    required String repositoryUrl,
    required TargetPlatform platform,
    required String workflowId,
    required Checks checks, // Default values when not provided
    @Default(BuildStatus(processing: false, failure: false, success: false))
    BuildStatus buildStatus,
    int? issueNumber,
    @TimestampConverter() @Default(null) Timestamp? createdAt,
    String? documentId,
  }) = _BuildModel;

  factory JobModelV2.fromJson(Map<String, dynamic> json) =>
      _$JobModelV2FromJson(json);
}

@freezed
class BuildStatus with _$BuildStatus {
  const factory BuildStatus({
    required bool processing,
    required bool failure,
    required bool success,
  }) = _BuildStatus;

  factory BuildStatus.fromJson(Map<String, dynamic> json) =>
      _$BuildStatusFromJson(json);
}

@freezed
class Checks with _$Checks {
  const factory Checks({
    required int checkRunId,
    required String owner,
    required String repositoryName,
    required int installationId,
    required String jobId,
  }) = _Checks;

  factory Checks.fromJson(Map<String, dynamic> json) => _$ChecksFromJson(json);
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
