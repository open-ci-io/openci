// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuildJobImpl _$$BuildJobImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$BuildJobImpl',
      json,
      ($checkedConvert) {
        final val = _$BuildJobImpl(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          statusV2: $checkedConvert(
              'status_v2', (v) => $enumDecode(_$JobStatusEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'createdAt': 'created_at', 'statusV2': 'status_v2'},
    );

Map<String, dynamic> _$$BuildJobImplToJson(_$BuildJobImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'status_v2': _$JobStatusEnumMap[instance.statusV2]!,
    };

const _$JobStatusEnumMap = {
  JobStatus.waiting: 'waiting',
  JobStatus.processing: 'processing',
  JobStatus.success: 'success',
  JobStatus.failure: 'failure',
};
