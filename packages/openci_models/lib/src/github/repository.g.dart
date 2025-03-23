// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenCIGitHubRepositoryImpl _$$OpenCIGitHubRepositoryImplFromJson(
        Map<String, dynamic> json) =>
    _$OpenCIGitHubRepositoryImpl(
      fullName: json['full_name'] as String,
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nodeId: json['node_id'] as String,
      private: json['private'] as bool,
    );

Map<String, dynamic> _$$OpenCIGitHubRepositoryImplToJson(
        _$OpenCIGitHubRepositoryImpl instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'id': instance.id,
      'name': instance.name,
      'node_id': instance.nodeId,
      'private': instance.private,
    };
