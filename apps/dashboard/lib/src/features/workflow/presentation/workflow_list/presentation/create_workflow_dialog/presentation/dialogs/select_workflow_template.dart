import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/edit_workflow.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/check_asc_keys.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/enum.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page_controller.dart'
    show workflowPageControllerProvider;
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../create_workflow_dialog_controller.dart';

WoltModalSheetPage selectWorkflowTemplate(
  BuildContext modalSheetContext,
  OpenCIFirebaseSuite firebaseSuite,
) {
  return baseDialog(
    onBack: (ref) => Navigator.pop(modalSheetContext),
    onNext: (
      ref,
      formKey,
    ) async {
      final state = ref.watch(createWorkflowDialogControllerProvider);
      switch (state.template) {
        case OpenCIWorkflowTemplate.ipa:
          WoltModalSheet.of(modalSheetContext).pushPage(
            checkASCKeys(modalSheetContext),
          );
        case OpenCIWorkflowTemplate.blank:
          Navigator.pop(modalSheetContext);
          final workflowModel = await ref
              .read(workflowPageControllerProvider(firebaseSuite).notifier)
              .addWorkflow();
          await Navigator.push(
            modalSheetContext,
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => EditWorkflow(workflowModel),
            ),
          );
      }
    },
    modalSheetContext: modalSheetContext,
    title: 'Choose Workflow Template',
    child: (ref) {
      final state = ref.watch(createWorkflowDialogControllerProvider);
      final controller =
          ref.watch(createWorkflowDialogControllerProvider.notifier);
      final template = state.template;
      return Column(
        children: [
          RadioListTile(
            title: const Text('Release .ipa'),
            value: OpenCIWorkflowTemplate.ipa,
            groupValue: template,
            onChanged: (value) {
              controller.setTemplate(OpenCIWorkflowTemplate.ipa);
            },
          ),
          RadioListTile(
            title: const Text('From Scratch'),
            value: OpenCIWorkflowTemplate.blank,
            groupValue: template,
            onChanged: (value) {
              controller.setTemplate(OpenCIWorkflowTemplate.blank);
            },
          ),
        ],
      );
    },
  );
}
