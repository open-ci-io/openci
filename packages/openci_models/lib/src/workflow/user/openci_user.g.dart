// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openci_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenCIUserImpl _$$OpenCIUserImplFromJson(Map<String, dynamic> json) =>
    _$OpenCIUserImpl(
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      github: json['github'] == null
          ? null
          : OpenCIUserGitHub.fromJson(json['github'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpenCIUserImplToJson(_$OpenCIUserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'github': instance.github?.toJson(),
    };

_$OpenCIUserGitHubImpl _$$OpenCIUserGitHubImplFromJson(
        Map<String, dynamic> json) =>
    _$OpenCIUserGitHubImpl(
      installationId: (json['installationId'] as num?)?.toInt(),
      login: json['login'] as String?,
      repositories: (json['repositories'] as List<dynamic>?)
          ?.map((e) => OpenCIRepository.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OpenCIUserGitHubImplToJson(
        _$OpenCIUserGitHubImpl instance) =>
    <String, dynamic>{
      'installationId': instance.installationId,
      'login': instance.login,
      'repositories': instance.repositories?.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };
