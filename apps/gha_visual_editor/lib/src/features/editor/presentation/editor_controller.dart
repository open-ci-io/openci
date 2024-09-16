import 'package:gha_visual_editor/src/features/editor/domain/editor_domain.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/action/domain/action_model.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/domain/configure_first_action_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'editor_controller.g.dart';

@riverpod
class EditorController extends _$EditorController {
  @override
  EditorDomain build() {
    return const EditorDomain();
  }

  void updateWorkflowOfFirstAction(String newValue) {
    state = state.copyWith(
      firstAction: state.firstAction.copyWith(
        workflow: ConfigureFirstActionDomainWorkflow(value: newValue),
      ),
    );
  }

  void updateRunOfFirstAction(String newValue) {
    state = state.copyWith(
      firstAction: state.firstAction.copyWith(
        run: ConfigureFirstActionDomainRun(value: newValue),
      ),
    );
  }

  void updateBranchOfFirstAction(String newValue) {
    state = state.copyWith(
      firstAction: state.firstAction.copyWith(
        branch: ConfigureFirstActionDomainBranch(value: newValue),
      ),
    );
  }

  void updateBuildMachineOfFirstAction(String newValue) {
    state = state.copyWith(
      firstAction: state.firstAction.copyWith(
        buildMachine: ConfigureFirstActionDomainBuildMachine(value: newValue),
      ),
    );
  }

  void addNewSavedAction(ActionModel action) {
    final previousAction = state.actionList.toList();
    previousAction.add(action);
    state = state.copyWith(
      actionList: previousAction,
    );
  }

  String toYaml() {
    final yamlString = StringBuffer();

    yamlString.writeln('name: ${state.firstAction.workflow.value}');
    yamlString.writeln('on: ${state.firstAction.run.value}');
    yamlString.writeln('  ${state.firstAction.run.value}:');
    yamlString.writeln('    branches: ${state.firstAction.branch.value}');
    yamlString.writeln('jobs:');
    yamlString.writeln('  build:');
    yamlString.writeln('    runs-on: ${state.firstAction.buildMachine.value}');
    yamlString.writeln('    steps:');
    for (var action in state.actionList) {
      yamlString.writeln('       - name: ${action.name}');
      yamlString.writeln('          uses: ${action.uses}');
      if (action.properties.isEmpty == false) {
        yamlString.writeln('          with:');
        for (var property in action.properties) {
          yamlString.writeln('            ${property.key}: ${property.value}');
        }
      }
    }

    return yamlString.toString();
  }
}
