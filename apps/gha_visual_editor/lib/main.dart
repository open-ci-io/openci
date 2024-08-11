import 'dart:math';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:signals/signals_flutter.dart';

void main() {
  runApp(const MyApp());
}

final borderColor = signal(AppColors.borderBlack);
final secondBorderColor = signal(Colors.transparent);
final isFocused = signal(false);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                isFocused.value = !isFocused.value;
                borderColor.value = isFocused.value
                    ? AppColors.focusedBorderBlue
                    : AppColors.borderBlack;
                secondBorderColor.value = isFocused.value
                    ? AppColors.focusedBorderPaddingBlue
                    : Colors.transparent;
              },
              child: const _Card(),
            ),
            const SizedBox(height: 16),
            Icon(
              key: UniqueKey(),
              FontAwesomeIcons.arrowDown,
              color: AppColors.bluePoint,
              size: 18,
            ),
            const SizedBox(height: 80),
            SizedBox(
              height: 300,
              width: 340,
              child: DottedBorder(
                dashPattern: const [
                  6,
                  3,
                ],
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                color: AppColors.dotGray,
                strokeWidth: 1.5,
                child: const Center(
                  child: Text(
                    'Drag the blue connector here to \ncreate your first action.',
                    style: TextStyle(
                        color: AppColors.dotGray,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => Container(
        width: 340,
        height: 145,
        color: Colors.transparent,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: secondBorderColor.value,
                    width: 4,
                  ), // 外側のボーダー
                ),
                child: Container(
                  width: 340,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.firstStepDarkGray,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: borderColor.value,
                      width: 1.5, // Set border width to 1 pixel
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Flutter Build APK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
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
                                text: 'push',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(
                        color: AppColors.borderBlack,
                        thickness: 1.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 4),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: SemicircleBorderWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class SemicircleBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color outerBorderColor;

  SemicircleBorderPainter({
    required this.borderColor,
    required this.outerBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.firstStepDarkGray
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 最も外側のボーダーを描画
    final Paint outerBorderPaint = Paint()
      ..color = outerBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final outerRect = Rect.fromCircle(
      center: center,
      radius: radius + 2.3, // 元の円より外側に
    );

    canvas.drawArc(
      outerRect,
      0,
      pi,
      false,
      outerBorderPaint,
    );

    // 内側のボーダーを描画（元の円の外側）
    final Paint innerBorderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final innerRect = Rect.fromCircle(
      center: center,
      radius: radius + 0.5, // 最も外側のボーダーより少し内側
    );

    canvas.drawArc(
      innerRect,
      0,
      pi,
      false,
      innerBorderPaint,
    );

    // 元の円を描画
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SingleBorderPainter extends CustomPainter {
  SingleBorderPainter(this.borderColor);
  final Color borderColor;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.firstStepDarkGray
      ..style = PaintingStyle.fill;

    // 円全体を描画
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // 下半分のボーダーを描画
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    canvas.drawArc(
      rect,
      0, // 開始角度（ラジアン）
      pi, // 終了角度（ラジアン、πは半円）
      false,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SemicircleBorderWidget extends StatelessWidget {
  const SemicircleBorderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => SizedBox(
        width: 22,
        height: 22,
        child: CustomPaint(
          painter: isFocused.value
              ? SemicircleBorderPainter(
                  borderColor: borderColor.value,
                  outerBorderColor: secondBorderColor.value,
                )
              : SingleBorderPainter(borderColor.value),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.bluePoint,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
