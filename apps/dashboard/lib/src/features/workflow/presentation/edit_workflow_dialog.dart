import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/extensions/build_context_extension.dart';
import 'package:dashboard/src/features/workflow/domain/workflow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

final _steps = listSignal<WorkflowModelStep>([]);

class EditWorkflowDialog extends HookConsumerWidget {
  const EditWorkflowDialog(this.workflow, {super.key});

  final WorkflowModel? workflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: workflow?.name ?? '');
    final flutterVersionController =
        useTextEditingController(text: workflow?.flutter.version ?? '');
    final githubUrlController =
        useTextEditingController(text: workflow?.github.repositoryUrl ?? '');
    final triggerTypeController =
        useTextEditingController(text: workflow?.github.triggerType.name ?? '');

    useEffect(
      () {
        _steps.value = workflow?.steps ?? [];
        return () {};
      },
      [workflow],
    );

    return Dialog(
      child: Container(
        width: context.screenWidth * 0.8,
        height: context.screenHeight * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              workflow == null ? 'Add Workflow' : 'Edit Workflow',
              style: const TextStyle(color: Colors.white),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Workflow Name'),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: flutterVersionController,
                      decoration:
                          const InputDecoration(labelText: 'Flutter Version'),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: githubUrlController,
                      decoration: const InputDecoration(
                        labelText: 'GitHub Repository URL',
                      ),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: triggerTypeController,
                      decoration:
                          const InputDecoration(labelText: 'Trigger Type'),
                    ),
                    verticalMargin16,
                    const Text(
                      'Steps',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const _Steps(),
                    ElevatedButton(
                      onPressed: _addStep,
                      child: const Text('Add Step'),
                    ),
                  ],
                ),
              ),
            ),
            OverflowBar(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => _saveWorkflow(context, workflow!),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addStep() {
    _steps.add(const WorkflowModelStep());
  }

  Future<void> _saveWorkflow(
    BuildContext context,
    WorkflowModel workflow,
  ) async {
    final newWorkflowId =
        FirebaseFirestore.instance.collection('workflows').doc().id;
    final newWorkflow = workflow.copyWith(id: newWorkflowId);
    Navigator.of(context).pop();
    await FirebaseFirestore.instance
        .collection('workflows')
        .doc(newWorkflowId)
        .set(newWorkflow.toJson());
  }
}

class _Steps extends StatelessWidget {
  const _Steps();

  void _removeStep(int index) {
    _steps.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _steps.watch(context).asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Step $index',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                  ),
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Step Name'),
                  controller: TextEditingController(text: step.name),
                  onChanged: (value) {
                    _steps[index] = step.copyWith(name: value);
                  },
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Commands (comma-separated)',
                  ),
                  controller:
                      TextEditingController(text: step.commands.join(', ')),
                  onChanged: (value) {
                    _steps[index] = step.copyWith(commands: value.split(', '));
                  },
                ),
                OverflowBar(
                  children: [
                    TextButton(
                      onPressed: () => _removeStep(index),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
