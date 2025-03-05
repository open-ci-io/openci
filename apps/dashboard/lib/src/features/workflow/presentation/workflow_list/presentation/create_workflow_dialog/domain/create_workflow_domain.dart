import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_workflow_domain.freezed.dart';
part 'create_workflow_domain.g.dart';

@freezed
class CreateWorkflowDomain with _$CreateWorkflowDomain {
  const factory CreateWorkflowDomain({
    @Default(OpenCIWorkflowTemplate.ipa) OpenCIWorkflowTemplate template,
  }) = _CreateWorkflowDomain;
  factory CreateWorkflowDomain.fromJson(Map<String, Object?> json) =>
      _$CreateWorkflowDomainFromJson(json);
}
