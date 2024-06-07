import 'package:freezed_annotation/freezed_annotation.dart';

part 'ios_runner.freezed.dart';
part 'ios_runner.g.dart';

@freezed
class IosRunner with _$IosRunner {
  const factory IosRunner({
    required String key,
    required String error,
  }) = _IosRunner;
  factory IosRunner.fromJson(Map<String, Object?> json) =>
      _$IosRunnerFromJson(json);
}
