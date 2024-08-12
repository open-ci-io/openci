import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';

class ArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  ArrowPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.bluePoint
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    const arrowSize = 15.0;
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    final path = Path();
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowSize * cos(angle - pi / 6),
      end.dy - arrowSize * sin(angle - pi / 6),
    );
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowSize * cos(angle + pi / 6),
      end.dy - arrowSize * sin(angle + pi / 6),
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
