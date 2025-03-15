import 'package:dashboard/src/common_widgets/dialogs/custom_wolt_modal_dialog.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/presentation/select_secret.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/dialogs/presentation/select_step_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:dashboard/src/services/firestore/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage selectBase64AndLocation(
  BuildContext context,
  WorkflowEditorController workflowEditorController,
) {
  final titleController = TextEditingController();
  final base64Controller = TextEditingController();
  final locationController = TextEditingController();

  void updateState(WidgetRef ref) {
    ref.read(selectStepControllerProvider.notifier)
      ..setTitle(titleController.text)
      ..setLocation(locationController.text)
      ..setBase64(base64Controller.text);
  }

  return baseDialog(
    modalSheetContext: context,
    title: 'Select Base64 and Location',
    child: (ref) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Title'),
          verticalMargin8,
          _Title(
            titleController: titleController,
          ),
          verticalMargin16,
          const Text('Base64'),
          verticalMargin8,
          _Base64(
            base64Controller: base64Controller,
          ),
          verticalMargin8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  updateState(ref);
                  WoltModalSheet.of(context).pushPage(
                    importSecrets(context),
                  );
                },
                child: const Text('Import from Secrets'),
              ),
              TextButton(
                onPressed: () async {
                  final result = await pickFileAsBase64();
                  if (result == null) {
                    return;
                  }
                  base64Controller.text = result;
                },
                child: const Text('Select a File'),
              ),
            ],
          ),
          verticalMargin16,
          const Text('File Location'),
          verticalMargin8,
          _Location(
            locationController: locationController,
          ),
        ],
      );
    },
    onBack: (ref) {
      updateState(ref);
      WoltModalSheet.of(context).popPage();
    },
    nextButtonText: (ref) => const Text(
      'Finish',
      style: TextStyle(fontWeight: FontWeight.w300),
    ),
    onNext: (ref, formKey) {
      if (!formKey.currentState!.validate()) {
        return;
      }
      updateState(ref);
      final state = ref.read(selectStepControllerProvider);
      workflowEditorController.addStep(
        name: state.title,
        command: 'echo ${state.base64} | base64 -d > ${state.location}',
      );
      Navigator.pop(context);
    },
  );
}

class _Base64 extends HookConsumerWidget {
  const _Base64({
    required this.base64Controller,
  });

  final TextEditingController base64Controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider);
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Base64 is required';
        }
        return null;
      },
    );
  }
}

class _Location extends HookConsumerWidget {
  const _Location({
    required this.locationController,
  });

  final TextEditingController locationController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider);
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
  });

  final TextEditingController titleController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectStepControllerProvider);
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Title is required';
        }
        return null;
      },
    );
  }
}
