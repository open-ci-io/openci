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

Future<void> showDeleteDialog({
  required String title,
  required BuildContext context,
  required void Function() onDelete,
}) {
  return showAdaptiveDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: const Text(
        'Are you sure you want to delete this item?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
