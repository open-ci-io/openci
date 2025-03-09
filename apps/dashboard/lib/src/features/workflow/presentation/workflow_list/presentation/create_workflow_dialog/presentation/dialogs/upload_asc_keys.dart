import 'package:dashboard/colors.dart';
import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_flutter_build_ipa_data.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage uploadASCKeys(
  BuildContext modalSheetContext,
  TextTheme textTheme,
) {
  var isSuccess = false;
  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {
      switch (isSuccess) {
        case true:
          WoltModalSheet.of(modalSheetContext).pushPage(
            selectFlutterBuildIpaData(modalSheetContext, textTheme),
          );
        case false:
          WoltModalSheet.of(modalSheetContext).popPage();
      }
    },
    nextButtonText: (ref) {
      switch (isSuccess) {
        case true:
          return const Text(
            'Next',
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
      final ascKey = ref.watch(createWorkflowDialogControllerProvider).ascKey;
      final future = ref.watch(saveASCKeysProvider(ascKey: ascKey));
      return future.when(
        data: (data) {
          isSuccess = true;
          return const Text('✅ Successfully uploaded ASC Keys');
        },
        error: (error, stack) {
          isSuccess = false;
          return Text('❌ Error, please try again: $error');
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
    modalSheetContext: modalSheetContext,
    textTheme: textTheme,
    title: 'Upload ASC Keys',
  );
}
