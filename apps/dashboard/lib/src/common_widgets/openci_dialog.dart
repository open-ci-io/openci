import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:flutter/material.dart';

class OpenCIDialog extends StatelessWidget {
  const OpenCIDialog({
    super.key,
    required this.title,
    required this.children,
    this.width,
  });

  final Text title;
  final List<Widget> children;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      child: SizedBox(
        width: width ?? screenWidth * 0.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  horizontalMargin8,
                  Expanded(
                    child: title,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              verticalMargin24,
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
