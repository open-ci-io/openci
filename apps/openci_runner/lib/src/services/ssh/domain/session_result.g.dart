// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionResultImpl _$$SessionResultImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$SessionResultImpl',
      json,
      ($checkedConvert) {
        final val = _$SessionResultImpl(
          sessionStdout:
              $checkedConvert('session_stdout', (v) => v as String? ?? ''),
          sessionStderr:
              $checkedConvert('session_stderr', (v) => v as String? ?? ''),
          sessionExitCode:
              $checkedConvert('session_exit_code', (v) => (v as num?)?.toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'sessionStdout': 'session_stdout',
        'sessionStderr': 'session_stderr',
        'sessionExitCode': 'session_exit_code'
      },
    );

Map<String, dynamic> _$$SessionResultImplToJson(_$SessionResultImpl instance) =>
    <String, dynamic>{
      'session_stdout': instance.sessionStdout,
      'session_stderr': instance.sessionStderr,
      'session_exit_code': instance.sessionExitCode,
    };
