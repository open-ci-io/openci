import 'package:dashboard/colors.dart';
import 'package:flutter/material.dart';

class OpenCIAlertDialog extends StatelessWidget {
  const OpenCIAlertDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmButtonText,
    required this.onConfirm,
  });

  final String title;
  final String body;
  final String confirmButtonText;
  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmButtonText,
            style: const TextStyle(
              color: OpenCIColors.error,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
