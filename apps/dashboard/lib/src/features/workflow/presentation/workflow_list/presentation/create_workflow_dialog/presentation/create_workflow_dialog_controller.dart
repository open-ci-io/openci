import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/domain/create_workflow_domain.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/enum.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:dashboard/src/services/firestore/secrets_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'create_workflow_dialog_controller.g.dart';

@riverpod
class CreateWorkflowDialogController extends _$CreateWorkflowDialogController {
  @override
  CreateWorkflowDomain build() {
    return const CreateWorkflowDomain();
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

enum ASCKey {
  keyId,
  issuerId,
  keyBase64;

  String get key {
    switch (this) {
      case ASCKey.keyId:
        return 'OPENCI_ASC_KEY_ID';
      case ASCKey.issuerId:
        return 'OPENCI_ASC_ISSUER_ID';
      case ASCKey.keyBase64:
        return 'OPENCI_ASC_KEY_BASE64';
    }
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
  final key = ascKey.key;
  if (issuerId == null || keyId == null || key == null) {
    throw Exception('ASC Key is not valid');
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
      .where('key', isEqualTo: ASCKey.keyId.key)
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: ASCKey.issuerId.key)
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: ASCKey.keyBase64.key)
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  return true;
}
