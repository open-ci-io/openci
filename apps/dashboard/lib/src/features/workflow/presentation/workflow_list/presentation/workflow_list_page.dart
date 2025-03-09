import 'package:dashboard/colors.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/edit_workflow.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/choose_workflow_template.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WorkflowListPage extends ConsumerWidget {
  const WorkflowListPage({super.key, required this.firebaseSuite});

  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void invalidateCreateWorkflowDialogController() {
      ref.invalidate(createWorkflowDialogControllerProvider);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        onPressed: () {
          invalidateCreateWorkflowDialogController();
          WoltModalSheet.show<void>(
            context: context,
            pageListBuilder: (modalSheetContext) {
              final textTheme = Theme.of(context).textTheme;
              return [
                chooseWorkflowTemplate(
                  modalSheetContext,
                  textTheme,
                  firebaseSuite,
                ),
              ];
            },
            modalTypeBuilder: (context) => const WoltDialogType(),
            onModalDismissedWithBarrierTap: Navigator.of(context).pop,
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ref.watch(workflowStreamProvider(firebaseSuite)).when(
            data: (data) {
              final workflows = data..sort((a, b) => a.name.compareTo(b.name));
              return Padding(
                padding: const EdgeInsets.all(24),
                child: ListView.separated(
                  itemCount: workflows.length,
                  separatorBuilder: (context, index) {
                    final workflow = workflows[index];
                    final nextWorkflow = index < workflows.length - 1
                        ? workflows[index + 1]
                        : null;
                    final shouldShowSeparator = nextWorkflow != null &&
                        workflow.currentWorkingDirectory ==
                            nextWorkflow.currentWorkingDirectory;

                    return shouldShowSeparator
                        ? const Divider(
                            color: Color(0xFF2C2C2E),
                            height: 1,
                          )
                        : const SizedBox.shrink();
                  },
                  itemBuilder: (_, index) {
                    final workflow = workflows[index];
                    final previousWorkflow =
                        index > 0 ? workflows[index - 1] : null;
                    final shouldShowWorkingDirectory =
                        previousWorkflow == null ||
                            workflow.currentWorkingDirectory !=
                                previousWorkflow.currentWorkingDirectory;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (shouldShowWorkingDirectory)
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 20),
                            child: Text(
                              workflow.currentWorkingDirectory,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        _WorkflowListItem(
                          workflowModel: workflow,
                          firebaseSuite: firebaseSuite,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            error: (error, stack) => const Center(
              child: Text('Error'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
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
            builder: (context) => EditWorkflow(workflowModel, firebaseSuite),
          ),
        );
      },
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          workflowModel.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              workflowModel.github.triggerType == GitHubTriggerType.push
                  ? FontAwesomeIcons.arrowRight
                  : FontAwesomeIcons.codePullRequest,
              size: 10,
              color: workflowModel.github.triggerType == GitHubTriggerType.push
                  ? OpenCIColors.primary
                  : OpenCIColors.primaryGreenDark,
            ),
            const SizedBox(width: 8),
            Text(
              workflowModel.github.baseBranch,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
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
                    EditWorkflow(workflowModel, firebaseSuite),
              ),
            );
          },
          child: Text(
            'Edit',
            style: TextStyle(
              color: theme.primary,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        MenuItemButton(
          onPressed: () {
            controller.duplicateWorkflow(workflowModel);
          },
          child: Text(
            'Duplicate',
            style: TextStyle(
              color: theme.primary,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        MenuItemButton(
          onPressed: () => controller.deleteWorkflow(workflowModel.id),
          child: Text(
            'Delete',
            style: TextStyle(
              color: theme.error,
              fontWeight: FontWeight.w200,
            ),
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
