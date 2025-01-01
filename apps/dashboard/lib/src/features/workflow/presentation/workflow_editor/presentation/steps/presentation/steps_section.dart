import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class StepsSection extends ConsumerWidget {
  const StepsSection(this.workflowModel, {super.key});

  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowEditorControllerProvider(workflowModel).notifier);
    final state = ref.watch(workflowEditorControllerProvider(workflowModel));
    final steps = state.steps;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: controller.addStep,
                ),
              ],
            ),
            verticalMargin16,
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              onReorder: controller.reorderStep,
              itemBuilder: (_, index) {
                return _StepItem(
                  key: UniqueKey(),
                  step: steps[index],
                  index: index,
                  workflowModel: workflowModel,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends HookConsumerWidget {
  const _StepItem({
    super.key,
    required this.step,
    required this.index,
    required this.workflowModel,
  });

  final WorkflowModelStep step;
  final int index;
  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowEditorControllerProvider(workflowModel).notifier);
    final stepNameTextEditingController =
        useTextEditingController(text: step.name);
    final commandTextEditingController =
        useTextEditingController(text: step.command);

    return Card(
      elevation: 0,
      child: ExpansionTile(
        title: Text(step.name),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: stepNameTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Step Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                verticalMargin16,
                _Command(
                  commandTextEditingController,
                ),
                verticalMargin8,
                TextButton(
                  onPressed: () {
                    controller
                      ..updateStepName(
                        index,
                        stepNameTextEditingController.text,
                      )
                      ..updateCommand(
                        index,
                        commandTextEditingController.text,
                      );
                  },
                  child: const Text('Save Step'),
                ),
                verticalMargin8,
                TextButton(
                  onPressed: () => controller.removeStep(index),
                  child: const Text(
                    'Remove Step',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Command extends ConsumerWidget {
  const _Command(
    this.commandTextEditingController,
  );

  final TextEditingController commandTextEditingController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: commandTextEditingController,
      decoration: const InputDecoration(
        labelText: 'Command',
        border: OutlineInputBorder(),
      ),
    );
  }
}
