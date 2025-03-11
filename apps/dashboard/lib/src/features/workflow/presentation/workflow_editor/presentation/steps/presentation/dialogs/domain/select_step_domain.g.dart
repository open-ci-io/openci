// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_step_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectStepDomainImpl _$$SelectStepDomainImplFromJson(
        Map<String, dynamic> json) =>
    _$SelectStepDomainImpl(
      title: json['title'] as String? ?? 'Base64 to File',
      base64: json['base64'] as String? ?? '',
      location: json['location'] as String? ?? '',
      template: $enumDecodeNullable(_$StepTemplateEnumMap, json['template']) ??
          StepTemplate.blank,
      selectedKey: json['selectedKey'] as String?,
    );

Map<String, dynamic> _$$SelectStepDomainImplToJson(
        _$SelectStepDomainImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'base64': instance.base64,
      'location': instance.location,
      'template': _$StepTemplateEnumMap[instance.template]!,
      'selectedKey': instance.selectedKey,
    };

const _$StepTemplateEnumMap = {
  StepTemplate.blank: 'blank',
  StepTemplate.base64ToFile: 'base64ToFile',
};
