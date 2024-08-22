import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/action/presentation/action_card.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_connector_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_action/domain/flutter_action_model.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_action/presentation/configure_action.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/first_action_card.dart';
import 'package:signals/signals_flutter.dart';

final showNextStepSignal = signal(false);
final selectedActionSignal = signal<Signal<FlutterActionModel>?>(null);
final installFlutterSignal = signal(const FlutterActionModel());
final actionList = listSignal([installFlutterSignal]);

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
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Choose action'),
                content: SizedBox(
                  width: 400,
                  height: 350,
                  child: Column(
                    children: List.generate(actionList.length, (index) {
                      final actionSignal = actionList[index];
                      final action = actionSignal.value;

                      return ListTile(
                        title: Text(action.title),
                        subtitle: Text(action.name),
                        onTap: () {
                          selectedActionSignal.value = actionSignal;
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
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
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
