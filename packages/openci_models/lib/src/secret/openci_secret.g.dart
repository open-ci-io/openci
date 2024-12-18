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
          const DateTimeConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const DateTimeConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$OpenciSecretImplToJson(_$OpenciSecretImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'owners': instance.owners,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };
