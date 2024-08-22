import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_model.freezed.dart';
part 'action_model.g.dart';

@freezed
class ActionModel with _$ActionModel {
  const factory ActionModel() = _ActionModel;
  factory ActionModel.fromJson(Map<String, Object?> json) =>
      _$ActionModelFromJson(json);
}
