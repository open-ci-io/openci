import 'dart:math';

import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:signals/signals_flutter.dart';

final _isEdit = signal(false);

class WorkflowPage extends ConsumerWidget {
  const WorkflowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(workflowPageControllerProvider.notifier);
    final stream = ref.watch(workflowStreamProvider);
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'edit',
            onPressed: () {
              _isEdit.value = !_isEdit.value;
            },
            child: Icon(_isEdit.watch(context) ? Icons.auto_graph : Icons.edit),
          ),
          verticalMargin16,
          FloatingActionButton(
            heroTag: 'add',
            onPressed: controller.addWorkflow,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: stream.when(
        data: (data) {
          final workflows = data.docs
              .map(
                (e) =>
                    WorkflowModel.fromJson(e.data()! as Map<String, dynamic>),
              )
              .toList();
          return Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.separated(
              itemCount: workflows.length,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFF2C2C2E),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final workflow = workflows[index];
                return _WorkflowListItem(
                  model: workflow,
                  workflow: WorkflowItem(
                    title: workflow.name,
                    lastUpdated: DateTime.now().toIso8601String(),
                    runCount: Random().nextInt(1000),
                  ),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('An error occurred: $error'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _WorkflowListItem extends ConsumerWidget {
  const _WorkflowListItem({
    required this.workflow,
    required this.model,
  });

  final WorkflowItem workflow;
  final WorkflowModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(workflowPageControllerProvider.notifier);
    return ListTile(
      leading: const Icon(
        Icons.account_tree_outlined,
        color: Colors.white,
      ),
      title: Text(
        workflow.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        'Latest: ${workflow.lastUpdated}',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      trailing: _isEdit.watch(context)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        fullscreenDialog: true,
                        builder: (context) => WorkflowEditor(model),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.duplicateWorkflow(model),
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.deleteWorkflow(model.id),
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  workflow.runCount.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
    );
  }
}

class WorkflowItem {
  WorkflowItem({
    required this.title,
    required this.lastUpdated,
    required this.runCount,
  });
  final String title;
  final String lastUpdated;
  final int runCount;
}
