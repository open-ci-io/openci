import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_step_domain.freezed.dart';
part 'select_step_domain.g.dart';

@freezed
class SelectStepDomain with _$SelectStepDomain {
  const factory SelectStepDomain({
    @Default('Base64 to File') String title,
    @Default('') String base64,
    @Default('') String location,
    @Default(StepTemplate.blank) StepTemplate template,
  }) = _SelectStepDomain;
  factory SelectStepDomain.fromJson(Map<String, Object?> json) =>
      _$SelectStepDomainFromJson(json);
}

enum StepTemplate {
  blank,
  base64ToFile;
}
