// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configure_first_action_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigureFirstActionDomainImpl _$$ConfigureFirstActionDomainImplFromJson(
        Map<String, dynamic> json) =>
    _$ConfigureFirstActionDomainImpl(
      workflow: json['workflow'] == null
          ? const ConfigureFirstActionDomainWorkflow()
          : ConfigureFirstActionDomainWorkflow.fromJson(
              json['workflow'] as Map<String, dynamic>),
      run: json['run'] == null
          ? const ConfigureFirstActionDomainRun()
          : ConfigureFirstActionDomainRun.fromJson(
              json['run'] as Map<String, dynamic>),
      branch: json['branch'] == null
          ? const ConfigureFirstActionDomainBranch()
          : ConfigureFirstActionDomainBranch.fromJson(
              json['branch'] as Map<String, dynamic>),
      buildMachine: json['buildMachine'] == null
          ? const ConfigureFirstActionDomainBuildMachine()
          : ConfigureFirstActionDomainBuildMachine.fromJson(
              json['buildMachine'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ConfigureFirstActionDomainImplToJson(
        _$ConfigureFirstActionDomainImpl instance) =>
    <String, dynamic>{
      'workflow': instance.workflow,
      'run': instance.run,
      'branch': instance.branch,
      'buildMachine': instance.buildMachine,
    };

_$ConfigureFirstActionDomainWorkflowImpl
    _$$ConfigureFirstActionDomainWorkflowImplFromJson(
            Map<String, dynamic> json) =>
        _$ConfigureFirstActionDomainWorkflowImpl(
          value: json['value'] as String? ?? 'Default Workflow',
          label: json['label'] as String? ?? 'Workflow Name',
        );

Map<String, dynamic> _$$ConfigureFirstActionDomainWorkflowImplToJson(
        _$ConfigureFirstActionDomainWorkflowImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
    };

_$ConfigureFirstActionDomainRunImpl
    _$$ConfigureFirstActionDomainRunImplFromJson(Map<String, dynamic> json) =>
        _$ConfigureFirstActionDomainRunImpl(
          value: json['value'] as String? ?? 'push',
          label: json['label'] as String? ?? 'Branch',
          options: (json['options'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const ['push', 'pull_request'],
        );

Map<String, dynamic> _$$ConfigureFirstActionDomainRunImplToJson(
        _$ConfigureFirstActionDomainRunImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'options': instance.options,
    };

_$ConfigureFirstActionDomainBranchImpl
    _$$ConfigureFirstActionDomainBranchImplFromJson(
            Map<String, dynamic> json) =>
        _$ConfigureFirstActionDomainBranchImpl(
          value: json['value'] as String? ?? 'main',
          label: json['label'] as String? ?? 'Branch',
        );

Map<String, dynamic> _$$ConfigureFirstActionDomainBranchImplToJson(
        _$ConfigureFirstActionDomainBranchImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
    };

_$ConfigureFirstActionDomainBuildMachineImpl
    _$$ConfigureFirstActionDomainBuildMachineImplFromJson(
            Map<String, dynamic> json) =>
        _$ConfigureFirstActionDomainBuildMachineImpl(
          value: json['value'] as String? ?? 'ubuntu-latest',
          label: json['label'] as String? ?? 'Build Machine',
        );

Map<String, dynamic> _$$ConfigureFirstActionDomainBuildMachineImplToJson(
        _$ConfigureFirstActionDomainBuildMachineImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
    };
