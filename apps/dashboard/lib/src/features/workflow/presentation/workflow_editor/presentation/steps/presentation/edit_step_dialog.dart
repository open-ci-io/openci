import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditStepDialog extends ConsumerWidget {
  const EditStepDialog({
    super.key,
    required this.stepTitleEditingController,
    required this.stepCommandEditingController,
    required this.controller,
    required this.stepIndex,
  });

  final TextEditingController stepTitleEditingController;
  final TextEditingController stepCommandEditingController;
  final WorkflowEditorController controller;
  final int stepIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const textFieldWidth = 0.6;

    return OpenCIDialog(
      title: Text(
        'Edit Step',
        style: textTheme.titleLarge,
      ),
      children: [
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            labelText: 'Title',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldWidth,
                color: colorScheme.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldWidth,
                color: colorScheme.primary,
              ),
            ),
          ),
          controller: stepTitleEditingController,
        ),
        verticalMargin16,
        TextField(
          minLines: 10,
          maxLines: null,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            labelText: 'Command',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldWidth,
                color: colorScheme.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldWidth,
                color: colorScheme.primary,
              ),
            ),
          ),
          controller: stepCommandEditingController,
        ),
        verticalMargin24,
        _BottomButtons(
          controller: controller,
          stepIndex: stepIndex,
          textTheme: textTheme,
          colorScheme: colorScheme,
          stepCommandEditingController: stepCommandEditingController,
          stepTitleEditingController: stepTitleEditingController,
        ),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    required this.controller,
    required this.stepIndex,
    required this.textTheme,
    required this.colorScheme,
    required this.stepCommandEditingController,
    required this.stepTitleEditingController,
  });

  final WorkflowEditorController controller;
  final int stepIndex;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final TextEditingController stepCommandEditingController;
  final TextEditingController stepTitleEditingController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) {
                return _DeleteStepConfirmationDialog(
                  controller: controller,
                  stepIndex: stepIndex,
                );
              },
            );
          },
          child: Text(
            'Delete',
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        horizontalMargin16,
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        horizontalMargin16,
        TextButton(
          onPressed: () {
            controller
              ..updateCommand(
                stepIndex,
                stepCommandEditingController.text,
              )
              ..updateStepName(
                stepIndex,
                stepTitleEditingController.text,
              );
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteStepConfirmationDialog extends StatelessWidget {
  const _DeleteStepConfirmationDialog({
    required this.controller,
    required this.stepIndex,
  });

  final WorkflowEditorController controller;
  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Delete Step'),
      content: const Text(
        'Are you sure you want to delete this step?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w300,
              color: colorScheme.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            controller.removeStep(stepIndex);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            'Delete',
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w300,
              color: colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
