import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'workflow_editor_controller.g.dart';

@riverpod
class WorkflowEditorController extends _$WorkflowEditorController {
  @override
  WorkflowModel build(WorkflowModel workflowModel) {
    return workflowModel;
  }

  void updateFlutterVersion(String version) {
    state = state.copyWith.flutter(version: version);
  }

  void updateWorkflowName(String name) {
    state = state.copyWith(name: name);
  }

  void updateGitHubRepoUrl(String repoUrl) {
    state = state.copyWith.github(repositoryUrl: repoUrl);
  }

  void updateGitHubTriggerType(GitHubTriggerType triggerType) {
    state = state.copyWith.github(triggerType: triggerType);
  }

  void updateGitHubBaseBranch(String baseBranch) {
    state = state.copyWith.github(baseBranch: baseBranch);
  }

  void addOwner(String owner) {
    state = state.copyWith(owners: [...state.owners, owner]);
  }

  void removeOwner(int index) {
    final owners = state.owners.toList()..removeAt(index);
    state = state.copyWith(owners: owners);
  }

  void addStep() {
    final steps = state.steps.toList()..add(const WorkflowModelStep());
    state = state.copyWith(steps: steps);
  }

  void updateStepName(int stepIndex, String name) {
    final steps = state.steps.toList();
    steps[stepIndex] = steps[stepIndex].copyWith(name: name);
    state = state.copyWith(steps: steps);
  }

  void removeStep(int stepIndex) {
    final steps = state.steps.toList()..removeAt(stepIndex);
    state = state.copyWith(steps: steps);
  }

  void addCommand(int stepIndex) {
    final steps = state.steps.toList();
    steps[stepIndex] =
        steps[stepIndex].copyWith(commands: [...steps[stepIndex].commands, '']);
    state = state.copyWith(steps: steps);
  }

  void updateCommand(int stepIndex, int commandIndex, String command) {
    final steps = state.steps.toList();
    final commands = steps[stepIndex].commands.toList();
    commands[commandIndex] = command;
    steps[stepIndex] = steps[stepIndex].copyWith(commands: commands);
    state = state.copyWith(steps: steps);
  }

  void removeCommand(int stepIndex, int commandIndex) {
    final steps = state.steps.toList();
    final commands = steps[stepIndex].commands.toList()..removeAt(commandIndex);
    steps[stepIndex] = steps[stepIndex].copyWith(commands: commands);
    state = state.copyWith(steps: steps);
  }

  Future<void> save() async {
    await FirebaseFirestore.instance
        .collection('workflows')
        .doc(state.id)
        .set(state.toJson());
  }
}
