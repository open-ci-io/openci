// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionResult _$SessionResultFromJson(Map<String, dynamic> json) =>
    _SessionResult(
      stdout: json['stdout'] as String,
      stderr: json['stderr'] as String,
      exitCode: (json['exitCode'] as num).toInt(),
    );

Map<String, dynamic> _$SessionResultToJson(_SessionResult instance) =>
    <String, dynamic>{
      'stdout': instance.stdout,
      'stderr': instance.stderr,
      'exitCode': instance.exitCode,
    };
