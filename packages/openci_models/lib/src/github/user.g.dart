// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpenCIUserGitHub _$OpenCIUserGitHubFromJson(Map<String, dynamic> json) =>
    _OpenCIUserGitHub(
      installationId: (json['installationId'] as num?)?.toInt(),
      login: json['login'] as String?,
      repositories: (json['repositories'] as List<dynamic>?)
          ?.map(
              (e) => OpenCIGitHubRepository.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OpenCIUserGitHubToJson(_OpenCIUserGitHub instance) =>
    <String, dynamic>{
      'installationId': instance.installationId,
      'login': instance.login,
      'repositories': instance.repositories?.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };
