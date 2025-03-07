import 'dart:convert';

import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/services/app_store_connect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
    child: (ref) => Padding(
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
    ),
    modalSheetContext: modalSheetContext,
    textTheme: textTheme,
    title: 'Upload ASC Keys',
  );
}
