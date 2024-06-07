import 'package:dart_firebase_admin/firestore.dart';
import 'package:openci_models/openci_models.dart';
import 'package:runner/src/services/firebase/firestore/firestore_path.dart';

class WorkflowService {
  Future<WorkflowModel> getWorkflowData(
    Firestore firestore,
    String workflowId,
    String jobId,
  ) async {
    final workflowDocs = await firestore
        .collection(FirestorePath.workflowDomain)
        .doc(workflowId)
        .get();

    final workflowData = workflowDocs.data();
    if (workflowData == null) {
      throw Exception('Workflow data is null for job: $jobId');
    }
    return WorkflowModel.fromJson(workflowData);
  }
}
