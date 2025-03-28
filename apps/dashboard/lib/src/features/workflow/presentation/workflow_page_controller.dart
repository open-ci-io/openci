import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/domain/github_repository.dart';
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

  Stream<List<WorkflowModel>> workflows(String repository) {
    final firestore = firebaseSuite.firestore;
    final auth = firebaseSuite.auth;
    final uid = auth.currentUser!.uid;
    return firestore
        .collection(workflowsCollectionPath)
        .where('owners', arrayContains: uid)
        .where('github.repositoryFullName', isEqualTo: repository)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => WorkflowModel.fromJson(e.data()))
              .toList(),
        );
  }

  Stream<bool> isGitHubAppInstalled() {
    final firestore = firebaseSuite.firestore;
    final auth = firebaseSuite.auth;
    final uid = auth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data()?['github'] != null);
  }

  Future<WorkflowModel> addWorkflow(String repoFullName) async {
    final ref = firebaseSuite.firestore.collection('workflows').doc();
    final uid = firebaseSuite.auth.currentUser!.uid;
    final workflow = WorkflowModel.empty(ref.id, uid, repoFullName, null);
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

  Future<List<String>> getGitHubRepositories() async {
    final firestore = firebaseSuite.firestore;
    final auth = firebaseSuite.auth;
    final uid = auth.currentUser!.uid;
    final userDoc = await firestore.collection('users').doc(uid).get();
    final userData = userDoc.data()!;
    final github = userData['github'] as Map<String, dynamic>;
    final repositories = github['repositories'] as List<dynamic>;
    // ignore: avoid_dynamic_calls
    return repositories.map((e) => e['full_name'] as String).toList();
  }

  Stream<List<String>> getGitHubRepositoriesStream() {
    final firestore = firebaseSuite.firestore;
    final auth = firebaseSuite.auth;
    final uid = auth.currentUser!.uid;

    return firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return <String>[];
      }

      final userData = snapshot.data()!;

      if (!userData.containsKey('github')) {
        return <String>[];
      }

      final github = userData['github'] as Map<String, dynamic>;

      if (!github.containsKey('repositories')) {
        return <String>[];
      }

      final repositories = github['repositories'] as List<dynamic>;
      // ignore: avoid_dynamic_calls
      return repositories.map((e) => e['full_name'] as String).toList();
    });
  }

  String getInstallationUrl() {
    const env = String.fromEnvironment('ENV');
    const appName = env == 'prod' ? 'openci-io' : 'openci-dev';
    final uid = firebaseSuite.auth.currentUser!.uid;
    return 'https://github.com/apps/$appName/installations/select_target?state=$uid';
  }
}

@riverpod
Stream<List<WorkflowModel>> workflowStream(
  Ref ref,
  OpenCIFirebaseSuite firebaseSuite,
  String repository,
) {
  final controller =
      ref.watch(workflowPageControllerProvider(firebaseSuite).notifier);
  return controller.workflows(repository);
}

@riverpod
Stream<bool> isGitHubAppInstalled(
  Ref ref,
  OpenCIFirebaseSuite firebaseSuite,
) {
  final controller =
      ref.watch(workflowPageControllerProvider(firebaseSuite).notifier);
  return controller.isGitHubAppInstalled();
}

@riverpod
Future<List<String>> getGitHubRepositories(
  Ref ref,
  OpenCIFirebaseSuite firebaseSuite,
) async {
  final controller =
      ref.watch(workflowPageControllerProvider(firebaseSuite).notifier);
  return controller.getGitHubRepositories();
}

@Riverpod(keepAlive: true)
class SelectedRepository extends _$SelectedRepository {
  @override
  Stream<GithubRepository> build(OpenCIFirebaseSuite firebaseSuite) {
    return _controller.getGitHubRepositoriesStream().map((repoList) {
      if (repoList.isEmpty) {
        return const GithubRepository(
          selectedRepository: '',
          repositories: [],
        );
      }

      return GithubRepository(
        selectedRepository: repoList.first,
        repositories: repoList,
      );
    });
  }

  WorkflowPageController get _controller =>
      ref.watch(workflowPageControllerProvider(firebaseSuite).notifier);

  Future<void> set(String repository) async {
    final data = state.valueOrNull;
    if (data == null) {
      return;
    }
    state = AsyncData(data.copyWith(selectedRepository: repository));
  }
}
