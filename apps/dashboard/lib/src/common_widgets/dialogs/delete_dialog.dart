import 'package:flutter/material.dart';

Future<void> showDeleteDialog({
  required String title,
  required BuildContext context,
  required void Function() onDelete,
}) {
  return showAdaptiveDialog<void>(
    context: context,
    builder: (context) => DeleteDialog(title: title, onDelete: onDelete),
  );
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.title,
    required this.onDelete,
  });

  final String title;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}
