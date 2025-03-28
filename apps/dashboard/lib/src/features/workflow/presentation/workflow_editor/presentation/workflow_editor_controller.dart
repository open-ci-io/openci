import 'package:dashboard/src/services/firebase.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workflow_editor_controller.g.dart';

@riverpod
class WorkflowEditorController extends _$WorkflowEditorController {
  @override
  WorkflowModel build(
    WorkflowModel workflowModel,
  ) =>
      workflowModel;

  void updateFlutterVersion(FlutterVersion version) {
    state = state.copyWith.flutter(version: version);
  }

  void updateCurrentWorkingDirectory(String currentWorkingDirectory) {
    state = state.copyWith(currentWorkingDirectory: currentWorkingDirectory);
  }

  void updateWorkflowName(String name) {
    state = state.copyWith(name: name);
  }

  void updateGitHubRepoFullName(String repoFullName) {
    state = state.copyWith.github(repositoryFullName: repoFullName);
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

  void addStepByIndex(int index) {
    final steps = state.steps.toList()
      ..insert(
        index,
        const WorkflowModelStep(
          name: 'New Step',
          command: 'echo "Hello, World!"',
        ),
      );
    state = state.copyWith(steps: steps);
  }

  void addStep({
    required String name,
    required String command,
  }) {
    state = state.copyWith(
      steps: [
        ...state.steps,
        WorkflowModelStep(name: name, command: command),
      ],
    );
  }

  void reorderStep(int oldIndex, int newIndex) {
    final steps = state.steps.toList();
    final step = steps.removeAt(oldIndex);
    steps.insert(newIndex, step);
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

  void updateCommand(int stepIndex, String command) {
    final steps = state.steps.toList();
    steps[stepIndex] = steps[stepIndex].copyWith(command: command);
    state = state.copyWith(steps: steps);
  }

  Future<void> save() async {
    final firestore = await getFirebaseFirestore();
    await firestore.collection('workflows').doc(state.id).set(state.toJson());
  }
}
