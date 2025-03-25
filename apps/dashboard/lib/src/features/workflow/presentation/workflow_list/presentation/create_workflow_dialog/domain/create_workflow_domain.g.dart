// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workflow_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateWorkflowDomain _$CreateWorkflowDomainFromJson(
        Map<String, dynamic> json) =>
    _CreateWorkflowDomain(
      template: $enumDecodeNullable(
              _$OpenCIWorkflowTemplateEnumMap, json['template']) ??
          OpenCIWorkflowTemplate.ipa,
      isASCKeyUploaded: json['isASCKeyUploaded'] as bool? ?? null,
      isLoading: json['isLoading'] as bool? ?? false,
      ascKey: json['ascKey'] == null
          ? const AppStoreConnectKey()
          : AppStoreConnectKey.fromJson(json['ascKey'] as Map<String, dynamic>),
      flutterBuildIpaData: json['flutterBuildIpaData'] == null
          ? const FlutterBuildIpaData()
          : FlutterBuildIpaData.fromJson(
              json['flutterBuildIpaData'] as Map<String, dynamic>),
      appDistributionTarget: $enumDecodeNullable(
              _$OpenCIAppDistributionTargetEnumMap,
              json['appDistributionTarget']) ??
          OpenCIAppDistributionTarget.none,
      selectedRepository: json['selectedRepository'] as String,
    );

Map<String, dynamic> _$CreateWorkflowDomainToJson(
        _CreateWorkflowDomain instance) =>
    <String, dynamic>{
      'template': _$OpenCIWorkflowTemplateEnumMap[instance.template]!,
      'isASCKeyUploaded': instance.isASCKeyUploaded,
      'isLoading': instance.isLoading,
      'ascKey': instance.ascKey.toJson(),
      'flutterBuildIpaData': instance.flutterBuildIpaData.toJson(),
      'appDistributionTarget':
          _$OpenCIAppDistributionTargetEnumMap[instance.appDistributionTarget]!,
      'selectedRepository': instance.selectedRepository,
    };

const _$OpenCIWorkflowTemplateEnumMap = {
  OpenCIWorkflowTemplate.ipa: 'ipa',
  OpenCIWorkflowTemplate.blank: 'blank',
};

const _$OpenCIAppDistributionTargetEnumMap = {
  OpenCIAppDistributionTarget.none: 'none',
  OpenCIAppDistributionTarget.firebaseAppDistribution:
      'firebaseAppDistribution',
  OpenCIAppDistributionTarget.testflight: 'testflight',
};

_AppStoreConnectKey _$AppStoreConnectKeyFromJson(Map<String, dynamic> json) =>
    _AppStoreConnectKey(
      issuerId: json['issuerId'] as String? ?? null,
      keyId: json['keyId'] as String? ?? null,
      keyFileBase64: json['keyFileBase64'] as String? ?? null,
    );

Map<String, dynamic> _$AppStoreConnectKeyToJson(_AppStoreConnectKey instance) =>
    <String, dynamic>{
      'issuerId': instance.issuerId,
      'keyId': instance.keyId,
      'keyFileBase64': instance.keyFileBase64,
    };

_FlutterBuildIpaData _$FlutterBuildIpaDataFromJson(Map<String, dynamic> json) =>
    _FlutterBuildIpaData(
      workflowName: json['workflowName'] as String? ?? 'Release iOS build',
      flutterBuildCommand:
          json['flutterBuildCommand'] as String? ?? 'flutter build ipa',
      cwd: json['cwd'] as String? ?? '',
      baseBranch: json['baseBranch'] as String? ?? 'main',
      triggerType: $enumDecodeNullable(
              _$GitHubTriggerTypeEnumMap, json['triggerType']) ??
          GitHubTriggerType.push,
    );

Map<String, dynamic> _$FlutterBuildIpaDataToJson(
        _FlutterBuildIpaData instance) =>
    <String, dynamic>{
      'workflowName': instance.workflowName,
      'flutterBuildCommand': instance.flutterBuildCommand,
      'cwd': instance.cwd,
      'baseBranch': instance.baseBranch,
      'triggerType': _$GitHubTriggerTypeEnumMap[instance.triggerType]!,
    };

const _$GitHubTriggerTypeEnumMap = {
  GitHubTriggerType.push: 'push',
  GitHubTriggerType.pullRequest: 'pullRequest',
};
