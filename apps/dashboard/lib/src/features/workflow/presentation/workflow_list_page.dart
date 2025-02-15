import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class WorkflowListPage extends ConsumerWidget {
  const WorkflowListPage({super.key, required this.firebaseSuite});

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
              itemBuilder: (_, index) {
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
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => WorkflowEditor(workflowModel, firebaseSuite),
          ),
        );
      },
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
      trailing: _WorkflowListItemMenu(
        workflowModel: workflowModel,
        firebaseSuite: firebaseSuite,
        controller: controller,
      ),
    );
  }
}

class _WorkflowListItemMenu extends StatelessWidget {
  const _WorkflowListItemMenu({
    required this.workflowModel,
    required this.firebaseSuite,
    required this.controller,
  });

  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;
  final WorkflowPageController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return MenuAnchor(
      alignmentOffset: const Offset(-80, -40),
      menuChildren: <Widget>[
        MenuItemButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                fullscreenDialog: true,
                builder: (context) =>
                    WorkflowEditor(workflowModel, firebaseSuite),
              ),
            );
          },
          child: Text(
            'Edit',
            style: TextStyle(color: theme.primary),
          ),
        ),
        MenuItemButton(
          onPressed: () {
            controller.duplicateWorkflow(workflowModel);
          },
          child: Text(
            'Duplicate',
            style: TextStyle(color: theme.primary),
          ),
        ),
        MenuItemButton(
          onPressed: () {
            controller.deleteWorkflow(workflowModel.id);
          },
          child: Text(
            'Delete',
            style: TextStyle(color: theme.error),
          ),
        ),
      ],
      builder:
          (BuildContext context, MenuController menuController, Widget? child) {
        return IconButton(
          onPressed: () {
            if (menuController.isOpen) {
              menuController.close();
              return;
            }
            menuController.open();
          },
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  }
}
