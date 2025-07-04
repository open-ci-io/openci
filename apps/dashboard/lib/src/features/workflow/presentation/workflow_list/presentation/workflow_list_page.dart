import 'package:dashboard/colors.dart';
import 'package:dashboard/src/features/action.dart';
import 'package:dashboard/src/features/intent.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/edit_workflow.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_workflow_template.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WorkflowListPage extends HookConsumerWidget {
  const WorkflowListPage({super.key, required this.firebaseSuite});

  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    useEffect(
      () {
        focusNode.requestFocus();
        return null;
      },
      [focusNode],
    );

    void invalidateCreateWorkflowDialogController() {
      ref.invalidate(createWorkflowDialogControllerProvider);
    }

    final isGitHubAppInstalled =
        ref.watch(isGitHubAppInstalledProvider(firebaseSuite));

    final selectedRepository =
        ref.watch(selectedRepositoryProvider(firebaseSuite));

    return isGitHubAppInstalled.when(
      data: (isInstalled) {
        if (isInstalled) {
          return selectedRepository.when(
            data: (repositoryData) {
              final selectedRepository = repositoryData.selectedRepository;
              final repositories = repositoryData.repositories;
              return Shortcuts(
                shortcuts: const {
                  SingleActivator(LogicalKeyboardKey.enter):
                      CreateWorkflowIntent(),
                },
                child: Actions(
                  actions: {
                    CreateWorkflowIntent: CreateWorkflowAction(
                      callback: () {
                        invalidateCreateWorkflowDialogController();
                        WoltModalSheet.show<void>(
                          context: context,
                          pageListBuilder: (modalSheetContext) {
                            return [
                              selectWorkflowTemplate(
                                modalSheetContext,
                                firebaseSuite,
                                selectedRepository,
                              ),
                            ];
                          },
                          modalTypeBuilder: (context) => const WoltDialogType(),
                          onModalDismissedWithBarrierTap:
                              Navigator.of(context).pop,
                        );
                      },
                    ),
                  },
                  child: Focus(
                    focusNode: focusNode,
                    child: Scaffold(
                      floatingActionButton: FloatingActionButton(
                        heroTag: 'add',
                        onPressed: () => Actions.invoke(
                          context,
                          const CreateWorkflowIntent(),
                        ),
                        child: const Icon(Icons.add),
                      ),
                      body: ref
                          .watch(
                            workflowStreamProvider(
                              firebaseSuite,
                              selectedRepository,
                            ),
                          )
                          .when(
                            data: (data) {
                              final workflows = data
                                ..sort((a, b) => a.name.compareTo(b.name));
                              return Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownMenu(
                                      onSelected: (value) {
                                        if (value == null) {
                                          return;
                                        }
                                        ref
                                            .read(
                                              selectedRepositoryProvider(
                                                firebaseSuite,
                                              ).notifier,
                                            )
                                            .set(value);
                                      },
                                      initialSelection: selectedRepository,
                                      width: 240,
                                      hintText: 'Select a repository',
                                      dropdownMenuEntries: repositories
                                          .map(
                                            (e) => DropdownMenuEntry(
                                              value: e,
                                              label: e,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: workflows.length,
                                        separatorBuilder: (context, index) {
                                          final workflow = workflows[index];
                                          final nextWorkflow =
                                              index < workflows.length - 1
                                                  ? workflows[index + 1]
                                                  : null;
                                          final shouldShowSeparator = nextWorkflow !=
                                                  null &&
                                              workflow.currentWorkingDirectory ==
                                                  nextWorkflow
                                                      .currentWorkingDirectory;

                                          return shouldShowSeparator
                                              ? const Divider(
                                                  color: Color(0xFF2C2C2E),
                                                  height: 1,
                                                )
                                              : const SizedBox.shrink();
                                        },
                                        itemBuilder: (_, index) {
                                          final workflow = workflows[index];
                                          final previousWorkflow = index > 0
                                              ? workflows[index - 1]
                                              : null;
                                          final shouldShowWorkingDirectory =
                                              previousWorkflow == null ||
                                                  workflow.currentWorkingDirectory !=
                                                      previousWorkflow
                                                          .currentWorkingDirectory;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (shouldShowWorkingDirectory)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 30,
                                                    bottom: 20,
                                                  ),
                                                  child: Text(
                                                    workflow
                                                        .currentWorkingDirectory,
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
                                    ),
                                  ],
                                ),
                              );
                            },
                            error: (error, stack) => Center(
                              child: Text('Error0: $error'),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                    ),
                  ),
                ),
              );
            },
            error: (e, s) => Text('Error1: $e'),
            loading: () => const Text('Loading...'),
          );
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('GitHub App is not installed'),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    final url = ref
                        .read(
                          workflowPageControllerProvider(firebaseSuite)
                              .notifier,
                        )
                        .getInstallationUrl();
                    await launchUrl(Uri.parse(url));
                  },
                  child: const Text('Install GitHub App'),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => const Scaffold(
        body: Center(
          child: Text('An error occurred'),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
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
            builder: (context) => EditWorkflow(workflowModel),
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
                builder: (context) => EditWorkflow(workflowModel),
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
