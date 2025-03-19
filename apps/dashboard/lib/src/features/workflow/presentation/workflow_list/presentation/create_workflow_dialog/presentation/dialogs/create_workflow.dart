import 'package:dashboard/colors.dart';
import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/edit_workflow.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:flutter/material.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage createWorkflowPage(
  BuildContext modalSheetContext,
  String selectedRepository,
) {
  var isSuccess = false;
  WorkflowModel? workflow;
  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) async {
      switch (isSuccess && workflow != null) {
        case true:
          Navigator.of(modalSheetContext).pop();
          await Navigator.push(
            modalSheetContext,
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (context) => EditWorkflow(workflow!),
            ),
          );

        case false:
          WoltModalSheet.of(modalSheetContext).popPage();
      }
    },
    nextButtonText: (ref) {
      switch (isSuccess) {
        case true:
          return const Text(
            'Finish',
            style: TextStyle(fontWeight: FontWeight.w300),
          );
        case false:
          return const Text(
            'Error, please try again',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: OpenCIColors.error,
            ),
          );
      }
    },
    child: (ref) {
      final future = ref.watch(
        createWorkflowProvider(selectedRepository: selectedRepository),
      );
      return future.when(
        data: (data) {
          isSuccess = true;
          workflow = data;
          return const Text('✅ Successfully created workflow');
        },
        error: (error, stack) {
          isSuccess = false;
          return Text('❌ Error, please try again: $error');
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    },
    modalSheetContext: modalSheetContext,
    title: 'Create Workflow',
  );
}
