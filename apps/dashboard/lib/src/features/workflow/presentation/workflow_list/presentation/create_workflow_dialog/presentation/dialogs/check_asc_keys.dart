import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_asc_keys.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/select_flutter_build_ipa_data.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage checkASCKeys(
  BuildContext modalSheetContext,
  TextTheme textTheme,
) {
  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {
      WoltModalSheet.of(modalSheetContext).pushPage(
        selectFlutterBuildIpaData(modalSheetContext, textTheme),
      );
    },
    nextButtonText: (ref) {
      final state = ref.watch(createWorkflowDialogControllerProvider);
      final text = switch (state.isASCKeyUploaded) {
        true => 'Next',
        false => 'Upload ASC Keys',
        null => 'Loading...',
      };
      return Text(text, style: const TextStyle(fontWeight: FontWeight.w300));
    },
    builder: (context, ref, child) => const SizedBox(),
    child: (ref) {
      final controller =
          ref.watch(createWorkflowDialogControllerProvider.notifier);
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
    textTheme: textTheme,
    title: 'Check ASC Keys',
    leftButtonTextButton: TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(80, 36),
      ),
      onPressed: () => WoltModalSheet.of(modalSheetContext).popPage(),
      child: const Text(
        'Back',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
    rightButtonTextButton: Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(createWorkflowDialogControllerProvider);
        final text = switch (state.isASCKeyUploaded) {
          true => 'Next',
          false => 'Upload ASC Keys',
          null => 'Loading...',
        };
        return TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(80, 36),
          ),
          onPressed: () {
            switch (state.isASCKeyUploaded) {
              case true:
                WoltModalSheet.of(modalSheetContext).pushPage(
                  selectFlutterBuildIpaData(
                    modalSheetContext,
                    textTheme,
                  ),
                );
              case false:
                WoltModalSheet.of(modalSheetContext)
                    .pushPage(selectASCKeys(modalSheetContext, textTheme));
              case null:
                // TODO: Handle this case.
                throw UnimplementedError();
            }
          },
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      },
    ),
  );
}
