import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/enum.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signals/signals_flutter.dart';

class CheckASCKeyUpload extends ConsumerWidget {
  const CheckASCKeyUpload({
    super.key,
    required this.currentPage,
  });

  final Signal<PageEnum> currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final future = ref.watch(areAppStoreConnectKeysUploadedProvider);
    return OpenCIDialog(
      width: screenWidth * 0.4,
      title: Text(
        'Checking ASC keys',
        style: textTheme.titleMedium,
      ),
      children: [
        future.when(
          data: (data) {
            final result = data;
            if (result) {
              return Column(
                children: [
                  const Text('✅ You have already uploaded ASC keys'),
                  verticalMargin16,
                  TextButton(
                    onPressed: () {
                      currentPage.value = PageEnum.flutterBuildIpa;
                    },
                    child: const Text('Next'),
                  ),
                ],
              );
            }
            return Column(
              children: [
                const Text('❌ You have not uploaded ASC keys yet'),
                verticalMargin16,
                TextButton(
                  onPressed: () {
                    currentPage.value = PageEnum.uploadASCKeys;
                  },
                  child: const Text('Upload ASC keys'),
                ),
              ],
            );
          },
          error: (error, stack) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
