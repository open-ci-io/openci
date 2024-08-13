import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/constants/colors.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/workflow.dart';

class DottedEmptyBox extends StatelessWidget {
  const DottedEmptyBox({
    super.key,
    required this.targetColor,
  });

  final Color targetColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: targetRectKeySignal.value,
      height: 300,
      width: 340,
      child: DottedBorder(
        dashPattern: const [
          6,
          3,
        ],
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        color: targetColor,
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
    );
  }
}
