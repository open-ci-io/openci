// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActionModelImpl _$$ActionModelImplFromJson(Map<String, dynamic> json) =>
    _$ActionModelImpl(
      title: json['title'] as String,
      source: json['source'] as String,
      name: json['name'] as String,
      uses: json['uses'] as String,
      properties: (json['properties'] as List<dynamic>?)
              ?.map((e) =>
                  ActionModelProperties.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ActionModelImplToJson(_$ActionModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'source': instance.source,
      'name': instance.name,
      'uses': instance.uses,
      'properties': instance.properties,
    };

_$ActionModelPropertiesImpl _$$ActionModelPropertiesImplFromJson(
        Map<String, dynamic> json) =>
    _$ActionModelPropertiesImpl(
      formStyle: $enumDecode(_$FormStyleEnumMap, json['formStyle']),
      label: json['label'] as String,
      value: json['value'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ActionModelPropertiesImplToJson(
        _$ActionModelPropertiesImpl instance) =>
    <String, dynamic>{
      'formStyle': _$FormStyleEnumMap[instance.formStyle]!,
      'label': instance.label,
      'value': instance.value,
      'options': instance.options,
    };

const _$FormStyleEnumMap = {
  FormStyle.dropDown: 'dropDown',
  FormStyle.textField: 'textField',
  FormStyle.checkBox: 'checkBox',
};
