import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/workflow/presentation/workflow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const Scaffold(
        backgroundColor: AppColors.grayBackground,
        body: Workflow(),
      ),
    );
  }
}

class ConnectedTexts extends StatelessWidget {
  final GlobalKey textAKey = GlobalKey();
  final GlobalKey textBKey = GlobalKey();

  ConnectedTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected Texts')),
      body: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          children: [
            Positioned(
              left: 50,
              top: 100,
              child: Container(
                key: textAKey,
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 10,
              child: Container(
                key: textBKey,
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            CustomPaint(
              painter: LinePainter(
                startKey: textAKey,
                endKey: textBKey,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print(textAKey.globalPaintBounds);
                  print(
                      'textAKey.globalPaintBounds?.center: ${textAKey.globalPaintBounds?.bottomCenter}');
                },
                child: const Text('get coordinates'))
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final GlobalKey startKey;
  final GlobalKey endKey;

  LinePainter({required this.startKey, required this.endKey});

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
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
