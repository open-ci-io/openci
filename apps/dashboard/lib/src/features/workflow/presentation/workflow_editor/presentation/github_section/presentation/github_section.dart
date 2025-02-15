import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/edit_workflow.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class GitHubSection extends HookConsumerWidget {
  const GitHubSection(
    this.workflowModel,
    this.firebaseSuite, {
    super.key,
  });

  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite).notifier,
    );
    final repoUrlFocusNode = useFocusNode();
    final triggerTypeFocusNode = useFocusNode();
    final baseBranchFocusNode = useFocusNode();

    useListenable(repoUrlFocusNode);
    useListenable(triggerTypeFocusNode);
    useListenable(baseBranchFocusNode);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GitHub Configuration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          verticalMargin16,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextFormField(
              focusNode: repoUrlFocusNode,
              initialValue: workflowModel.github.repositoryUrl,
              decoration: InputDecoration(
                labelText: 'Repository URL',
                labelStyle: labelStyle(hasFocus: repoUrlFocusNode.hasFocus),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter repository URL';
                }
                return null;
              },
              onChanged: controller.updateGitHubRepoUrl,
            ),
          ),
          verticalMargin16,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: DropdownButtonFormField<GitHubTriggerType>(
              focusNode: triggerTypeFocusNode,
              value: workflowModel.github.triggerType,
              decoration: InputDecoration(
                labelText: 'Trigger Type',
                labelStyle: labelStyle(hasFocus: triggerTypeFocusNode.hasFocus),
              ),
              items: GitHubTriggerType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) {
                controller
                    .updateGitHubTriggerType(value ?? GitHubTriggerType.push);
              },
            ),
          ),
          verticalMargin16,
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextFormField(
              focusNode: baseBranchFocusNode,
              initialValue: workflowModel.github.baseBranch,
              decoration: InputDecoration(
                labelText: 'Base Branch',
                labelStyle: labelStyle(hasFocus: baseBranchFocusNode.hasFocus),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter base branch';
                }
                return null;
              },
              onChanged: controller.updateGitHubBaseBranch,
            ),
          ),
        ],
      ),
    );
  }
}
