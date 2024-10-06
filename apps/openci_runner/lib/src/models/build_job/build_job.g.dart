// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuildJobImpl _$$BuildJobImplFromJson(Map<String, dynamic> json) =>
    _$BuildJobImpl(
      id: json['id'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      status: $enumDecode(_$JobStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$BuildJobImplToJson(_$BuildJobImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'status': _$JobStatusEnumMap[instance.status]!,
    };

const _$JobStatusEnumMap = {
  JobStatus.waiting: 'waiting',
  JobStatus.processing: 'processing',
  JobStatus.success: 'success',
  JobStatus.failure: 'failure',
};
