import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages.dart';
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
    const textFieldBorderWidth = 0.6;
    final colorScheme = Theme.of(context).colorScheme;
    final stepTitleEditingController = useTextEditingController();
    return OpenCIDialog(
      title: const Text(
        'Upload App Store Connect API Keys',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(18),
                  labelText: 'Issuer Id',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                controller: stepTitleEditingController,
              ),
            ),
            horizontalMargin16,
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(18),
                  labelText: 'Key Id',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                controller: stepTitleEditingController,
              ),
            ),
          ],
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
              onPressed: () {},
              icon: const Icon(Icons.folder_open),
            ),
            contentPadding: const EdgeInsets.all(18),
            labelText: '.p8 key file (select file)',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.primary,
              ),
            ),
          ),
          controller: stepTitleEditingController,
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
