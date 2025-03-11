import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String errorMessage) {
  return showAdaptiveDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => ErrorDialog(errorMessage: errorMessage),
  );
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(
        'Error',
        style: TextStyle(
          color: colorScheme.error,
        ),
      ),
      content: Text(
        errorMessage,
        style: TextStyle(
          color: colorScheme.error,
        ),
      ),
    );
  }
}
