import 'package:freezed_annotation/freezed_annotation.dart';

part 'android_runner.freezed.dart';
part 'android_runner.g.dart';

@freezed
class AndroidRunner with _$AndroidRunner {
  const factory AndroidRunner({
    required String key,
    required String error,
  }) = _AndroidRunner;
  factory AndroidRunner.fromJson(Map<String, Object?> json) =>
      _$AndroidRunnerFromJson(json);
}
