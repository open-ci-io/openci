import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/extensions/build_context_extension.dart';
import 'package:dashboard/src/features/workflow/domain/workflow_model.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkflowPage extends StatelessWidget {
  const WorkflowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OpenCI v0.2.0 - Workflow List',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
          horizontalMargin20,
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workflows').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final workflows = snapshot.data!.docs
              .map((e) =>
                  WorkflowModel.fromJson(e.data() as Map<String, dynamic>))
              .toList();
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: workflows.length,
                  itemBuilder: (_, index) {
                    final workflow = workflows[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: WorkflowCard(workflow: workflow),
                    );
                  },
                ),
                verticalMargin40,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: context.primaryColor,
                      width: 1,
                    ),
                  ),
                  onPressed: () async =>
                      _showWorkflowDialog(context, workflow: workflows.first),
                  child: const Text('New Workflow'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showWorkflowDialog(
    BuildContext context, {
    required WorkflowModel workflow,
  }) {
    showDialog(
      context: context,
      builder: (context) => WorkflowDialog(workflow),
    );
  }
}
