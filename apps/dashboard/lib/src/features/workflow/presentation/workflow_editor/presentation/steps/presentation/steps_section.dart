import 'dart:ui';

import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/steps/presentation/edit_step_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                builder: (context) => EditStepDialog(
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
                // controller.addStepByIndex(steps.length);
                showDialog(
                  context: context,
                  builder: (context) => const ChooseStepTemplate(),
                );
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

class ChooseStepTemplate extends StatelessWidget {
  const ChooseStepTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return OpenCIDialog(
      title: Text(
        'Choose a template',
        style: textTheme.titleLarge,
      ),
      children: [
        TextButton(
          onPressed: () {},
          child: const ListTile(
            title: Text('Convert Base64 to File'),
            leading: Icon(FontAwesomeIcons.bolt),
          ),
        ),
        verticalMargin8,
        TextButton(
          onPressed: () {},
          child: const ListTile(
            title: Text('From scratch'),
            leading: Icon(FontAwesomeIcons.pen),
          ),
        ),
        verticalMargin16,
      ],
    );
  }
}
