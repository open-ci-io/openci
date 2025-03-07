import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow_dialog/presentation/dialogs/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/openci_models.dart';

part 'create_workflow_domain.freezed.dart';
part 'create_workflow_domain.g.dart';

enum LoadinState {
  initial,
  loading,
  success,
  error;
}

@freezed
class CreateWorkflowDomain with _$CreateWorkflowDomain {
  const factory CreateWorkflowDomain({
    @Default(OpenCIWorkflowTemplate.ipa) OpenCIWorkflowTemplate template,
    @Default(null) bool? isASCKeyUploaded,
    @Default(false) bool isLoading,
    @Default(AppStoreConnectKey()) AppStoreConnectKey ascKey,
    @Default(FlutterBuildIpaData()) FlutterBuildIpaData flutterBuildIpaData,
    @Default(OpenCIAppDistributionTarget.none)
    OpenCIAppDistributionTarget appDistributionTarget,
  }) = _CreateWorkflowDomain;
  factory CreateWorkflowDomain.fromJson(Map<String, Object?> json) =>
      _$CreateWorkflowDomainFromJson(json);
}

@freezed
class AppStoreConnectKey with _$AppStoreConnectKey {
  const factory AppStoreConnectKey({
    @Default(null) String? issuerId,
    @Default(null) String? keyId,
    @Default(null) String? key,
  }) = _AppStoreConnectKey;
  factory AppStoreConnectKey.fromJson(Map<String, Object?> json) =>
      _$AppStoreConnectKeyFromJson(json);
}

@freezed
class FlutterBuildIpaData with _$FlutterBuildIpaData {
  const factory FlutterBuildIpaData({
    @Default('Release iOS build') String workflowName,
    @Default('flutter build ipa') String flutterBuildCommand,
    @Default('') String cwd,
    @Default('main') String baseBranch,
    @Default(GitHubTriggerType.push) GitHubTriggerType triggerType,
  }) = _FlutterBuildIpaData;
  factory FlutterBuildIpaData.fromJson(Map<String, Object?> json) =>
      _$FlutterBuildIpaDataFromJson(json);
}
