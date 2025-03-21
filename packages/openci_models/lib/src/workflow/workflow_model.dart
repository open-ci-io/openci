import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openci_models/openci_models.dart';

part 'workflow_model.freezed.dart';
part 'workflow_model.g.dart';

enum GitHubTriggerType {
  push,
  pullRequest,
}

@Freezed(makeCollectionsUnmodifiable: false)
class WorkflowModel with _$WorkflowModel {
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
          repositoryUrl: 'https://github.com/example/repo',
          triggerType: GitHubTriggerType.push,
          baseBranch: 'main',
        ),
        owners: [uid],
        steps: [],
      );
}

@freezed
class WorkflowModelFlutter with _$WorkflowModelFlutter {
  factory WorkflowModelFlutter({
    @FlutterVersionConverter() required FlutterVersion version,
  }) = _WorkflowModelFlutter;

  factory WorkflowModelFlutter.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelFlutterFromJson(json);
}

@freezed
class WorkflowModelGitHub with _$WorkflowModelGitHub {
  const factory WorkflowModelGitHub({
    required String repositoryUrl,
    required GitHubTriggerType triggerType,
    required String baseBranch,
  }) = _WorkflowModelGitHub;
  factory WorkflowModelGitHub.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelGitHubFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
class WorkflowModelStep with _$WorkflowModelStep {
  const factory WorkflowModelStep({
    @Default('') String name,
    @Default('') String command,
  }) = _WorkflowModelStep;
  factory WorkflowModelStep.fromJson(Map<String, Object?> json) =>
      _$WorkflowModelStepFromJson(json);
}

@freezed
class OpenCIRepository with _$OpenCIRepository {
  const factory OpenCIRepository({
    @JsonKey(name: 'full_name') required String fullName,
    required int id,
    required String name,
    @JsonKey(name: 'node_id') required String nodeId,
    required bool private,
  }) = _OpenCIRepository;

  factory OpenCIRepository.fromJson(Map<String, Object?> json) =>
      _$OpenCIRepositoryFromJson(json);
}
