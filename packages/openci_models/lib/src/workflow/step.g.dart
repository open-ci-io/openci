// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenCIStepImpl _$$OpenCIStepImplFromJson(Map<String, dynamic> json) =>
    _$OpenCIStepImpl(
      name: json['name'] as String,
      commands:
          (json['commands'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$OpenCIStepImplToJson(_$OpenCIStepImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'commands': instance.commands,
    };
