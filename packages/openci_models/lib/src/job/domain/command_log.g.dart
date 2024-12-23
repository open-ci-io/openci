// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommandLogImpl _$$CommandLogImplFromJson(Map<String, dynamic> json) =>
    _$CommandLogImpl(
      command: json['command'] as String,
      logStdout: json['logStdout'] as String,
      logStderr: json['logStderr'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      exitCode: (json['exitCode'] as num).toInt(),
    );

Map<String, dynamic> _$$CommandLogImplToJson(_$CommandLogImpl instance) =>
    <String, dynamic>{
      'command': instance.command,
      'logStdout': instance.logStdout,
      'logStderr': instance.logStderr,
      'createdAt': instance.createdAt,
      'exitCode': instance.exitCode,
    };
