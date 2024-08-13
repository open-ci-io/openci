import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/constants/margins.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/arrow_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_card.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_connector_painter.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_list.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/dotted_empty_box.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/first_action_card.dart';
import 'package:signals/signals_flutter.dart';

final startCircleKeySignal = signal(GlobalKey());
final targetRectKeySignal = signal(GlobalKey());
final showChooseActionSheet = signal(false);
final showNextStepSignal = signal(false);

final isFocused = signal(false);
final borderColor = signal(AppColors.borderBlack);
final secondBorderColor = signal(Colors.transparent);

final selectedAction = signal<Map<String, String>>({});
final showConfigureActionSheet = signal(false);
final showFirstArrowSignal = signal(false);

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
          CustomPaint(
            painter: _arrowStart != null && _arrowEnd != null
                ? ArrowPainter(start: _arrowStart!, end: _arrowEnd!)
                : null,
            child: Container(),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
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
                  const SizedBox(height: 16),
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
                  clearArrow: () => _clearArrow(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseAction extends StatelessWidget {
  const ChooseAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: Container(
        height: 600,
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose action',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    showChooseActionSheet.value = false;
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: actionList.length,
                itemBuilder: (context, index) {
                  final title = actionList[index]['title'] as String;
                  final actionName = actionList[index]['actionName'] as String;
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(actionName),
                    onTap: () {
                      showChooseActionSheet.value = false;
                      selectedAction.value = {
                        'title': title,
                        'actionName': actionName
                      };
                      showConfigureActionSheet.value = true;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSecretItem(String label, {bool showDelete = false}) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        const Icon(Icons.lock, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label),
        if (showDelete) ...[
          const Spacer(),
          const Icon(Icons.delete, size: 16, color: Colors.grey),
        ],
      ],
    );
  }
}

class ConfigureActions extends StatelessWidget {
  const ConfigureActions({
    super.key,
    required this.clearArrow,
  });

  final VoidCallback clearArrow;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => Padding(
        padding: const EdgeInsets.only(right: 32.0),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Configure action',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      showConfigureActionSheet.value = false;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.inventory_2, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAction.value['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'View source',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildConfigItem('uses', selectedAction.value['title']!),
              // _buildConfigItem('label', 'Run NPM Test'),
              // _buildConfigItem('runs', 'Overrides ENTRYPOINT'),
              // _buildConfigItem('args', 'test'),
              // const SizedBox(height: 16),
              // const Text(
              //   'secrets',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const Text(
              //   'Secrets are environment variables that are encrypted and available only when this action executes.',
              //   style: TextStyle(fontSize: 12, color: Colors.grey),
              // ),
              // const SizedBox(height: 8),
              // _buildSecretItem('GITHUB_TOKEN'),
              // _buildSecretItem('NPM_AUTH_TOKEN', showDelete: true),
              // const SizedBox(height: 8),
              // const Text(
              //   'Create a new secret',
              //   style: TextStyle(color: Colors.blue),
              // ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      clearArrow();
                      showConfigureActionSheet.value = false;
                      showNextStepSignal.value = true;
                      showFirstArrowSignal.value = false;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSecretItem(String label, {bool showDelete = false}) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        const Icon(Icons.lock, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label),
        if (showDelete) ...[
          const Spacer(),
          const Icon(Icons.delete, size: 16, color: Colors.grey),
        ],
      ],
    );
  }
}
