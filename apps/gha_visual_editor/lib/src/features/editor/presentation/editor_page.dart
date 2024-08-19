import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_card.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_connector_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_list.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/configure_action.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/first_action_card.dart';
import 'package:signals/signals_flutter.dart';

final showNextStepSignal = signal(false);

final selectedAction = signal<Map<String, String>>({});

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  List<GlobalKey> keyList = [GlobalKey()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Choose action'),
                content: SizedBox(
                  height: 350,
                  child: Column(
                    children: List.generate(actionList.length, (index) {
                      final title = actionList[index]['title'] as String;
                      final actionName =
                          actionList[index]['actionName'] as String;
                      return ListTile(
                        title: Text(title),
                        subtitle: Text(actionName),
                        onTap: () {
                          selectedAction.value = {
                            'title': title,
                            'actionName': actionName
                          };
                          Navigator.pop(context);
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Configure action'),
                                content: SizedBox(
                                  height: 350,
                                  child: ConfigureActions(
                                    onTap: () {
                                      setState(() {
                                        keyList.add(GlobalKey());
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Next'),
                  ),
                ],
              );
            },
          );
          // setState(() {
          //   keyList.add(GlobalKey());
          // });
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(
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
              return Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionCard(
                        dotKey: key,
                      ),
                      verticalMargin40,
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
