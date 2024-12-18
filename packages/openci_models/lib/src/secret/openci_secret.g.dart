// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openci_secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenciSecretImpl _$$OpenciSecretImplFromJson(Map<String, dynamic> json) =>
    _$OpenciSecretImpl(
      key: json['key'] as String,
      value: json['value'] as String,
      owners:
          (json['owners'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Object),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Object),
    );

Map<String, dynamic> _$$OpenciSecretImplToJson(_$OpenciSecretImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'owners': instance.owners,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
