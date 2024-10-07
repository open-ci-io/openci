import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/src/workflow/step.dart';

part 'workflow_model_v2.freezed.dart';
part 'workflow_model_v2.g.dart';

@freezed
class WorkflowModelV2 with _$WorkflowModelV2 {
  const factory WorkflowModelV2({
    required String id,
    required String name,
    required List<OpenCIStep> steps,
  }) = _WorkflowModelV2;
  factory WorkflowModelV2.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelV2FromJson(json);
}
