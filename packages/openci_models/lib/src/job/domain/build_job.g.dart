// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuildJobImpl _$$BuildJobImplFromJson(Map<String, dynamic> json) =>
    _$BuildJobImpl(
      buildStatus:
          $enumDecode(_$OpenCIGitHubChecksStatusEnumMap, json['buildStatus']),
      github: OpenCIGithub.fromJson(json['github'] as Map<String, dynamic>),
      id: json['id'] as String,
      workflowId: json['workflowId'] as String,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? null,
    );

Map<String, dynamic> _$$BuildJobImplToJson(_$BuildJobImpl instance) =>
    <String, dynamic>{
      'buildStatus': _$OpenCIGitHubChecksStatusEnumMap[instance.buildStatus]!,
      'github': instance.github.toJson(),
      'id': instance.id,
      'workflowId': instance.workflowId,
      'createdAt': instance.createdAt,
    };

const _$OpenCIGitHubChecksStatusEnumMap = {
  OpenCIGitHubChecksStatus.queued: 'queued',
  OpenCIGitHubChecksStatus.inProgress: 'inProgress',
  OpenCIGitHubChecksStatus.failure: 'failure',
  OpenCIGitHubChecksStatus.success: 'success',
};

_$OpenCIGithubImpl _$$OpenCIGithubImplFromJson(Map<String, dynamic> json) =>
    _$OpenCIGithubImpl(
      repositoryUrl: json['repositoryUrl'] as String,
      owner: json['owner'] as String,
      repositoryName: json['repositoryName'] as String,
      installationId: (json['installationId'] as num).toInt(),
      appId: (json['appId'] as num).toInt(),
      checkRunId: (json['checkRunId'] as num).toInt(),
      issueNumber: (json['issueNumber'] as num?)?.toInt() ?? null,
      baseBranch: json['baseBranch'] as String,
      buildBranch: json['buildBranch'] as String,
    );

Map<String, dynamic> _$$OpenCIGithubImplToJson(_$OpenCIGithubImpl instance) =>
    <String, dynamic>{
      'repositoryUrl': instance.repositoryUrl,
      'owner': instance.owner,
      'repositoryName': instance.repositoryName,
      'installationId': instance.installationId,
      'appId': instance.appId,
      'checkRunId': instance.checkRunId,
      'issueNumber': instance.issueNumber,
      'baseBranch': instance.baseBranch,
      'buildBranch': instance.buildBranch,
    };
