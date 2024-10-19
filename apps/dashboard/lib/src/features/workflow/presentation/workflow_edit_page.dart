import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/extensions/build_context_extension.dart';
import 'package:dashboard/src/features/workflow/domain/workflow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

class WorkflowCard extends StatelessWidget {
  final WorkflowModel workflow;

  const WorkflowCard({super.key, required this.workflow});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.blue, width: 1),
      ),
      child: ExpansionTile(
        expansionAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.blue, width: 1),
        ),
        title: Text(workflow.name),
        subtitle: Text('Flutter: ${workflow.flutter.version}'),
        children: [
          ListTile(
            title: Text('GitHub: ${workflow.github.repositoryUrl}'),
          ),
          ListTile(
            title: Text('Trigger Type: ${workflow.github.triggerType.name}'),
          ),
          const ListTile(title: Text('Steps:')),
          ...workflow.steps.map<Widget>(
            (step) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ListTile(
                title: Text(step.name),
                subtitle: Text(step.commands.join(', ')),
              ),
            ),
          ),
          OverflowBar(
            children: [
              TextButton(
                onPressed: () =>
                    _showWorkflowDialog(context, workflow: workflow),
                child: const Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWorkflowDialog(BuildContext context, {WorkflowModel? workflow}) {
    showDialog(
      context: context,
      builder: (context) => WorkflowDialog(workflow),
    );
  }
}

final _steps = listSignal<Map<String, dynamic>>([]);

class WorkflowDialog extends HookConsumerWidget {
  const WorkflowDialog(this.workflow, {super.key});

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
        _steps.value = List<Map<String, dynamic>>.from(
            workflow?.steps.map((step) => step.toJson()).toList() ?? []);
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
                          labelText: 'GitHub Repository URL'),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: triggerTypeController,
                      decoration:
                          const InputDecoration(labelText: 'Trigger Type'),
                    ),
                    verticalMargin16,
                    const Text('Steps',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
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
                  onPressed: () => _saveWorkflow(context),
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
    _steps.add({'name': '', 'commands': []});
  }

  void _saveWorkflow(BuildContext context) {
    // Implement Firebase data saving logic here
    // Example:
    // FirebaseFirestore.instance.collection('workflows').add({
    //   'name': _nameController.text,
    //   'flutter': {'version': _flutterVersionController.text},
    //   'github': {
    //     'repositoryUrl': _githubUrlController.text,
    //     'triggerType': _triggerTypeController.text,
    //   },
    //   'steps': _steps,
    // });
    Navigator.of(context).pop();
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Step $index',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                        fontSize: 12),
                  ),
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Step Name'),
                  controller: TextEditingController(text: step['name']),
                  onChanged: (value) => _steps[index]['name'] = value,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: 'Commands (comma-separated)'),
                  controller:
                      TextEditingController(text: step['commands']?.join(', ')),
                  onChanged: (value) =>
                      _steps[index]['commands'] = value.split(', '),
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
