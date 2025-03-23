// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openci_secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpenCISecret _$OpenCISecretFromJson(Map<String, dynamic> json) =>
    _OpenCISecret(
      key: json['key'] as String,
      value: json['value'] as String,
      owners:
          (json['owners'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
    );

Map<String, dynamic> _$OpenCISecretToJson(_OpenCISecret instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'owners': instance.owners,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
