import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/domain/create_workflow_domain.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'create_workflow_dialog_controller.g.dart';

@riverpod
class CreateWorkflowDialogController extends _$CreateWorkflowDialogController {
  @override
  CreateWorkflowDomain build() {
    return const CreateWorkflowDomain();
  }

  void setTemplate(OpenCIWorkflowTemplate template) {
    state = state.copyWith(template: template);
  }
}
