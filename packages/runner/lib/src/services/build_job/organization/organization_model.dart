import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

@freezed
class OrganizationModel with _$OrganizationModel {
  const factory OrganizationModel({
    required BuildNumber buildNumber,
    required String documentId,
  }) = _OrganizationModel;
  factory OrganizationModel.fromJson(Map<String, Object?> json) =>
      _$OrganizationModelFromJson(json);
}

@freezed
class BuildNumber with _$BuildNumber {
  const factory BuildNumber({
    required int android,
    required int ios,
  }) = _BuildNumber;
  factory BuildNumber.fromJson(Map<String, Object?> json) =>
      _$BuildNumberFromJson(json);
}
