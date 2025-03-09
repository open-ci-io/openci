import 'package:dashboard/colors.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/basic_information/presentation/basic_information_section.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/github_section/presentation/github_section.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/steps_section.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class EditWorkflow extends ConsumerWidget {
  const EditWorkflow(this.workflowModel, {super.key});
  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      workflowEditorControllerProvider(workflowModel).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Workflow',
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            onPressed: () async {
              Navigator.pop(context);
              await controller.save();
            },
          ),
          horizontalMargin32,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BasicInfoSection(workflowModel),
          verticalMargin24,
          GitHubSection(workflowModel),
          // verticalMargin24,
          // OwnersSection(workflowModel, firebaseSuite),
          verticalMargin24,
          StepsSection(workflowModel),
        ],
      ),
    );
  }
}

TextStyle labelStyle({
  required bool hasFocus,
}) =>
    hasFocus
        ? const TextStyle(color: OpenCIColors.primary)
        : const TextStyle(color: OpenCIColors.onPrimary);
