// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobDataImpl _$$JobDataImplFromJson(Map<String, dynamic> json) =>
    _$JobDataImpl(
      buildBranch: json['buildBranch'] as String,
      documentId: json['documentId'] as String,
      githubRepositoryUrl: json['githubRepositoryUrl'] as String,
      baseBranch: json['baseBranch'] as String,
      githubPAT: json['githubPAT'] as String,
      platform: $enumDecode(_$TargetPlatformEnumMap, json['platform']),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$JobDataImplToJson(_$JobDataImpl instance) =>
    <String, dynamic>{
      'buildBranch': instance.buildBranch,
      'documentId': instance.documentId,
      'githubRepositoryUrl': instance.githubRepositoryUrl,
      'baseBranch': instance.baseBranch,
      'githubPAT': instance.githubPAT,
      'platform': _$TargetPlatformEnumMap[instance.platform]!,
      'userId': instance.userId,
    };

const _$TargetPlatformEnumMap = {
  TargetPlatform.android: 'android',
  TargetPlatform.ios: 'ios',
};

_$BuildModelImpl _$$BuildModelImplFromJson(Map<String, dynamic> json) =>
    _$BuildModelImpl(
      baseBranch: json['baseBranch'] as String,
      buildBranch: json['buildBranch'] as String,
      PAT: json['PAT'] as String,
      repositoryUrl: json['repositoryUrl'] as String,
      platform: $enumDecode(_$TargetPlatformEnumMap, json['platform']),
      workflowId: json['workflowId'] as String,
      checks: Checks.fromJson(json['checks'] as Map<String, dynamic>),
      buildStatus: json['buildStatus'] == null
          ? const BuildStatus(processing: false, failure: false, success: false)
          : BuildStatus.fromJson(json['buildStatus'] as Map<String, dynamic>),
      issueNumber: json['issueNumber'] as int?,
      createdAt: _$JsonConverterFromJson<Object, Timestamp>(
              json['createdAt'], const TimestampConverter().fromJson) ??
          null,
      documentId: json['documentId'] as String?,
    );

Map<String, dynamic> _$$BuildModelImplToJson(_$BuildModelImpl instance) =>
    <String, dynamic>{
      'baseBranch': instance.baseBranch,
      'buildBranch': instance.buildBranch,
      'PAT': instance.PAT,
      'repositoryUrl': instance.repositoryUrl,
      'platform': _$TargetPlatformEnumMap[instance.platform]!,
      'workflowId': instance.workflowId,
      'checks': instance.checks,
      'buildStatus': instance.buildStatus,
      'issueNumber': instance.issueNumber,
      'createdAt': _$JsonConverterToJson<Object, Timestamp>(
          instance.createdAt, const TimestampConverter().toJson),
      'documentId': instance.documentId,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$BuildStatusImpl _$$BuildStatusImplFromJson(Map<String, dynamic> json) =>
    _$BuildStatusImpl(
      processing: json['processing'] as bool,
      failure: json['failure'] as bool,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$BuildStatusImplToJson(_$BuildStatusImpl instance) =>
    <String, dynamic>{
      'processing': instance.processing,
      'failure': instance.failure,
      'success': instance.success,
    };

_$ChecksImpl _$$ChecksImplFromJson(Map<String, dynamic> json) => _$ChecksImpl(
      checkRunId: json['checkRunId'] as int,
      owner: json['owner'] as String,
      repositoryName: json['repositoryName'] as String,
      installationId: json['installationId'] as int,
      jobId: json['jobId'] as String,
    );

Map<String, dynamic> _$$ChecksImplToJson(_$ChecksImpl instance) =>
    <String, dynamic>{
      'checkRunId': instance.checkRunId,
      'owner': instance.owner,
      'repositoryName': instance.repositoryName,
      'installationId': instance.installationId,
      'jobId': instance.jobId,
    };
