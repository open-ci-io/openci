import 'package:dashboard/colors.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/basic_information/presentation/basic_information_section.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/github_section/presentation/github_section.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/steps_section.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class SaveWorkflowAndPopIntent extends Intent {
  const SaveWorkflowAndPopIntent();
}

class SaveWorkflowAndPopAction extends Action<SaveWorkflowAndPopIntent> {
  SaveWorkflowAndPopAction({required this.onSaveWorkflowAndPop});
  final VoidCallback onSaveWorkflowAndPop;

  @override
  Object? invoke(SaveWorkflowAndPopIntent intent) {
    onSaveWorkflowAndPop();
    return null;
  }
}

class EditWorkflow extends HookConsumerWidget {
  const EditWorkflow(this.workflowModel, {super.key});
  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();

    useEffect(
      () {
        focusNode.requestFocus();
        return null;
      },
      [focusNode],
    );

    final controller = ref.watch(
      workflowEditorControllerProvider(workflowModel).notifier,
    );

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): SaveWorkflowAndPopIntent(),
      },
      child: Actions(
        actions: {
          SaveWorkflowAndPopIntent: SaveWorkflowAndPopAction(
            onSaveWorkflowAndPop: () {
              Navigator.of(context).maybePop();
              controller.save();
            },
          ),
        },
        child: Focus(
          focusNode: focusNode,
          child: Builder(
            builder: (builderContext) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Edit Workflow',
                  ),
                  actions: [
                    TextButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      onPressed: () => Actions.invoke(
                        builderContext,
                        const SaveWorkflowAndPopIntent(),
                      ),
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
            },
          ),
        ),
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
