import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/workflow/presentation/connector_dot.dart';
import 'package:signals/signals_flutter.dart';

final _borderColor = Colors.grey[300]!;

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.dotKey,
  });

  final GlobalKey dotKey;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => SizedBox(
        width: 340,
        height: 300,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 340,
                height: 280,
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
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      width: double.infinity,
                      height: 80,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 24.0),
                          child: Text(
                            'Install Flutter',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300]!,
                      height: 1.5,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      height: 150,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 24),
                                SizedBox(
                                  width: 66,
                                  child: Text(
                                    'uses',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24),
                                Text(
                                  'subosito/flutter-action',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 24),
                                SizedBox(
                                  width: 66,
                                  child: Text(
                                    'channel',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24),
                                Text(
                                  'stable',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 24),
                                SizedBox(
                                  width: 62,
                                  child: Text(
                                    'secrets',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24),
                                Icon(Icons.lock_outline,
                                    color: Colors.green, size: 20),
                                Text(
                                  'ANY_TOKENS',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300]!,
                      height: 1.5,
                    ),
                    Container(
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
      ),
    );
  }
}
