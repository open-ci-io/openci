import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workflow_page_controller.g.dart';

@riverpod
class WorkflowPageController extends _$WorkflowPageController {
  @override
  void build(OpenCIFirebaseSuite firebaseSuite) {
    return;
  }

  Stream<List<WorkflowModel>> workflows() {
    final firestore = firebaseSuite.firestore;
    final auth = firebaseSuite.auth;
    final uid = auth.currentUser!.uid;
    return firestore
        .collection(workflowsCollectionPath)
        .where('owners', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => WorkflowModel.fromJson(e.data()))
              .toList(),
        );
  }

  Future<WorkflowModel> addWorkflow() async {
    final ref = firebaseSuite.firestore.collection('workflows').doc();
    final uid = firebaseSuite.auth.currentUser!.uid;
    final workflow = WorkflowModel.empty(ref.id, uid);
    await ref.set(workflow.toJson());
    return workflow;
  }

  Future<void> duplicateWorkflow(
    WorkflowModel workflow,
  ) async {
    final ref = firebaseSuite.firestore.collection('workflows').doc();
    final newWorkflow = workflow.copyWith(
      id: ref.id,
      name: '${workflow.name} (Copy)',
    );
    await ref.set(newWorkflow.toJson());
  }

  Future<void> deleteWorkflow(
    String docId,
  ) async {
    await firebaseSuite.firestore.collection('workflows').doc(docId).delete();
  }
}

@riverpod
Stream<List<WorkflowModel>> workflowStream(
  Ref ref,
  OpenCIFirebaseSuite firebaseSuite,
) {
  final controller =
      ref.watch(workflowPageControllerProvider(firebaseSuite).notifier);
  return controller.workflows();
}
