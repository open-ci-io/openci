import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class WorkflowPage extends ConsumerWidget {
  const WorkflowPage({super.key, required this.firebaseSuite});

  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowPageControllerProvider(firebaseSuite).notifier);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        onPressed: controller.addWorkflow,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: controller.workflows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No workflow found'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          }
          final workflows = snapshot.data!;
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
                  workflowModel: workflow,
                  firebaseSuite: firebaseSuite,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _WorkflowListItem extends ConsumerWidget {
  const _WorkflowListItem({
    required this.workflowModel,
    required this.firebaseSuite,
  });

  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowPageControllerProvider(firebaseSuite).notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final iconWidth = screenWidth * 0.05;
    return ListTile(
      title: Text(
        workflowModel.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      subtitle: Wrap(
        children: [
          Text(
            workflowModel.github.triggerType.name,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Text(
            workflowModel.github.baseBranch,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Text(
            workflowModel.currentWorkingDirectory,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
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
                          builder: (context) => WorkflowEditor(
                            workflowModel,
                            firebaseSuite,
                          ),
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
                    onPressed: () =>
                        controller.duplicateWorkflow(workflowModel),
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: iconWidth,
                  child: IconButton(
                    onPressed: () {
                      showDeleteDialog(
                        title: 'Delete Workflow',
                        context: context,
                        onDelete: () {
                          controller.deleteWorkflow(workflowModel.id);
                        },
                      );
                    },
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
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                fullscreenDialog: true,
                                builder: (context) => WorkflowEditor(
                                  workflowModel,
                                  firebaseSuite,
                                ),
                              ),
                            );
                          },
                          child: const Text('Edit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.duplicateWorkflow(workflowModel);
                            Navigator.pop(context);
                          },
                          child: const Text('Duplicate'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.deleteWorkflow(workflowModel.id);
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
