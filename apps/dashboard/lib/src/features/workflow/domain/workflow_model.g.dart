// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowModelImpl _$$WorkflowModelImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowModelImpl(
      name: json['name'] as String,
      id: json['id'] as String,
      flutter: WorkflowModelFlutter.fromJson(
          json['flutter'] as Map<String, dynamic>),
      github:
          WorkflowModelGitHub.fromJson(json['github'] as Map<String, dynamic>),
      owners:
          (json['owners'] as List<dynamic>).map((e) => e as String).toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => WorkflowModelStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkflowModelImplToJson(_$WorkflowModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'flutter': instance.flutter.toJson(),
      'github': instance.github.toJson(),
      'owners': instance.owners,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

_$WorkflowModelFlutterImpl _$$WorkflowModelFlutterImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowModelFlutterImpl(
      version: json['version'] as String,
    );

Map<String, dynamic> _$$WorkflowModelFlutterImplToJson(
        _$WorkflowModelFlutterImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
    };

_$WorkflowModelGitHubImpl _$$WorkflowModelGitHubImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowModelGitHubImpl(
      repositoryUrl: json['repositoryUrl'] as String,
      triggerType: $enumDecode(_$GitHubTriggerTypeEnumMap, json['triggerType']),
      baseBranch: json['baseBranch'] as String,
    );

Map<String, dynamic> _$$WorkflowModelGitHubImplToJson(
        _$WorkflowModelGitHubImpl instance) =>
    <String, dynamic>{
      'repositoryUrl': instance.repositoryUrl,
      'triggerType': _$GitHubTriggerTypeEnumMap[instance.triggerType]!,
      'baseBranch': instance.baseBranch,
    };

const _$GitHubTriggerTypeEnumMap = {
  GitHubTriggerType.push: 'push',
  GitHubTriggerType.pullRequest: 'pullRequest',
};

_$WorkflowModelStepImpl _$$WorkflowModelStepImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowModelStepImpl(
      name: json['name'] as String? ?? '',
      commands: (json['commands'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$WorkflowModelStepImplToJson(
        _$WorkflowModelStepImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'commands': instance.commands,
    };
