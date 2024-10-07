import 'package:openci_models/openci_models.dart';
import 'package:runner/src/commands/signals.dart';

Future<WorkflowModelV2> fetchWorkflow(String workflowId) async {
  final firestore = nonNullFirestoreClientSignal.value;
  final docs = await firestore.collection('workflows').doc(workflowId).get();
  return WorkflowModelV2.fromJson(docs.data()!);
}
