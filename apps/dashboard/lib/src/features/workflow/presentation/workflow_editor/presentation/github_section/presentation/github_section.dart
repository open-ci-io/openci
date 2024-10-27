import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class GitHubSection extends ConsumerWidget {
  const GitHubSection(
    this.workflowModel, {
    super.key,
  });

  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowEditorControllerProvider(workflowModel).notifier);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GitHub Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            verticalMargin16,
            TextFormField(
              initialValue: workflowModel.github.repositoryUrl,
              decoration: const InputDecoration(
                labelText: 'Repository URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter repository URL';
                }
                return null;
              },
              onChanged: controller.updateGitHubRepoUrl,
            ),
            verticalMargin16,
            DropdownButtonFormField<GitHubTriggerType>(
              value: workflowModel.github.triggerType,
              decoration: const InputDecoration(
                labelText: 'Trigger Type',
                border: OutlineInputBorder(),
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
            verticalMargin16,
            TextFormField(
              initialValue: workflowModel.github.baseBranch,
              decoration: const InputDecoration(
                labelText: 'Base Branch',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter base branch';
                }
                return null;
              },
              onChanged: controller.updateGitHubBaseBranch,
            ),
          ],
        ),
      ),
    );
  }
}
