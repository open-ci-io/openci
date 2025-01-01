import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class WorkflowPage extends ConsumerWidget {
  const WorkflowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(workflowPageControllerProvider.notifier);
    final stream = ref.watch(workflowStreamProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        onPressed: controller.addWorkflow,
        child: const Icon(Icons.add),
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
    required this.model,
  });

  final WorkflowModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(workflowPageControllerProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final iconWidth = screenWidth * 0.05;
    return ListTile(
      title: Text(
        model.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      trailing: screenWidth > 400
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: iconWidth,
                  child: IconButton(
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
                ),
                SizedBox(
                  width: iconWidth,
                  child: IconButton(
                    onPressed: () => controller.duplicateWorkflow(model),
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: iconWidth,
                  child: IconButton(
                    onPressed: () => controller.deleteWorkflow(model.id),
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ),
              ],
            )
          : IconButton(
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => SizedBox(
                    height: 200,
                    width: 200,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                fullscreenDialog: true,
                                builder: (context) => WorkflowEditor(model),
                              ),
                            );

                            Navigator.pop(context);
                          },
                          child: const Text('Edit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.duplicateWorkflow(model);
                            Navigator.pop(context);
                          },
                          child: const Text('Duplicate'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.deleteWorkflow(model.id);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert),
            ),
    );
  }
}
