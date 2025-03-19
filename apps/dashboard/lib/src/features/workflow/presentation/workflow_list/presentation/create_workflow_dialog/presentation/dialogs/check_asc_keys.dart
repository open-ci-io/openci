import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_asc_keys.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_flutter_build_ipa_data.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage checkASCKeys(
  BuildContext modalSheetContext,
  String selectedRepository,
) {
  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {
      final state =
          ref.watch(createWorkflowDialogControllerProvider(selectedRepository));

      switch (state.isASCKeyUploaded) {
        case true:
          WoltModalSheet.of(modalSheetContext).pushPage(
            selectFlutterBuildIpaData(modalSheetContext, selectedRepository),
          );
        case false:
          WoltModalSheet.of(modalSheetContext).pushPage(
            selectASCKeys(modalSheetContext, selectedRepository),
          );
        case null:
          return;
      }
    },
    nextButtonText: (ref) {
      final state =
          ref.watch(createWorkflowDialogControllerProvider(selectedRepository));
      final text = switch (state.isASCKeyUploaded) {
        true => 'Next',
        false => 'Upload ASC Keys',
        null => 'Loading...',
      };
      return Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w300),
      );
    },
    child: (ref) {
      final controller = ref.watch(
        createWorkflowDialogControllerProvider(selectedRepository).notifier,
      );
      final future = ref.watch(areAppStoreConnectKeysUploadedProvider);
      return future.when(
        data: (data) {
          final result = data;
          if (result) {
            Future(() {
              controller.setIsASCKeyUploaded(isASCKeyUploaded: true);
            });
            return const Center(
              child: Text('✅ You have already uploaded ASC keys'),
            );
          }
          Future(() {
            controller.setIsASCKeyUploaded(isASCKeyUploaded: false);
          });
          return const Text('❌ You have not uploaded ASC keys yet');
        },
        error: (error, stack) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      );
    },
    modalSheetContext: modalSheetContext,
    title: 'Check ASC Keys',
  );
}
