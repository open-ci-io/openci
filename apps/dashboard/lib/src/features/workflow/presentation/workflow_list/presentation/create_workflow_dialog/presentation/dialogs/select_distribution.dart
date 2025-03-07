import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:openci_models/openci_models.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectDistribution(
  BuildContext modalSheetContext,
  TextTheme textTheme,
) {
  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {
      print(ref
          .read(createWorkflowDialogControllerProvider)
          .appDistributionTarget);
    },
    child: (ref) {
      final state = ref.watch(createWorkflowDialogControllerProvider);
      final value = state.appDistributionTarget;
      return Column(
        children: [
          RadioListTile<OpenCIAppDistributionTarget>(
            title: Text(OpenCIAppDistributionTarget.testflight.name),
            value: OpenCIAppDistributionTarget.testflight,
            groupValue: value,
            onChanged: (OpenCIAppDistributionTarget? value) {
              if (value != null) {
                ref
                    .read(createWorkflowDialogControllerProvider.notifier)
                    .setAppDistributionTarget(value);
              }
            },
          ),
          RadioListTile<OpenCIAppDistributionTarget>(
            title: Text(OpenCIAppDistributionTarget.none.name),
            value: OpenCIAppDistributionTarget.none,
            groupValue: value,
            onChanged: (OpenCIAppDistributionTarget? value) {
              if (value != null) {
                ref
                    .read(createWorkflowDialogControllerProvider.notifier)
                    .setAppDistributionTarget(value);
              }
            },
          ),
        ],
      );
    },
    modalSheetContext: modalSheetContext,
    textTheme: textTheme,
    title: 'Select Distribution',
  );
}
