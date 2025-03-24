// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnvModel _$EnvModelFromJson(Map<String, dynamic> json) => _EnvModel(
      firebaseServiceAccountBase64:
          json['firebaseServiceAccountBase64'] as String,
      firebaseProjectName: json['firebaseProjectName'] as String,
      pemBase64: json['pemBase64'] as String,
      githubAppId: json['githubAppId'] as String,
    );

Map<String, dynamic> _$EnvModelToJson(_EnvModel instance) => <String, dynamic>{
      'firebaseServiceAccountBase64': instance.firebaseServiceAccountBase64,
      'firebaseProjectName': instance.firebaseProjectName,
      'pemBase64': instance.pemBase64,
      'githubAppId': instance.githubAppId,
    };
