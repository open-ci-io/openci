import 'package:dashboard/src/common_widgets/dialogs/alert_dialog.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.title,
    required this.onDelete,
  });

  final String title;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return OpenCIAlertDialog(
      title: title,
      body: 'Are you sure you want to delete this item?',
      confirmButtonText: 'Delete',
      onConfirm: () async {
        await onDelete();
        Navigator.of(context).pop();
      },
    );
  }
}
