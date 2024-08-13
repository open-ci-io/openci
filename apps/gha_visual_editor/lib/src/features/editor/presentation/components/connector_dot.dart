import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:signals/signals_flutter.dart';

class ConnectorDot extends StatelessWidget {
  const ConnectorDot(
      {super.key,
      this.dotColor = Colors.grey,
      this.borderColor = Colors.grey,
      this.dotPaddingColor = AppColors.lightGray,
      this.drawTop = true});

  final Color dotColor;
  final Color borderColor;
  final Color dotPaddingColor;
  final bool drawTop;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => SizedBox(
        width: 22,
        height: 22,
        child: CustomPaint(
          painter: _BorderPainter(
            borderColor: borderColor,
            dotPaddingColor: dotPaddingColor,
            drawTop: drawTop,
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter({
    required this.borderColor,
    required this.dotPaddingColor,
    this.drawTop = true,
  });
  final Color borderColor;
  final Color dotPaddingColor;
  final bool drawTop;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dotPaddingColor
      ..style = PaintingStyle.fill;

    // 円全体を描画
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);

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
      drawTop ? -pi : pi, // 終了角度（ラジアン、πは半円）
      false,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
