import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/openci_models.dart';

part 'workflow_model.freezed.dart';
part 'workflow_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class WorkflowModel with _$WorkflowModel {
  const factory WorkflowModel({
    required String currentWorkingDirectory,
    required String name,
    required String id,
    required WorkflowModelFlutter flutter,
    required WorkflowModelGitHub github,
    required List<String> owners,
    required List<WorkflowModelStep> steps,
  }) = _WorkflowModel;
  factory WorkflowModel.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelFromJson(json);

  factory WorkflowModel.empty(String docId, String uid) => WorkflowModel(
        currentWorkingDirectory: '',
        name: 'New Workflow',
        id: docId,
        flutter: WorkflowModelFlutter(version: FlutterVersion.getDefault()),
        github: WorkflowModelGitHub(
          repositoryUrl: 'example/repo',
          triggerType: GitHubTriggerType.push,
          baseBranch: 'main',
        ),
        owners: [uid],
        steps: [],
      );
}

@freezed
abstract class WorkflowModelFlutter with _$WorkflowModelFlutter {
  factory WorkflowModelFlutter({
    @FlutterVersionConverter() required FlutterVersion version,
  }) = _WorkflowModelFlutter;

  factory WorkflowModelFlutter.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelFlutterFromJson(json);
}

@freezed
abstract class WorkflowModelGitHub with _$WorkflowModelGitHub {
  const factory WorkflowModelGitHub({
    required String repositoryUrl,
    required GitHubTriggerType triggerType,
    required String baseBranch,
  }) = _WorkflowModelGitHub;
  factory WorkflowModelGitHub.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelGitHubFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
abstract class WorkflowModelStep with _$WorkflowModelStep {
  const factory WorkflowModelStep({
    @Default('') String name,
    @Default('') String command,
  }) = _WorkflowModelStep;
  factory WorkflowModelStep.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelStepFromJson(json);
}
