import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'save_workflow.g.dart';

@riverpod
Future<bool> saveWorkflow(
  Ref ref, {
  required String currentWorkingDirectory,
  required String workflowName,
  required GitHubTriggerType githubTriggerType,
  required String githubBaseBranch,
  required String flutterBuildIpaCommand,
  required OpenCIAppDistributionTarget appDistributionTarget,
}) async {
  try {
    final firebaseSuite = await _getFirebaseSuite();
    final user = await _fetchCurrentUser(firebaseSuite);
    final workflow = _createWorkflowModel(
      currentWorkingDirectory: currentWorkingDirectory,
      workflowName: workflowName,
      githubTriggerType: githubTriggerType,
      githubBaseBranch: githubBaseBranch,
      flutterBuildIpaCommand: flutterBuildIpaCommand,
      appDistributionTarget: appDistributionTarget,
      userId: firebaseSuite.currentUserId,
      repositoryUrl: user.github.repositoryUrl,
    );

    await _saveWorkflowToFirestore(firebaseSuite.firestore, workflow);
    return true;
  } catch (e) {
    // ログ出力やエラー処理を追加
    print('Failed to save workflow: $e');
    return false;
  }
}

Future<_FirebaseSuite> _getFirebaseSuite() async {
  final firestore = await getFirebaseFirestore();
  final firebaseAuth = await getFirebaseAuth();
  final currentUserId = firebaseAuth.currentUser!.uid;

  return _FirebaseSuite(
    firestore: firestore,
    firebaseAuth: firebaseAuth,
    currentUserId: currentUserId,
  );
}

Future<OpenCIUser> _fetchCurrentUser(_FirebaseSuite firebaseSuite) async {
  final userDocs = await firebaseSuite.firestore
      .collection(usersCollectionPath)
      .doc(firebaseSuite.currentUserId)
      .get();

  if (!userDocs.exists || userDocs.data() == null) {
    throw Exception('User document not found');
  }

  return OpenCIUser.fromJson(userDocs.data()!);
}

WorkflowModel _createWorkflowModel({
  required String currentWorkingDirectory,
  required String workflowName,
  required GitHubTriggerType githubTriggerType,
  required String githubBaseBranch,
  required String flutterBuildIpaCommand,
  required OpenCIAppDistributionTarget appDistributionTarget,
  required String userId,
  required String repositoryUrl,
}) {
  final workflowId = const Uuid().v4();

  return WorkflowModel(
    id: workflowId,
    currentWorkingDirectory: currentWorkingDirectory,
    name: workflowName,
    flutter: const WorkflowModelFlutter(version: '3.27.1'),
    github: WorkflowModelGitHub(
      repositoryUrl: repositoryUrl,
      triggerType: githubTriggerType,
      baseBranch: githubBaseBranch,
    ),
    owners: [userId],
    steps: _createWorkflowSteps(
      flutterBuildIpaCommand: flutterBuildIpaCommand,
      appDistributionTarget: appDistributionTarget,
    ),
  );
}

List<WorkflowModelStep> _createWorkflowSteps({
  required String flutterBuildIpaCommand,
  required OpenCIAppDistributionTarget appDistributionTarget,
}) {
  final steps = <WorkflowModelStep>[
    WorkflowModelStep(
      name: 'Run Flutter Build IPA',
      command: flutterBuildIpaCommand,
    ),
  ];

  if (appDistributionTarget == OpenCIAppDistributionTarget.testflight) {
    steps.add(
      const WorkflowModelStep(
        name: 'Upload to Testflight',
        command:
            'xcrun notarytool submit path/to/your.ipa --key-id API_KEY_ID --key /path/to/AuthKey_API_KEY_ID.p8 --issuer ISSUER_ID',
      ),
    );
  }

  return steps;
}

Future<void> _saveWorkflowToFirestore(
  FirebaseFirestore firestore,
  WorkflowModel workflow,
) async {
  await firestore
      .collection(workflowsCollectionPath)
      .doc(workflow.id)
      .set(workflow.toJson());
}

class _FirebaseSuite {
  _FirebaseSuite({
    required this.firestore,
    required this.firebaseAuth,
    required this.currentUserId,
  });
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final String currentUserId;
}
