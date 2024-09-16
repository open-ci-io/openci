import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/configure_first_action.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/connector_dot.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FirstActionCard extends ConsumerWidget {
  const FirstActionCard({
    super.key,
    required this.dotKey,
  });

  final GlobalKey dotKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editorControllerProvider);
    final firstAction = state.firstAction;

    final workflow = firstAction.workflow;
    final run = firstAction.run;
    final branch = firstAction.branch;
    final buildMachine = firstAction.buildMachine;

    return Container(
      width: 340,
      height: 155,
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.transparent,
                  width: 4,
                ),
              ),
              child: Container(
                width: 340,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.firstStepDarkGray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderBlack,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalMargin16,
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        workflow.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    verticalMargin4,
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'on ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: '${run.value} ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: '-> ${branch.value}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalMargin4,
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'build-machine: ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: buildMachine.value,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalMargin12,
                    const Divider(
                      color: AppColors.borderBlack,
                      thickness: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            showAdaptiveDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Configure Workflow'),
                                  content: SizedBox(
                                    height: 420,
                                    child: ConfigureFirstAction(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConnectorDot(
              key: dotKey,
              dotColor: AppColors.bluePoint,
              borderColor: AppColors.borderBlack,
              dotPaddingColor: AppColors.firstStepDarkGray,
              drawTop: false,
            ),
          ),
        ],
      ),
    );
  }
}
