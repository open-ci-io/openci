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
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.created_at.toIso8601String(),
      'updated_at': instance.updated_at.toIso8601String(),
      'status': _$JobStatusEnumMap[instance.status]!,
    };

const _$JobStatusEnumMap = {
  JobStatus.queued: 'queued',
  JobStatus.processing: 'processing',
  JobStatus.completed: 'completed',
};
