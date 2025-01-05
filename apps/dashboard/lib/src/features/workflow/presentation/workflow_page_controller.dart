import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'workflow_page_controller.g.dart';

@riverpod
Stream<QuerySnapshot> workflowStream(Ref ref) {
  return FirebaseFirestore.instance
      .collection('workflows')
      .where('owners', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('name')
      .snapshots();
}

@riverpod
class WorkflowPageController extends _$WorkflowPageController {
  @override
  void build() {
    return;
  }

  Future<void> addWorkflow() async {
    final ref = FirebaseFirestore.instance.collection('workflows').doc();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final workflow = WorkflowModel.empty(ref.id, uid);
    await ref.set(workflow.toJson());
  }

  Future<void> duplicateWorkflow(WorkflowModel workflow) async {
    final ref = FirebaseFirestore.instance.collection('workflows').doc();
    final newWorkflow = workflow.copyWith(
      id: ref.id,
      name: '${workflow.name} (Copy)',
    );
    await ref.set(newWorkflow.toJson());
  }

  Future<void> deleteWorkflow(String docId) async {
    await FirebaseFirestore.instance
        .collection('workflows')
        .doc(docId)
        .delete();
  }
}
