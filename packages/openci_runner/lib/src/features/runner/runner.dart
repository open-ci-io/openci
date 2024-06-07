import 'package:freezed_annotation/freezed_annotation.dart';

part 'runner.freezed.dart';

@freezed
class Runner with _$Runner {
  const factory Runner({
    required String key,
    required String error,
  }) = _Runner;
}
