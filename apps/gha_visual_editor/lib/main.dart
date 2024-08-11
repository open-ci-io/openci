import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      // home: const EditorPage(),
      home: const Scaffold(
        body: CircleToArrowWidget(),
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  ArrowPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
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

class CircleToArrowWidget extends StatefulWidget {
  const CircleToArrowWidget({super.key});

  @override
  _CircleToArrowWidgetState createState() => _CircleToArrowWidgetState();
}

class _CircleToArrowWidgetState extends State<CircleToArrowWidget> {
  Offset? _arrowStart;
  Offset? _arrowEnd;
  bool _isDragging = false;
  bool _isTargetHit = false;
  Color _targetColor = Colors.green;

  final GlobalKey _startCircleKey = GlobalKey();
  final GlobalKey _targetRectKey = GlobalKey();
  Rect? _startCircleRect;
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateRects());
  }

  void _updateRects() {
    setState(() {
      _startCircleRect = _getRectFromKey(_startCircleKey);
      _targetRect = _getRectFromKey(_targetRectKey);
    });
  }

  Rect? _getRectFromKey(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      return Rect.fromLTWH(
        position.dx,
        position.dy,
        renderBox.size.width,
        renderBox.size.height,
      );
    }
    return null;
  }

  bool _isInsideTarget(Offset point) {
    return _targetRect?.contains(point) ?? false;
  }

  bool _isInsideStartCircle(Offset point) {
    return _startCircleRect?.contains(point) ?? false;
  }

  void _updateArrowAndTarget(Offset newEnd) {
    if (!_isTargetHit) {
      setState(() {
        if (_isInsideTarget(newEnd)) {
          _arrowEnd = newEnd;
          _targetColor = Colors.red;
          _isTargetHit = true;
        } else {
          _arrowEnd = newEnd;
        }
      });
    }
  }

  void _clearArrow() {
    setState(() {
      _arrowStart = null;
      _arrowEnd = null;
      _isTargetHit = false;
      _targetColor = Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        if (!_isInsideStartCircle(details.globalPosition)) {
          _clearArrow();
        }
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: _arrowStart != null && _arrowEnd != null
                ? ArrowPainter(start: _arrowStart!, end: _arrowEnd!)
                : null,
            child: Container(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final localPosition =
                        renderBox.globalToLocal(details.globalPosition);
                    setState(() {
                      _arrowStart = localPosition;
                      _arrowEnd = localPosition;
                      _isDragging = true;
                      _isTargetHit = false;
                      _targetColor = Colors.green;
                    });
                  },
                  onPanUpdate: (details) {
                    if (_isDragging) {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final localPosition =
                          renderBox.globalToLocal(details.globalPosition);
                      _updateArrowAndTarget(localPosition);
                    }
                  },
                  onPanEnd: (_) {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  child: Container(
                    key: _startCircleKey,
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 300),
                Container(
                  key: _targetRectKey,
                  width: 400,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _targetColor.withOpacity(0.3),
                    border: Border.all(color: _targetColor, width: 2),
                  ),
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child: Container(
          //     key: _targetRectKey,
          //     width: 400,
          //     height: 100,
          //     decoration: BoxDecoration(
          //       color: _targetColor.withOpacity(0.3),
          //       border: Border.all(color: _targetColor, width: 2),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: GestureDetector(
          //     onPanStart: (details) {
          //       final RenderBox renderBox =
          //           context.findRenderObject() as RenderBox;
          //       final localPosition =
          //           renderBox.globalToLocal(details.globalPosition);
          //       setState(() {
          //         _arrowStart = localPosition;
          //         _arrowEnd = localPosition;
          //         _isDragging = true;
          //         _isTargetHit = false;
          //         _targetColor = Colors.green;
          //       });
          //     },
          //     onPanUpdate: (details) {
          //       if (_isDragging) {
          //         final RenderBox renderBox =
          //             context.findRenderObject() as RenderBox;
          //         final localPosition =
          //             renderBox.globalToLocal(details.globalPosition);
          //         _updateArrowAndTarget(localPosition);
          //       }
          //     },
          //     onPanEnd: (_) {
          //       setState(() {
          //         _isDragging = false;
          //       });
          //     },
          //     child: Container(
          //       key: _startCircleKey,
          //       width: 50,
          //       height: 50,
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Colors.red,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
