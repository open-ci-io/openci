// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openci_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenCIUserImpl _$$OpenCIUserImplFromJson(Map<String, dynamic> json) =>
    _$OpenCIUserImpl(
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      github: OpenCIUserGitHub.fromJson(json['github'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpenCIUserImplToJson(_$OpenCIUserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'github': instance.github.toJson(),
    };

_$OpenCIUserGitHubImpl _$$OpenCIUserGitHubImplFromJson(
        Map<String, dynamic> json) =>
    _$OpenCIUserGitHubImpl(
      repositoryUrl: json['repositoryUrl'] as String,
    );

Map<String, dynamic> _$$OpenCIUserGitHubImplToJson(
        _$OpenCIUserGitHubImpl instance) =>
    <String, dynamic>{
      'repositoryUrl': instance.repositoryUrl,
    };
