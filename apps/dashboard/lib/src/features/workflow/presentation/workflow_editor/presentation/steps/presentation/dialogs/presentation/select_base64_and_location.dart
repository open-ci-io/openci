import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/presentation/select_step_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectBase64AndLocation(BuildContext context) {
  final titleController = TextEditingController();
  final base64Controller = TextEditingController();
  final locationController = TextEditingController();
  return baseDialog(
    modalSheetContext: context,
    title: 'Select Base64 and Location',
    child: (ref) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Title'),
          verticalMargin8,
          _Title(titleController: titleController),
          verticalMargin16,
          const Text('Base64'),
          verticalMargin8,
          TextFormField(
            controller: base64Controller,
            decoration: const InputDecoration(
              labelText: 'Base64',
            ),
          ),
          verticalMargin8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Import from Secrets'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Select a File'),
              ),
            ],
          ),
          verticalMargin16,
          const Text('File Location'),
          verticalMargin8,
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: '/path/to/file',
            ),
          ),
        ],
      );
    },
    onBack: (ref) => WoltModalSheet.of(context).popPage(),
    onNext: (ref, formKey) {},
  );
}

class _Title extends HookConsumerWidget {
  const _Title({
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider);
    useEffect(
      () {
        titleController.text = state.title;
        return null;
      },
    );
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
      ),
    );
  }
}
