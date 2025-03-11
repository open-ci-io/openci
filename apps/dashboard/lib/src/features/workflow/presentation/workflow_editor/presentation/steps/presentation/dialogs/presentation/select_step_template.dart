import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/domain/select_step_domain.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/presentation/select_base64_and_location.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/presentation/select_step_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectStepTemplate(
  BuildContext context,
  String cwd,
  WorkflowEditorController workflowEditorController,
) {
  void onTemplateChanged(StepTemplate? template, WidgetRef ref) {
    if (template == null) {
      return;
    }
    ref.read(selectStepControllerProvider(cwd).notifier).setTemplate(template);
  }

  return baseDialog(
    modalSheetContext: context,
    title: 'Choose Step Template',
    child: (ref) {
      final state = ref.watch(selectStepControllerProvider(cwd)).template;
      return Column(
        children: [
          RadioListTile(
            title: const Text('Base64 to File'),
            value: StepTemplate.base64ToFile,
            groupValue: state,
            onChanged: (value) => onTemplateChanged(value, ref),
          ),
          RadioListTile(
            title: const Text('From Scratch'),
            value: StepTemplate.blank,
            groupValue: state,
            onChanged: (value) => onTemplateChanged(value, ref),
          ),
        ],
      );
    },
    onBack: (ref) => Navigator.pop(context),
    onNext: (ref, formKey) {
      final selectedTemplate =
          ref.read(selectStepControllerProvider(cwd)).template;
      switch (selectedTemplate) {
        case StepTemplate.base64ToFile:
          WoltModalSheet.of(context).pushPage(
            selectBase64AndLocation(context, cwd, workflowEditorController),
          );
        case StepTemplate.blank:
          Navigator.pop(context);
      }
    },
  );
}
