import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_result.freezed.dart';
part 'session_result.g.dart';

@freezed
abstract class SessionResult with _$SessionResult {
  const factory SessionResult({
    required String stdout,
    required String stderr,
    required int exitCode,
  }) = _SessionResult;
  factory SessionResult.fromJson(Map<String, Object?> json) =>
      _$SessionResultFromJson(json);
}
