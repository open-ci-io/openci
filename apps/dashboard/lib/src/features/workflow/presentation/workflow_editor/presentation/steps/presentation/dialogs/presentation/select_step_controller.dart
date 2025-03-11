import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/domain/select_step_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'select_step_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectStepController extends _$SelectStepController {
  @override
  SelectStepDomain build(String cwd) {
    return SelectStepDomain(location: cwd);
  }

  void setTemplate(StepTemplate template) {
    state = state.copyWith(template: template);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setBase64(String base64) {
    state = state.copyWith(base64: base64);
  }

  void setSelectedKey(String selectedKey) {
    state = state.copyWith(selectedKey: selectedKey);
  }
}
