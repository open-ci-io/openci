// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_data_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

_$BranchImpl _$$BranchImplFromJson(Map<String, dynamic> json) => _$BranchImpl(
      baseBranch: json['baseBranch'] as String,
      buildBranch: json['buildBranch'] as String,
    );

Map<String, dynamic> _$$BranchImplToJson(_$BranchImpl instance) =>
    <String, dynamic>{
      'baseBranch': instance.baseBranch,
      'buildBranch': instance.buildBranch,
    };

_$GithubChecksImpl _$$GithubChecksImplFromJson(Map<String, dynamic> json) =>
    _$GithubChecksImpl(
      checkRunId: (json['checkRunId'] as num).toInt(),
      issueNumber: (json['issueNumber'] as num?)?.toInt() ?? null,
    );

Map<String, dynamic> _$$GithubChecksImplToJson(_$GithubChecksImpl instance) =>
    <String, dynamic>{
      'checkRunId': instance.checkRunId,
      'issueNumber': instance.issueNumber,
    };

_$GithubImpl _$$GithubImplFromJson(Map<String, dynamic> json) => _$GithubImpl(
      repositoryUrl: json['repositoryUrl'] as String,
      owner: json['owner'] as String,
      repositoryName: json['repositoryName'] as String,
      installationId: (json['installationId'] as num).toInt(),
      appId: (json['appId'] as num).toInt(),
    );

Map<String, dynamic> _$$GithubImplToJson(_$GithubImpl instance) =>
    <String, dynamic>{
      'repositoryUrl': instance.repositoryUrl,
      'owner': instance.owner,
      'repositoryName': instance.repositoryName,
      'installationId': instance.installationId,
      'appId': instance.appId,
    };

_$BuildModelImpl _$$BuildModelImplFromJson(Map<String, dynamic> json) =>
    _$BuildModelImpl(
      buildStatus:
          BuildStatus.fromJson(json['buildStatus'] as Map<String, dynamic>),
      branch: Branch.fromJson(json['branch'] as Map<String, dynamic>),
      githubChecks:
          GithubChecks.fromJson(json['githubChecks'] as Map<String, dynamic>),
      github: Github.fromJson(json['github'] as Map<String, dynamic>),
      documentId: json['documentId'] as String,
      platform: $enumDecode(_$TargetPlatformEnumMap, json['platform']),
      workflowId: json['workflowId'] as String,
      createdAt: _$JsonConverterFromJson<Object, Timestamp>(
              json['createdAt'], const TimestampConverter().fromJson) ??
          null,
    );

Map<String, dynamic> _$$BuildModelImplToJson(_$BuildModelImpl instance) =>
    <String, dynamic>{
      'buildStatus': instance.buildStatus,
      'branch': instance.branch,
      'githubChecks': instance.githubChecks,
      'github': instance.github,
      'documentId': instance.documentId,
      'platform': _$TargetPlatformEnumMap[instance.platform]!,
      'workflowId': instance.workflowId,
      'createdAt': _$JsonConverterToJson<Object, Timestamp>(
          instance.createdAt, const TimestampConverter().toJson),
    };

const _$TargetPlatformEnumMap = {
  TargetPlatform.android: 'android',
  TargetPlatform.ios: 'ios',
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
