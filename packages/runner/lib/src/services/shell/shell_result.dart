import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_runner/src/services/ssh/domain/session_result.dart';

part 'shell_result.freezed.dart';

@freezed
class ShellResult with _$ShellResult {
  const factory ShellResult({
    required bool result,
    required SessionResult sessionResult,
  }) = _ShellResult;
}
