import 'package:freezed_annotation/freezed_annotation.dart';

part 'configure_first_action_domain.freezed.dart';
part 'configure_first_action_domain.g.dart';

@freezed
class ConfigureFirstActionDomain with _$ConfigureFirstActionDomain {
  const factory ConfigureFirstActionDomain({
    @Default(ConfigureFirstActionDomainWorkflow())
    ConfigureFirstActionDomainWorkflow workflow,
    @Default(ConfigureFirstActionDomainRun()) ConfigureFirstActionDomainRun run,
    @Default(ConfigureFirstActionDomainBranch())
    ConfigureFirstActionDomainBranch branch,
    @Default(ConfigureFirstActionDomainBuildMachine())
    ConfigureFirstActionDomainBuildMachine buildMachine,
  }) = _ConfigureFirstActionDomain;
  factory ConfigureFirstActionDomain.fromJson(Map<String, Object?> json) =>
      _$ConfigureFirstActionDomainFromJson(json);
}

@freezed
class ConfigureFirstActionDomainWorkflow
    with _$ConfigureFirstActionDomainWorkflow {
  const factory ConfigureFirstActionDomainWorkflow({
    @Default('Default Workflow') String value,
    @Default('Workflow Name') String label,
  }) = _ConfigureFirstActionDomainWorkflow;
  factory ConfigureFirstActionDomainWorkflow.fromJson(
    Map<String, Object?> json,
  ) =>
      _$ConfigureFirstActionDomainWorkflowFromJson(json);
}

@freezed
class ConfigureFirstActionDomainRun with _$ConfigureFirstActionDomainRun {
  const factory ConfigureFirstActionDomainRun({
    @Default('push') String value,
    @Default('Branch') String label,
    @Default(['push', 'pull_request']) List<String> options,
  }) = _ConfigureFirstActionDomainRun;
  factory ConfigureFirstActionDomainRun.fromJson(Map<String, Object?> json) =>
      _$ConfigureFirstActionDomainRunFromJson(json);
}

@freezed
class ConfigureFirstActionDomainBranch with _$ConfigureFirstActionDomainBranch {
  const factory ConfigureFirstActionDomainBranch({
    @Default('main') String value,
    @Default('Branch') String label,
  }) = _ConfigureFirstActionDomainBranch;
  factory ConfigureFirstActionDomainBranch.fromJson(
    Map<String, Object?> json,
  ) =>
      _$ConfigureFirstActionDomainBranchFromJson(json);
}

@freezed
class ConfigureFirstActionDomainBuildMachine
    with _$ConfigureFirstActionDomainBuildMachine {
  const factory ConfigureFirstActionDomainBuildMachine({
    @Default('ubuntu-latest') String value,
    @Default('Build Machine') String label,
  }) = _ConfigureFirstActionDomainBuildMachine;
  factory ConfigureFirstActionDomainBuildMachine.fromJson(
    Map<String, Object?> json,
  ) =>
      _$ConfigureFirstActionDomainBuildMachineFromJson(json);
}
