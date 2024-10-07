import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow_model_v2.freezed.dart';
part 'workflow_model_v2.g.dart';

@freezed
class WorkflowModelV2 with _$WorkflowModelV2 {
  const factory WorkflowModelV2({
    required String id,
    required String name,
  }) = _WorkflowModelV2;
  factory WorkflowModelV2.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelV2FromJson(json);
}
