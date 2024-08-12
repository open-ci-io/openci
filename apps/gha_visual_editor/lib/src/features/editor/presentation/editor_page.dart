import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:signals/signals_flutter.dart';

final borderColor = signal(AppColors.borderBlack);
final secondBorderColor = signal(Colors.transparent);
final isFocused = signal(false);

class DraggableArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  DraggableArrowPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // 矢印の本体を描画
    canvas.drawLine(start, end, paint);

    // 矢印の先端を描画
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

class DraggableArrowWidget extends StatefulWidget {
  const DraggableArrowWidget({super.key});

  @override
  _DraggableArrowWidgetState createState() => _DraggableArrowWidgetState();
}

class _DraggableArrowWidgetState extends State<DraggableArrowWidget> {
  Offset _start = Offset.zero;
  Offset _end = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _start = details.localPosition;
          _end = details.localPosition;
          _isDragging = true;
        });
      },
      onPanUpdate: (details) {
        if (_isDragging) {
          setState(() {
            _end = details.localPosition;
          });
        }
      },
      onPanEnd: (_) {
        setState(() {
          _isDragging = false;
        });
      },
      child: CustomPaint(
        painter: DraggableArrowPainter(start: _start, end: _end),
        child: Container(),
      ),
    );
  }
}
