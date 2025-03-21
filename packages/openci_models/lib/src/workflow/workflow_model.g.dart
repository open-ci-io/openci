// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowModelImpl _$$WorkflowModelImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowModelImpl(
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

Map<String, dynamic> _$$WorkflowModelImplToJson(_$WorkflowModelImpl instance) =>
    <String, dynamic>{
      'currentWorkingDirectory': instance.currentWorkingDirectory,
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
      version:
          const FlutterVersionConverter().fromJson(json['version'] as String),
    );

Map<String, dynamic> _$$WorkflowModelFlutterImplToJson(
        _$WorkflowModelFlutterImpl instance) =>
    <String, dynamic>{
      'version': const FlutterVersionConverter().toJson(instance.version),
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
      command: json['command'] as String? ?? '',
    );

Map<String, dynamic> _$$WorkflowModelStepImplToJson(
        _$WorkflowModelStepImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'command': instance.command,
    };

_$OpenCIRepositoryImpl _$$OpenCIRepositoryImplFromJson(
        Map<String, dynamic> json) =>
    _$OpenCIRepositoryImpl(
      fullName: json['full_name'] as String,
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nodeId: json['node_id'] as String,
      private: json['private'] as bool,
    );

Map<String, dynamic> _$$OpenCIRepositoryImplToJson(
        _$OpenCIRepositoryImpl instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'id': instance.id,
      'name': instance.name,
      'node_id': instance.nodeId,
      'private': instance.private,
    };
