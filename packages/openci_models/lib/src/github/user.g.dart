// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenCIUserGitHubImpl _$$OpenCIUserGitHubImplFromJson(
        Map<String, dynamic> json) =>
    _$OpenCIUserGitHubImpl(
      installationId: (json['installationId'] as num?)?.toInt(),
      login: json['login'] as String?,
      repositories: (json['repositories'] as List<dynamic>?)
          ?.map(
              (e) => OpenCIGitHubRepository.fromJson(e as Map<String, dynamic>))
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
