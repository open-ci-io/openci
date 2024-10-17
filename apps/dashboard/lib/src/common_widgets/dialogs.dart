import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String errorMessage) {
  return showAdaptiveDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Error',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      content: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
  );
}
