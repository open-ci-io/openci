import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_card.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_connector_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/first_action_card.dart';
import 'package:signals/signals_flutter.dart';

final showChooseActionSheet = signal(false);
final showNextStepSignal = signal(false);

final selectedAction = signal<Map<String, String>>({});
final showConfigureActionSheet = signal(false);
final showFirstArrowSignal = signal(false);
final showFirstFlexibleArrowSignal = signal(true);

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  List<GlobalKey> keyList = [GlobalKey()];
  @override
  Widget build(BuildContext context) {
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
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  keyList.add(GlobalKey());
                });
              },
              child: const Text('Next'),
            ),
          ),
        ),
      ],
    );
  }
}
