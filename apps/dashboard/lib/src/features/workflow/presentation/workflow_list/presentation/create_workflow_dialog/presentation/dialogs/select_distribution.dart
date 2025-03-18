import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/create_workflow.dart';
import 'package:flutter/material.dart';
import 'package:openci_models/openci_models.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectDistribution(
  BuildContext modalSheetContext,
  String selectedRepository,
) {
  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {
      WoltModalSheet.of(modalSheetContext).pushPage(
        createWorkflowPage(modalSheetContext, selectedRepository),
      );
    },
    child: (ref) {
      final state =
          ref.watch(createWorkflowDialogControllerProvider(selectedRepository));
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
                    .read(
                      createWorkflowDialogControllerProvider(
                        selectedRepository,
                      ).notifier,
                    )
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
                    .read(
                      createWorkflowDialogControllerProvider(
                        selectedRepository,
                      ).notifier,
                    )
                    .setAppDistributionTarget(value);
              }
            },
          ),
        ],
      );
    },
    modalSheetContext: modalSheetContext,
    title: 'Select Distribution',
  );
}
