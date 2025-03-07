import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/check_asc_keys.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/enum.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../create_workflow_dialog_controller.dart';

WoltModalSheetPage chooseWorkflowTemplate(
  BuildContext modalSheetContext,
  TextTheme textTheme,
) {
  return baseDialog(
    onBack: (ref) => Navigator.pop(modalSheetContext),
    onNext: (
      ref,
      formKey,
    ) {
      final state = ref.watch(createWorkflowDialogControllerProvider);
      switch (state.template) {
        case OpenCIWorkflowTemplate.ipa:
          WoltModalSheet.of(modalSheetContext).pushPage(
            checkASCKeys(modalSheetContext, textTheme),
          );
        case OpenCIWorkflowTemplate.blank:
          Navigator.pop(modalSheetContext);
        // TODO(someone): Implement blank template
      }
    },
    modalSheetContext: modalSheetContext,
    textTheme: textTheme,
    title: 'Choose Workflow Template',
    leftButtonTextButton:
        TextButton(onPressed: () {}, child: const Text('Back')),
    rightButtonTextButton:
        TextButton(onPressed: () {}, child: const Text('Next')),
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
    builder: (context, ref, child) {
      return const Column(
        children: [
          Text('Choose Workflow Template'),
        ],
      );
    },
  );
}
