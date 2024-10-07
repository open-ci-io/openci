import 'package:freezed_annotation/freezed_annotation.dart';

part 'step.freezed.dart';
part 'step.g.dart';

@freezed
class OpenCIStep with _$OpenCIStep {
  const factory OpenCIStep({
    required String name,
    required List<String> commands,
  }) = _OpenCIStep;
  factory OpenCIStep.fromJson(Map<String, Object?> json) =>
      _$OpenCIStepFromJson(json);
}
