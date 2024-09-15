import 'package:flutter/material.dart';

class ActionConnectorPainter extends CustomPainter {
  final GlobalKey startKey;
  final GlobalKey endKey;

  ActionConnectorPainter({required this.startKey, required this.endKey});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 5;

    final startBox = startKey.currentContext?.findRenderObject() as RenderBox?;
    final endBox = endKey.currentContext?.findRenderObject() as RenderBox?;

    if (startBox != null && endBox != null) {
      final startCenter =
          startBox.localToGlobal(startBox.size.topCenter(Offset.zero));
      final endCenter =
          endBox.localToGlobal(endBox.size.topCenter(Offset.zero));

      canvas.drawLine(startCenter, endCenter, paint);
    } else {
      throw Exception('startBox or endBox is null');
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
