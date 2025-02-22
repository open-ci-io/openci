import 'dart:ui';

import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class StepsSection extends HookConsumerWidget {
  const StepsSection(this.workflowModel, this.firebaseSuite, {super.key});

  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite).notifier,
    );
    final state = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite),
    );
    final steps = state.steps;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final stepTitleEditingController = useTextEditingController();
    final stepCommandEditingController = useTextEditingController();

    final cards = <Card>[
      for (int index = 0; index < steps.length; index += 1)
        Card(
          key: Key('$index'),
          color: colorScheme.surfaceBright,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              stepTitleEditingController.text = steps[index].name;
              stepCommandEditingController.text = steps[index].command;
              showAdaptiveDialog<void>(
                barrierDismissible: true,
                context: context,
                builder: (context) => _DialoBody(
                  stepTitleEditingController: stepTitleEditingController,
                  stepCommandEditingController: stepCommandEditingController,
                  controller: controller,
                  stepIndex: index,
                ),
              );
            },
            child: SizedBox(
              height: 80,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      steps[index].name,
                      style: textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    verticalMargin8,
                    Text(
                      steps[index].command,
                      style: textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w100,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ];

    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final animValue = Curves.easeInOut.transform(animation.value);
          final elevation = lerpDouble(1, 6, animValue)!;
          final scale = lerpDouble(1, 1.02, animValue)!;
          final card = cards[index];
          return Transform.scale(
            scale: scale,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  width: 0.6,
                  color: colorScheme.primary,
                ),
              ),
              elevation: elevation,
              color: card.color,
              child: card.child,
            ),
          );
        },
        child: child,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            'Steps',
            style: textTheme.titleMedium,
          ),
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: ReorderableListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                proxyDecorator: proxyDecorator,
                onReorder: (int oldIndex, int newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  controller.reorderStep(oldIndex, newIndex);
                },
                children: cards,
              ),
            ),
            verticalMargin10,
            IconButton(
              onPressed: () {
                controller.addStepByIndex(steps.length);
              },
              icon: Icon(
                Icons.add_sharp,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DialoBody extends ConsumerWidget {
  const _DialoBody({
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
    final screenWidth = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    const textFieldWidth = 0.6;

    return Dialog(
      child: SizedBox(
        width: screenWidth * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Step',
                    style: textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              verticalMargin24,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // controller.removeStep(stepIndex);
                      // Navigator.of(context).pop();
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
              ),
            ],
          ),
        ),
      ),
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
