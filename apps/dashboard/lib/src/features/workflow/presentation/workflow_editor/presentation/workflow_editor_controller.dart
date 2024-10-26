import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'workflow_editor_controller.g.dart';

@riverpod
class WorkflowEditorController extends _$WorkflowEditorController {
  @override
  WorkflowModel? build(WorkflowModel? workflowModel) {
    return workflowModel;
  }
}
