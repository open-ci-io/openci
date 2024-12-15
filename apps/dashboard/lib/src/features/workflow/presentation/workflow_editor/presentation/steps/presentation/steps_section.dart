import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (_, index) {
                return _StepItem(
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

class _StepItem extends ConsumerWidget {
  const _StepItem({
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
                  initialValue: step.name,
                  decoration: const InputDecoration(
                    labelText: 'Step Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    print('value: $value');
                    controller.updateStepName(index, value);
                  },
                ),
                verticalMargin16,
                _Command(
                  step: step,
                  stepIndex: index,
                  workflowModel: workflowModel,
                ),
                verticalMargin8,
                TextButton(
                  onPressed: () => controller.removeStep(index),
                  child: const Text('Remove Step'),
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
  const _Command({
    required this.step,
    required this.stepIndex,
    required this.workflowModel,
  });

  final WorkflowModelStep step;
  final int stepIndex;
  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowEditorControllerProvider(workflowModel).notifier);
    final command = step.command;

    return TextFormField(
      initialValue: command,
      decoration: const InputDecoration(
        labelText: 'Command',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => controller.updateCommand(stepIndex, value),
    );
  }
}
