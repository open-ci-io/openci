import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/enum.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/save_asc_keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signals/signals_flutter.dart';

class UploadASCKeys extends ConsumerWidget {
  const UploadASCKeys({
    super.key,
    required this.issuerId,
    required this.keyId,
    required this.keyBase64,
    required this.currentPage,
  });

  final String issuerId;
  final String keyId;
  final String keyBase64;
  final Signal<PageEnum> currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(
      saveASCKeysProvider(
        issuerId: issuerId,
        keyId: keyId,
        keyBase64: keyBase64,
      ),
    );
    final textTheme = Theme.of(context).textTheme;
    return OpenCIDialog(
      title: Text(
        'Result',
        style: textTheme.titleLarge,
      ),
      children: [
        future.when(
          data: (data) {
            if (data) {
              return const Text('✅ The ASC keys have been successfully saved');
            }
            return const Text('❌ The ASC keys have been failed to save');
          },
          error: (error, stack) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error.toString(),
                ),
                verticalMargin16,
                Text('stackTrace: $stack'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        verticalMargin16,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              currentPage.value = PageEnum.flutterBuildIpa;
            },
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }
}
