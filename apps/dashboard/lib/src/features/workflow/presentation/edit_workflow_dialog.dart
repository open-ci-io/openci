import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/extensions/build_context_extension.dart';
import 'package:dashboard/src/features/workflow/domain/workflow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signals_flutter/signals_flutter.dart';

final _workflowState = signal<WorkflowModel?>(null);

class EditWorkflowDialog extends HookConsumerWidget {
  const EditWorkflowDialog(
    this.workflow, {
    super.key,
    this.isNewWorkflow = false,
  });

  final WorkflowModel? workflow;
  final bool isNewWorkflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: workflow?.name ?? '');
    final flutterVersionController =
        useTextEditingController(text: workflow?.flutter.version ?? '');
    final githubUrlController =
        useTextEditingController(text: workflow?.github.repositoryUrl ?? '');
    final triggerTypeController =
        useTextEditingController(text: workflow?.github.triggerType.name ?? '');

    final scrollController = useScrollController();

    useEffect(
      () {
        _workflowState.value = workflow;
        return () {};
      },
    );

    // 新しいステップが追加されたときのスムーズなスクロールを行う関数
    void smoothScrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      });
    }

    return Dialog(
      child: Container(
        width: context.screenWidth * 0.8,
        height: context.screenHeight * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Watch(
              (context) => Text(
                _workflowState.value == null ? 'Add Workflow' : 'Edit Workflow',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
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
                    TextButton(
                      onPressed: () {
                        _addStep();
                        smoothScrollToBottom();
                      },
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
                TextButton(
                  onPressed: () async {
                    _workflowState.value = _workflowState.value?.copyWith(
                      name: nameController.text,
                      flutter: WorkflowModelFlutter(
                        version: flutterVersionController.text,
                      ),
                      github: WorkflowModelGitHub(
                        repositoryUrl: githubUrlController.text,
                        triggerType: GitHubTriggerType.values.byName(
                          triggerTypeController.text,
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                    await _saveWorkflow(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveWorkflow(BuildContext context) async {
    if (isNewWorkflow) {
      await _createNewWorkflow(context);
    } else {
      await _updateWorkflow(context);
    }
  }

  void _addStep() {
    final steps = _workflowState.value!.steps.toList()
      ..add(const WorkflowModelStep());
    _workflowState.value = _workflowState.value?.copyWith(
      steps: steps,
    );
  }

  Future<void> _createNewWorkflow(
    BuildContext context,
  ) async {
    final newWorkflowId =
        FirebaseFirestore.instance.collection('workflows').doc().id;
    _workflowState.value = _workflowState.value?.copyWith(id: newWorkflowId);
    await FirebaseFirestore.instance
        .collection('workflows')
        .doc(newWorkflowId)
        .set(_workflowState.value!.toJson());
  }

  Future<void> _updateWorkflow(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('workflows')
        .doc(_workflowState.value!.id)
        .set(_workflowState.value!.toJson());
  }
}

class _Steps extends StatelessWidget {
  const _Steps();

  void _removeStep(int index) {
    final steps = _workflowState.value!.steps.toList()..removeLast();
    _workflowState.value = _workflowState.value?.copyWith(steps: steps);
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final steps = _workflowState.value?.steps ?? [];

      return Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.blue, width: 0.3),
            ),
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
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Step Name'),
                    initialValue: step.name,
                    onChanged: (value) {
                      final newSteps = _workflowState.value!.steps.toList();
                      newSteps[index] = step.copyWith(name: value);
                      _workflowState.value =
                          _workflowState.value?.copyWith(steps: newSteps);
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Commands (comma-separated)',
                    ),
                    initialValue: step.commands.join(', '),
                    onChanged: (value) {
                      final newSteps = _workflowState.value!.steps.toList();
                      newSteps[index] =
                          step.copyWith(commands: value.split(', '));
                      _workflowState.value =
                          _workflowState.value?.copyWith(steps: newSteps);
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
    });
  }
}
