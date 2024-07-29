// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      id: (json['id'] as num).toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      updated_at: DateTime.parse(json['updated_at'] as String),
      status: $enumDecode(_$JobStatusEnumMap, json['status']),
      github_org_name: json['github_org_name'] as String,
      github_repo_name: json['github_repo_name'] as String,
      workflow_run_id: (json['workflow_run_id'] as num).toInt(),
      github_installation_id: (json['github_installation_id'] as num).toInt(),
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at.toIso8601String(),
      'updated_at': instance.updated_at.toIso8601String(),
      'status': _$JobStatusEnumMap[instance.status]!,
      'github_org_name': instance.github_org_name,
      'github_repo_name': instance.github_repo_name,
      'workflow_run_id': instance.workflow_run_id,
      'github_installation_id': instance.github_installation_id,
    };

const _$JobStatusEnumMap = {
  JobStatus.queued: 'queued',
  JobStatus.processing: 'processing',
  JobStatus.completed: 'completed',
};
