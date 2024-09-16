import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:signals/signals_flutter.dart';

part 'workflow_domain.freezed.dart';
part 'workflow_domain.g.dart';

final workflowDomainSignal = signal<WorkflowDomain>(
  const WorkflowDomain(
    workflowName: 'Default Workflow',
    branch: 'develop',
    on: OnPush.push,
  ),
);

@freezed
class WorkflowDomain with _$WorkflowDomain {
  const factory WorkflowDomain({
    required String workflowName,
    required String branch,
    required OnPush on,
  }) = _WorkflowDomain;
  factory WorkflowDomain.fromJson(Map<String, Object?> json) =>
      _$WorkflowDomainFromJson(json);
}

// ignore: constant_identifier_names
enum OnPush { push, pull_request }
