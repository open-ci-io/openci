import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class OwnersSection extends ConsumerWidget {
  const OwnersSection(
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
    final state = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite),
    );
    final textTheme = Theme.of(context).textTheme;
    final owners = state.owners;
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
                Text(
                  'Owners',
                  style: textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addOwner(context, controller),
                ),
              ],
            ),
            verticalMargin16,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: owners.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(owners[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => controller.removeOwner(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addOwner(
    BuildContext context,
    WorkflowEditorController controller,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final ownerController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Owner'),
          content: TextField(
            controller: ownerController,
            decoration: const InputDecoration(
              labelText: 'Owner Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.addOwner(ownerController.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
