// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GithubRepositoryImpl _$$GithubRepositoryImplFromJson(
        Map<String, dynamic> json) =>
    _$GithubRepositoryImpl(
      selectedRepository: json['selectedRepository'] as String,
      repositories: (json['repositories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$GithubRepositoryImplToJson(
        _$GithubRepositoryImpl instance) =>
    <String, dynamic>{
      'selectedRepository': instance.selectedRepository,
      'repositories': instance.repositories,
    };
