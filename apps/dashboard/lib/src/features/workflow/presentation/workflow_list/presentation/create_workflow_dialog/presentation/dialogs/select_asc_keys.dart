import 'dart:convert';

import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/domain/create_workflow_domain.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/upload_asc_keys.dart';
import 'package:dashboard/src/services/app_store_connect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../create_workflow_dialog_controller.dart';

WoltModalSheetPage selectASCKeys(
  BuildContext modalSheetContext,
) {
  final issuerIdEditingController = TextEditingController();
  final keyIdEditingController = TextEditingController();
  final keyFileBase64EditingController = TextEditingController();

  return baseDialog(
    onBack: (ref) => WoltModalSheet.of(modalSheetContext).popPage(),
    onNext: (ref, formKey) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        ref.read(createWorkflowDialogControllerProvider.notifier).setASCKey(
              AppStoreConnectKey(
                issuerId: issuerIdEditingController.text,
                keyId: keyIdEditingController.text,
                keyFileBase64: keyFileBase64EditingController.text,
              ),
            );
        WoltModalSheet.of(modalSheetContext).pushPage(
          uploadASCKeys(modalSheetContext),
        );
      }
    },
    child: (ref) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an issuer id';
              }
              // TODO(someone): validate issuer id

              return null;
            },
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
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a .p8 file';
              }
              return null;
            },
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
    ),
    modalSheetContext: modalSheetContext,
    title: 'Select ASC Keys',
  );
}
