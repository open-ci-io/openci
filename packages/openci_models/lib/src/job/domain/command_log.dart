import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_log.freezed.dart';
part 'command_log.g.dart';

@freezed
class CommandLog with _$CommandLog {
  const factory CommandLog({
    required String command,
    required String logStdout,
    required String logStderr,
    required int createdAt,
    required int exitCode,
  }) = _CommandLog;

  factory CommandLog.fromJson(Map<String, Object?> json) =>
      _$CommandLogFromJson(json);
}
