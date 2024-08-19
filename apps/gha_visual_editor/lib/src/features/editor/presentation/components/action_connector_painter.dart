import 'package:flutter/material.dart';

class ActionConnectorPainter extends CustomPainter {
  final GlobalKey startKey;
  final GlobalKey endKey;

  ActionConnectorPainter({required this.startKey, required this.endKey}) {
    print('ActionConnectorPainter が初期化されました'); // コンストラクタに追加
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('ActionConnectorPainter の paint メソッドが呼び出されました'); // paint メソッドの先頭に追加

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

      print('Start center: $startCenter'); // ここに print 文を追加
      print('End center: $endCenter'); // ここに print 文を追加

      canvas.drawLine(startCenter, endCenter, paint);
    } else {
      print('startBox or endBox is null'); // エラーチェックのための print 文
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
