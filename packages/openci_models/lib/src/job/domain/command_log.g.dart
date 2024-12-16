// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommandLogImpl _$$CommandLogImplFromJson(Map<String, dynamic> json) =>
    _$CommandLogImpl(
      command: json['command'] as String,
      log: json['log'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommandLogImplToJson(_$CommandLogImpl instance) =>
    <String, dynamic>{
      'command': instance.command,
      'log': instance.log,
      'createdAt': instance.createdAt.toIso8601String(),
    };
