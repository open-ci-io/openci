import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:openci_models/openci_models.dart';

Future<QuerySnapshot<Map<String, dynamic>>?> getWorkflow(
  Firestore firestore,
  String workflowId,
) async {
  final qs = await firestore
      .collection('workflows')
      .where('id', WhereFilter.equal, workflowId)
      .get();
  if (qs.docs.isEmpty) {
    return null;
  }
  return qs;
}

Future<WorkflowModel?> getWorkflowModel(
  Firestore firestore,
  String workflowId,
) async {
  final qs = await getWorkflow(firestore, workflowId);
  if (qs == null) {
    return null;
  }
  return WorkflowModel.fromJson(qs.docs.first.data());
}
