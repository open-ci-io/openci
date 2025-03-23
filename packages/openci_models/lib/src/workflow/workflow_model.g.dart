// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowModel _$WorkflowModelFromJson(Map<String, dynamic> json) =>
    _WorkflowModel(
      currentWorkingDirectory: json['currentWorkingDirectory'] as String,
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

Map<String, dynamic> _$WorkflowModelToJson(_WorkflowModel instance) =>
    <String, dynamic>{
      'currentWorkingDirectory': instance.currentWorkingDirectory,
      'name': instance.name,
      'id': instance.id,
      'flutter': instance.flutter.toJson(),
      'github': instance.github.toJson(),
      'owners': instance.owners,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

_WorkflowModelFlutter _$WorkflowModelFlutterFromJson(
        Map<String, dynamic> json) =>
    _WorkflowModelFlutter(
      version:
          const FlutterVersionConverter().fromJson(json['version'] as String),
    );

Map<String, dynamic> _$WorkflowModelFlutterToJson(
        _WorkflowModelFlutter instance) =>
    <String, dynamic>{
      'version': const FlutterVersionConverter().toJson(instance.version),
    };

_WorkflowModelGitHub _$WorkflowModelGitHubFromJson(Map<String, dynamic> json) =>
    _WorkflowModelGitHub(
      repositoryUrl: json['repositoryUrl'] as String,
      triggerType: $enumDecode(_$GitHubTriggerTypeEnumMap, json['triggerType']),
      baseBranch: json['baseBranch'] as String,
    );

Map<String, dynamic> _$WorkflowModelGitHubToJson(
        _WorkflowModelGitHub instance) =>
    <String, dynamic>{
      'repositoryUrl': instance.repositoryUrl,
      'triggerType': _$GitHubTriggerTypeEnumMap[instance.triggerType]!,
      'baseBranch': instance.baseBranch,
    };

const _$GitHubTriggerTypeEnumMap = {
  GitHubTriggerType.push: 'push',
  GitHubTriggerType.pullRequest: 'pullRequest',
};

_WorkflowModelStep _$WorkflowModelStepFromJson(Map<String, dynamic> json) =>
    _WorkflowModelStep(
      name: json['name'] as String? ?? '',
      command: json['command'] as String? ?? '',
    );

Map<String, dynamic> _$WorkflowModelStepToJson(_WorkflowModelStep instance) =>
    <String, dynamic>{
      'name': instance.name,
      'command': instance.command,
    };
