// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_model_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowModelV2Impl _$$WorkflowModelV2ImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowModelV2Impl(
      id: json['id'] as String,
      name: json['name'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => OpenCIStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkflowModelV2ImplToJson(
        _$WorkflowModelV2Impl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };
