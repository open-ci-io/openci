import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'workflow_page_controller.g.dart';

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

  Future<void> deleteWorkflow(String docId) async {
    await FirebaseFirestore.instance
        .collection('workflows')
        .doc(docId)
        .delete();
  }
}
