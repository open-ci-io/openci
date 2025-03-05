// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workflow_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateWorkflowDomainImpl _$$CreateWorkflowDomainImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateWorkflowDomainImpl(
      template: $enumDecodeNullable(
              _$OpenCIWorkflowTemplateEnumMap, json['template']) ??
          OpenCIWorkflowTemplate.ipa,
    );

Map<String, dynamic> _$$CreateWorkflowDomainImplToJson(
        _$CreateWorkflowDomainImpl instance) =>
    <String, dynamic>{
      'template': _$OpenCIWorkflowTemplateEnumMap[instance.template]!,
    };

const _$OpenCIWorkflowTemplateEnumMap = {
  OpenCIWorkflowTemplate.ipa: 'ipa',
  OpenCIWorkflowTemplate.blank: 'blank',
};
