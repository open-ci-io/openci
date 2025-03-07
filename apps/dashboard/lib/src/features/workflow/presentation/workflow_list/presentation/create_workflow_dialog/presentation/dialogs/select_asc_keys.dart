import 'dart:convert';

import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/domain/create_workflow_domain.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/upload_asc_keys.dart';
import 'package:dashboard/src/services/app_store_connect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectASCKeys(
  BuildContext modalSheetContext,
  TextTheme textTheme,
) {
  final issuerIdEditingController = TextEditingController();
  final keyIdEditingController = TextEditingController();
  final keyFileBase64EditingController = TextEditingController();

  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {},
    child: (ref) => const SizedBox(),
    modalSheetContext: modalSheetContext,
    textTheme: textTheme,
    title: 'Upload ASC Keys',
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
        final controller =
            ref.watch(createWorkflowDialogControllerProvider.notifier);

        return TextButton(
          onPressed: () async {
            if (issuerIdEditingController.text.isEmpty ||
                keyIdEditingController.text.isEmpty ||
                keyFileBase64EditingController.text.isEmpty) {
              return;
            }
            controller.setASCKey(
              AppStoreConnectKey(
                issuerId: issuerIdEditingController.text,
                keyId: keyIdEditingController.text,
                key: keyFileBase64EditingController.text,
              ),
            );
            WoltModalSheet.of(modalSheetContext).pushPage(
              uploadASCKeys(modalSheetContext, textTheme),
            );
          },
          child: const Text(
            'Upload',
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      },
    ),
    builder: (context, ref, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
              decoration: const InputDecoration(
                labelText: 'Issuer Id',
                helperText: '* required',
              ),
              controller: issuerIdEditingController,
            ),
            verticalMargin16,
            TextField(
              readOnly: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                helperText: '* required',
                suffixIcon: IconButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['p8'],
                      withData: true,
                    );
                    if (result != null) {
                      final file = result.files.first;
                      final fileName = file.name;
                      final bytes = file.bytes;
                      if (bytes != null) {
                        final base64 = base64Encode(bytes);
                        keyFileBase64EditingController.text = base64;
                      }
                      final keyId = getASCKeyId(fileName);
                      if (keyId != null) {
                        keyIdEditingController.text = keyId;
                      }
                    }
                  },
                  icon: const Icon(Icons.folder_open),
                ),
                labelText: '.p8',
              ),
              controller: keyFileBase64EditingController,
            ),
          ],
        ),
      );
    },
  );
}
