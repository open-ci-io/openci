// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionResultImpl _$$SessionResultImplFromJson(Map<String, dynamic> json) =>
    _$SessionResultImpl(
      sessionStdout: json['sessionStdout'] as String? ?? '',
      sessionStderr: json['sessionStderr'] as String? ?? '',
      sessionExitCode: json['sessionExitCode'] as int?,
    );

Map<String, dynamic> _$$SessionResultImplToJson(_$SessionResultImpl instance) =>
    <String, dynamic>{
      'sessionStdout': instance.sessionStdout,
      'sessionStderr': instance.sessionStderr,
      'sessionExitCode': instance.sessionExitCode,
    };
