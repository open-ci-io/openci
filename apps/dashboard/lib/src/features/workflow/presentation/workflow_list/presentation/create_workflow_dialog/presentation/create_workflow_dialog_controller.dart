import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/domain/create_workflow_domain.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/enum.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:dashboard/src/services/firestore/secrets_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'create_workflow_dialog_controller.g.dart';

@Riverpod(keepAlive: true)
class CreateWorkflowDialogController extends _$CreateWorkflowDialogController {
  @override
  CreateWorkflowDomain build(String selectedRepository) {
    return CreateWorkflowDomain(selectedRepository: selectedRepository);
  }

  void setTemplate(OpenCIWorkflowTemplate template) {
    state = state.copyWith(template: template);
  }

  void setIsASCKeyUploaded({
    required bool isASCKeyUploaded,
  }) {
    state = state.copyWith(isASCKeyUploaded: isASCKeyUploaded);
  }

  void setIsLoading({
    required bool isLoading,
  }) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setASCKey(
    AppStoreConnectKey ascKey,
  ) {
    state = state.copyWith(ascKey: ascKey);
  }

  void setFlutterBuildIpaWorkflowName(
    String workflowName,
  ) {
    state = state.copyWith.flutterBuildIpaData(workflowName: workflowName);
  }

  void setFlutterBuildIpaFlutterBuildCommand(
    String flutterBuildCommand,
  ) {
    state = state.copyWith
        .flutterBuildIpaData(flutterBuildCommand: flutterBuildCommand);
  }

  void setFlutterBuildIpaCwd(
    String cwd,
  ) {
    state = state.copyWith.flutterBuildIpaData(cwd: cwd);
  }

  void setFlutterBuildIpaBaseBranch(
    String baseBranch,
  ) {
    state = state.copyWith.flutterBuildIpaData(baseBranch: baseBranch);
  }

  void setFlutterBuildIpaTriggerType(
    GitHubTriggerType triggerType,
  ) {
    state = state.copyWith.flutterBuildIpaData(triggerType: triggerType);
  }

  void setAppDistributionTarget(
    OpenCIAppDistributionTarget appDistributionTarget,
  ) {
    state = state.copyWith(appDistributionTarget: appDistributionTarget);
  }
}

@riverpod
Future<void> saveASCKeys(
  Ref ref, {
  required AppStoreConnectKey ascKey,
}) async {
  final secretsRepository = ref.read(secretsRepositoryProvider.notifier);
  final issuerId = ascKey.issuerId;
  final keyId = ascKey.keyId;
  final key = ascKey.keyFileBase64;
  if (issuerId == null) {
    throw Exception('Issuer ID is not valid');
  }
  if (keyId == null) {
    throw Exception('Key ID is not valid');
  }
  if (key == null) {
    throw Exception('Key is not valid');
  }

  await secretsRepository.saveASCKeys(
    issuerId,
    keyId,
    key,
  );
}

@riverpod
Future<bool> areAppStoreConnectKeysUploaded(Ref ref) async {
  final firestore = await getFirebaseFirestore();
  var qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: AppStoreConnectAPIKey.keyId.key)
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: AppStoreConnectAPIKey.issuerId.key)
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: AppStoreConnectAPIKey.keyBase64.key)
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  return true;
}

@riverpod
Future<WorkflowModel> createWorkflow(
  Ref ref, {
  required String selectedRepository,
}) async {
  final suite = await getOpenCIFirebaseSuite();
  final currentUserId = suite.auth.currentUser!.uid;
  final state =
      ref.watch(createWorkflowDialogControllerProvider(selectedRepository));
  final id = getDocumentId();
  final flutter = WorkflowModelFlutter(
    version: FlutterVersion.getDefault(),
  );
  final github = WorkflowModelGitHub(
    repositoryUrl: selectedRepository,
    triggerType: state.flutterBuildIpaData.triggerType,
    baseBranch: state.flutterBuildIpaData.baseBranch,
  );
  final steps = [
    const WorkflowModelStep(
      name: 'Build Flutter App',
      command: 'flutter build ipa',
    ),
    if (state.appDistributionTarget == OpenCIAppDistributionTarget.testflight)
      const WorkflowModelStep(
        name: 'Upload IPA to App Store Connect',
        command:
            'xcrun notarytool submit /path/to/your/app.ipa --key /path/to/your/key.p8 --key-id \$OPENCI_ASC_KEY_ID --issuer \$OPENCI_ASC_ISSUER_ID',
      ),
  ];
  final workflow = WorkflowModel(
    currentWorkingDirectory: state.flutterBuildIpaData.cwd,
    name: state.flutterBuildIpaData.workflowName,
    id: id,
    flutter: flutter,
    github: github,
    owners: [currentUserId],
    steps: steps,
  );
  await suite.firestore
      .collection('workflows')
      .doc(workflow.id)
      .set(workflow.toJson());
  return workflow;
}
