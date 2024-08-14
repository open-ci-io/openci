import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/arrow_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_card.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_connector_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/choose_action.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/configure_action.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/dotted_empty_box.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/first_action_card.dart';
import 'package:signals/signals_flutter.dart';

final startCircleKeySignal = signal(GlobalKey());
final targetRectKeySignal = signal(GlobalKey());
final showChooseActionSheet = signal(false);
final showNextStepSignal = signal(false);

final selectedAction = signal<Map<String, String>>({});
final showConfigureActionSheet = signal(false);
final showFirstArrowSignal = signal(false);
final showFirstFlexibleArrowSignal = signal(true);

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Offset? _arrowStart;
  Offset? _arrowEnd;
  bool _isDragging = false;
  bool _isTargetHit = false;
  Color _targetColor = AppColors.dotGray;

  Rect? _startCircleRect;
  Rect? _targetRect;

  final GlobalKey keyA = GlobalKey();
  final GlobalKey keyB = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateRects());
  }

  void _updateRects() {
    setState(() {
      _startCircleRect = _getRectFromKey(startCircleKeySignal.value);
      _targetRect = _getRectFromKey(targetRectKeySignal.value);
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
          _targetColor = Colors.green;
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
      _targetColor = AppColors.dotGray;
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
            painter: ActionConnectorPainter(
              startKey: keyA,
              endKey: keyB,
            ),
          ),
          Visibility(
            visible: showFirstFlexibleArrowSignal.value,
            child: CustomPaint(
              painter: _arrowStart != null && _arrowEnd != null
                  ? ArrowPainter(start: _arrowStart!, end: _arrowEnd!)
                  : null,
              child: Container(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
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
                      if (_isTargetHit) {
                        showChooseActionSheet.value = true;
                      }
                    },
                    child: FirstActionCard(
                      dotKey: keyA,
                    ),
                  ),
                  verticalMargin16,
                  Visibility(
                    visible: showFirstArrowSignal.value,
                    child: Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _arrowStart == null,
                      child: Icon(
                        key: UniqueKey(),
                        FontAwesomeIcons.arrowDown,
                        color: AppColors.bluePoint,
                        size: 18,
                      ),
                    ),
                  ),
                  verticalMargin40,
                  Watch(
                    (context) => Visibility(
                      visible: showNextStepSignal.value,
                      child: ActionCard(
                        dotKey: keyB,
                      ),
                    ),
                  ),
                  verticalMargin40,
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
                      });
                    },
                    onPanUpdate: (details) {
                      if (_isDragging) {
                        final renderBox =
                            context.findRenderObject() as RenderBox;
                        final localPosition =
                            renderBox.globalToLocal(details.globalPosition);
                        _updateArrowAndTarget(localPosition);
                      }
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isDragging = false;
                        if (_isTargetHit) {
                          _targetColor = Colors.green;
                        }
                      });
                    },
                    child: DottedEmptyBox(
                      targetColor: _targetColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Watch(
            (context) => Visibility(
              visible: showChooseActionSheet.value,
              child: const Align(
                alignment: Alignment.centerRight,
                child: ChooseAction(),
              ),
            ),
          ),
          Watch(
            (context) => Visibility(
              visible: showConfigureActionSheet.value,
              child: Align(
                alignment: Alignment.centerRight,
                child: ConfigureActions(
                  clearArrow: () {
                    _clearArrow();
                    showFirstFlexibleArrowSignal.value = false;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
