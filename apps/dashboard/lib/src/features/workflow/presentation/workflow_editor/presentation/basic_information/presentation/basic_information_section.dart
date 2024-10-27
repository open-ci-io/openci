import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class BasicInfoSection extends ConsumerWidget {
  const BasicInfoSection(this.workflowModel, {super.key});

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
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            verticalMargin16,
            TextFormField(
              initialValue: workflowModel.name,
              decoration: const InputDecoration(
                labelText: 'Workflow Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a workflow name';
                }
                return null;
              },
              onChanged: controller.updateWorkflowName,
            ),
            verticalMargin16,
            TextFormField(
              initialValue: workflowModel.flutter.version,
              decoration: const InputDecoration(
                labelText: 'Flutter Version',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter Flutter version';
                }
                return null;
              },
              onChanged: controller.updateFlutterVersion,
            ),
          ],
        ),
      ),
    );
  }
}
