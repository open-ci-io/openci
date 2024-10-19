import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/features/workflow/domain/workflow_model.dart';
import 'package:dashboard/src/features/workflow/presentation/edit_workflow_dialog.dart';
import 'package:flutter/material.dart';

class WorkflowCard extends StatelessWidget {
  const WorkflowCard({super.key, required this.workflow, required this.index});
  final WorkflowModel workflow;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.blue),
      ),
      child: ExpansionTile(
        expansionAnimationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.blue),
        ),
        title: Text(workflow.name),
        subtitle: Text('Flutter: ${workflow.flutter.version}'),
        children: [
          ListTile(
            title: Text('GitHub: ${workflow.github.repositoryUrl}'),
          ),
          ListTile(
            title: Text('Trigger Type: ${workflow.github.triggerType.name}'),
          ),
          const ListTile(title: Text('Steps:')),
          ...workflow.steps.map<Widget>(
            (step) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ListTile(
                title: Text(step.name),
                subtitle: Text(step.commands.join(', ')),
              ),
            ),
          ),
          OverflowBar(
            children: [
              TextButton(
                onPressed: () =>
                    _showWorkflowDialog(context, workflow: workflow),
                child: const Text('Edit'),
              ),
              Visibility(
                visible: index != 0,
                child: TextButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWorkflowDialog(BuildContext context, {WorkflowModel? workflow}) {
    showDialog<void>(
      context: context,
      builder: (context) => EditWorkflowDialog(workflow),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Workflow',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete ${workflow.name}?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseFirestore.instance
                  .collection('workflows')
                  .doc(workflow.id)
                  .delete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
