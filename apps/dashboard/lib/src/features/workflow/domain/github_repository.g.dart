// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubRepository _$GithubRepositoryFromJson(Map<String, dynamic> json) =>
    _GithubRepository(
      selectedRepository: json['selectedRepository'] as String,
      repositories: (json['repositories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GithubRepositoryToJson(_GithubRepository instance) =>
    <String, dynamic>{
      'selectedRepository': instance.selectedRepository,
      'repositories': instance.repositories,
    };
