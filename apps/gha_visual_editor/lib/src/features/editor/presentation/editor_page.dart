import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/action_list.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/action/domain/action_model.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/action/presentation/action_card.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_connector_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_action/presentation/configure_action.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/first_action_card.dart';
import 'package:signals/signals_flutter.dart';

String convertToYaml(Map<String, dynamic> map) {
  final StringBuffer yaml = StringBuffer();

  yaml.writeln('name: ${map['name']}');
  yaml.writeln('uses: ${map['uses']}');

  final properties = map['properties'];
  if (properties != null && properties.isNotEmpty) {
    yaml.writeln('with:');
    for (final property in properties) {
      final label =
          property['label'].toString().toLowerCase().replaceAll(' ', '-');
      yaml.writeln('  $label: ${property['value']}');
    }
  }

  return yaml.toString();
}

final actionsList = [
  ActionList.installFlutter,
  ActionList.checkoutCode,
  ActionList.flutterPubGet,
];

final savedActionList = listSignal(<ActionModel>[]);
final keyListSignal = listSignal([GlobalKey()]);

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.grayBackground,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.download),
            ),
            verticalMargin10,
            FloatingActionButton(
              onPressed: () {
                showAdaptiveDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Choose action'),
                      content: SizedBox(
                        width: 400,
                        height: 350,
                        child: Column(
                          children: List.generate(
                            actionsList.length,
                            (index) {
                              final action = actionsList[index];

                              return ListTile(
                                title: Text(action.title),
                                subtitle: Text(action.name),
                                onTap: () {
                                  Navigator.pop(context);
                                  showAdaptiveDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Configure action'),
                                        content: SizedBox(
                                          height: 600,
                                          child: ConfigureActions(
                                            action: action,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        body: Watch((context) {
          final keyList = keyListSignal.value;
          return Stack(
            children: [
              ListView.builder(
                itemCount: keyList.length - 1,
                itemBuilder: (context, index) {
                  return CustomPaint(
                    painter: ActionConnectorPainter(
                      startKey: keyList[index],
                      endKey: keyList[index + 1],
                    ),
                    child: const SizedBox(
                      height: 10,
                      width: 10,
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: keyList.length,
                itemBuilder: (context, index) {
                  final key = keyList[index];
                  if (index == 0) {
                    return Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FirstActionCard(
                              dotKey: key,
                            ),
                            verticalMargin40,
                          ],
                        ),
                      ),
                    );
                  }
                  final actionCardIndex = index - 1;
                  return Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (actionsList.isNotEmpty)
                            ActionCard(
                              dotKey: key,
                              action: savedActionList[actionCardIndex],
                              index: actionCardIndex,
                            ),
                          verticalMargin40,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }));
  }
}
