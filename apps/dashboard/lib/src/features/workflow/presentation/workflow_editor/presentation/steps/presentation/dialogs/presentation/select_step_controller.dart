import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/domain/select_step_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'select_step_controller.g.dart';

@Riverpod(keepAlive: true)
class SelectStepController extends _$SelectStepController {
  @override
  SelectStepDomain build() {
    return const SelectStepDomain();
  }

  void setTemplate(StepTemplate template) {
    state = state.copyWith(template: template);
  }
}
