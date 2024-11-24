// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionResultImpl _$$SessionResultImplFromJson(Map<String, dynamic> json) =>
    _$SessionResultImpl(
      stdout: json['stdout'] as String,
      stderr: json['stderr'] as String,
      exitCode: (json['exitCode'] as num).toInt(),
    );

Map<String, dynamic> _$$SessionResultImplToJson(_$SessionResultImpl instance) =>
    <String, dynamic>{
      'stdout': instance.stdout,
      'stderr': instance.stderr,
      'exitCode': instance.exitCode,
    };
