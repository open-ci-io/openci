import 'dart:convert';

import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/enum.dart';
import 'package:dashboard/src/services/app_store_connect.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signals/signals_flutter.dart';

class UploadASCKeys extends HookConsumerWidget {
  const UploadASCKeys({
    super.key,
    required this.currentPage,
  });

  final Signal<PageEnum> currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuerIdEditingController = useTextEditingController();
    final keyIdEditingController = useTextEditingController();
    final keyFileBase64EditingController = useTextEditingController();
    return OpenCIDialog(
      width: 300,
      title: const Text(
        'Upload App Store Connect API Keys',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: const InputDecoration(
            labelText: 'Issuer Id',
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
        verticalMargin24,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                currentPage.value = PageEnum.checkASCKeyUpload;
              },
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            horizontalMargin8,
            TextButton(
              onPressed: () {
                // save keys
                currentPage.value = PageEnum.flutterBuildIpa;
              },
              child: const Text(
                'Next',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
