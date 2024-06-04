// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationModelImpl _$$OrganizationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationModelImpl(
      buildNumber:
          BuildNumber.fromJson(json['buildNumber'] as Map<String, dynamic>),
      documentId: json['documentId'] as String,
    );

Map<String, dynamic> _$$OrganizationModelImplToJson(
        _$OrganizationModelImpl instance) =>
    <String, dynamic>{
      'buildNumber': instance.buildNumber,
      'documentId': instance.documentId,
    };

_$BuildNumberImpl _$$BuildNumberImplFromJson(Map<String, dynamic> json) =>
    _$BuildNumberImpl(
      android: (json['android'] as num).toInt(),
      ios: (json['ios'] as num).toInt(),
    );

Map<String, dynamic> _$$BuildNumberImplToJson(_$BuildNumberImpl instance) =>
    <String, dynamic>{
      'android': instance.android,
      'ios': instance.ios,
    };
