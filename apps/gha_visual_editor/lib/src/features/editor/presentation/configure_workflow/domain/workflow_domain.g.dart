// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowDomainImpl _$$WorkflowDomainImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowDomainImpl(
      workflowName: json['workflowName'] as String,
      branch: json['branch'] as String,
      on: $enumDecode(_$OnPushEnumMap, json['on']),
    );

Map<String, dynamic> _$$WorkflowDomainImplToJson(
        _$WorkflowDomainImpl instance) =>
    <String, dynamic>{
      'workflowName': instance.workflowName,
      'branch': instance.branch,
      'on': _$OnPushEnumMap[instance.on]!,
    };

const _$OnPushEnumMap = {
  OnPush.push: 'push',
  OnPush.pull_request: 'pull_request',
};
