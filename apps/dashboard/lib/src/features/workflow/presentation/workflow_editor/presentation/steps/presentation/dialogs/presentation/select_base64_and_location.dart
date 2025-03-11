import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/presentation/select_step_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectBase64AndLocation(BuildContext context, String cwd) {
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
          _Title(titleController: titleController, cwd: cwd),
          verticalMargin16,
          const Text('Base64'),
          verticalMargin8,
          _Base64(base64Controller: base64Controller, cwd: cwd),
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
          _Location(locationController: locationController, cwd: cwd),
        ],
      );
    },
    onBack: (ref) {
      ref.read(selectStepControllerProvider(cwd).notifier)
        ..setTitle(titleController.text)
        ..setLocation(locationController.text)
        ..setBase64(base64Controller.text);

      WoltModalSheet.of(context).popPage();
    },
    nextButtonText: (ref) => const Text(
      'Finish',
      style: TextStyle(fontWeight: FontWeight.w300),
    ),
    onNext: (ref, formKey) {},
  );
}

class _Base64 extends HookConsumerWidget {
  const _Base64({
    required this.base64Controller,
    required this.cwd,
  });

  final TextEditingController base64Controller;
  final String cwd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider(cwd));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          base64Controller.text = state.base64;
        });

        return null;
      },
      const [],
    );
    return TextFormField(
      controller: base64Controller,
      decoration: const InputDecoration(
        labelText: 'Base64',
      ),
    );
  }
}

class _Location extends HookConsumerWidget {
  const _Location({
    required this.locationController,
    required this.cwd,
  });

  final TextEditingController locationController;
  final String cwd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider(cwd));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          locationController.text = state.location;
        });

        return null;
      },
      const [],
    );
    return TextFormField(
      controller: locationController,
      decoration: const InputDecoration(
        labelText: '/path/to/file',
      ),
    );
  }
}

class _Title extends HookConsumerWidget {
  const _Title({
    required this.titleController,
    required this.cwd,
  });

  final TextEditingController titleController;
  final String cwd;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider(cwd));
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          titleController.text = state.title;
        });

        return null;
      },
      const [],
    );
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
      ),
    );
  }
}
