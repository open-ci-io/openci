import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/presentation/select_step_controller.dart';
import 'package:dashboard/src/services/firestore/secrets_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage importSecrets(
  BuildContext context,
) {
  return baseDialog(
    modalSheetContext: context,
    title: 'Select Secret',
    child: (ref) {
      final future = ref.watch(secretsProvider);
      return future.when(
        data: (data) {
          String? selectedOption;
          return _Body(
            selectedOption: selectedOption,
            secrets: data,
          );
        },
        error: (error, stack) {
          return const Text('Error');
        },
        loading: () {
          return const Text('Loading');
        },
      );
    },
    onBack: (ref) => WoltModalSheet.of(context).popPage(),
    onNext: (ref, formKey) => WoltModalSheet.of(context).popPage(),
  );
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.selectedOption,
    required this.secrets,
  });

  final String? selectedOption;
  final List<String> secrets;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider);
    final controller = ref.watch(selectStepControllerProvider.notifier);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      // TODO(someone): 2 scrollbar shows
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...secrets.map(
              (item) => RadioListTile<String>(
                title: Text(item),
                value: item,
                groupValue: state.selectedKey ?? '',
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  controller
                    ..setSelectedKey(value)
                    ..setBase64('\$$value');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
