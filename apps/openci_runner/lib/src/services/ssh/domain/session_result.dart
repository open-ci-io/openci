import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_result.freezed.dart';
part 'session_result.g.dart';

@freezed
class SessionResult with _$SessionResult {
  const factory SessionResult({
    @Default('') String sessionStdout,
    @Default('') String sessionStderr,
    int? sessionExitCode,
  }) = _SessionResult;
  factory SessionResult.fromJson(Map<String, Object?> json) =>
      _$SessionResultFromJson(json);
}
