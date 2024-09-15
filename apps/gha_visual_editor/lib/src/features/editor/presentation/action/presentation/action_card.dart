import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/action/domain/action_model.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/connector_dot.dart';

final _borderColor = Colors.grey[300]!;

const _height = 400.0;

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.dotKey,
    required this.action,
    required this.index,
  });

  final GlobalKey dotKey;
  final ActionModel action;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: _height,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 340,
              height: _height - 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _borderColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(title: action.title),
                  Divider(
                    color: Colors.grey[300]!,
                    height: 1.5,
                  ),
                  _Body(action: action),
                  Divider(
                    color: Colors.grey[300]!,
                    height: 1.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      // showAdaptiveDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: const Text('Configure action'),
                      //       content: SizedBox(
                      //         height: 600,
                      //         child: ConfigureActions(
                      //           onTap: () {
                      //             Navigator.pop(context);
                      //           },
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 24.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      width: double.infinity,
                      height: 45.0,
                      child: const Center(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: AppColors.bluePoint,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConnectorDot(
              key: dotKey,
              borderColor: _borderColor,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConnectorDot(
              borderColor: _borderColor,
              dotPaddingColor: Colors.white,
              dotColor: AppColors.bluePoint,
              drawTop: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.action,
  });

  final ActionModel action;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          children: [
            _Row(
              title: 'uses',
              value: action.uses,
            ),
            verticalMargin10,
            Expanded(
              child: ListView.builder(
                itemCount: action.properties.length,
                itemBuilder: (context, index) {
                  final data = action.properties[index];
                  return _Row(title: data.label, value: data.value);
                },
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // horizontalMargin24,
                // SizedBox(
                //   width: 62,
                //   child: Text(
                //     'secrets',
                //     style: TextStyle(
                //       color: Colors.black54,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                // horizontalMargin24,
                // Icon(Icons.lock_outline,
                //     color: Colors.green, size: 20),
                // Text(
                //   'ANY_TOKENS',
                //   style: TextStyle(
                //     color: Colors.green,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 24),
        SizedBox(
          width: 66,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        horizontalMargin24,
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
