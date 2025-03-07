// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workflow_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateWorkflowDomainImpl _$$CreateWorkflowDomainImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateWorkflowDomainImpl(
      template: $enumDecodeNullable(
              _$OpenCIWorkflowTemplateEnumMap, json['template']) ??
          OpenCIWorkflowTemplate.ipa,
      isASCKeyUploaded: json['isASCKeyUploaded'] as bool? ?? null,
      isLoading: json['isLoading'] as bool? ?? false,
      ascKey: json['ascKey'] == null
          ? const AppStoreConnectKey()
          : AppStoreConnectKey.fromJson(json['ascKey'] as Map<String, dynamic>),
      flutterBuildIpaData: json['flutterBuildIpaData'] == null
          ? null
          : FlutterBuildIpaData.fromJson(
              json['flutterBuildIpaData'] as Map<String, dynamic>),
      appDistributionTarget: $enumDecodeNullable(
              _$OpenCIAppDistributionTargetEnumMap,
              json['appDistributionTarget']) ??
          OpenCIAppDistributionTarget.none,
    );

Map<String, dynamic> _$$CreateWorkflowDomainImplToJson(
        _$CreateWorkflowDomainImpl instance) =>
    <String, dynamic>{
      'template': _$OpenCIWorkflowTemplateEnumMap[instance.template]!,
      'isASCKeyUploaded': instance.isASCKeyUploaded,
      'isLoading': instance.isLoading,
      'ascKey': instance.ascKey.toJson(),
      'flutterBuildIpaData': instance.flutterBuildIpaData?.toJson(),
      'appDistributionTarget':
          _$OpenCIAppDistributionTargetEnumMap[instance.appDistributionTarget]!,
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

_$AppStoreConnectKeyImpl _$$AppStoreConnectKeyImplFromJson(
        Map<String, dynamic> json) =>
    _$AppStoreConnectKeyImpl(
      issuerId: json['issuerId'] as String? ?? null,
      keyId: json['keyId'] as String? ?? null,
      key: json['key'] as String? ?? null,
    );

Map<String, dynamic> _$$AppStoreConnectKeyImplToJson(
        _$AppStoreConnectKeyImpl instance) =>
    <String, dynamic>{
      'issuerId': instance.issuerId,
      'keyId': instance.keyId,
      'key': instance.key,
    };

_$FlutterBuildIpaDataImpl _$$FlutterBuildIpaDataImplFromJson(
        Map<String, dynamic> json) =>
    _$FlutterBuildIpaDataImpl(
      workflowName: json['workflowName'] as String,
      flutterBuildCommand: json['flutterBuildCommand'] as String,
      cwd: json['cwd'] as String? ?? '',
      baseBranch: json['baseBranch'] as String,
    );

Map<String, dynamic> _$$FlutterBuildIpaDataImplToJson(
        _$FlutterBuildIpaDataImpl instance) =>
    <String, dynamic>{
      'workflowName': instance.workflowName,
      'flutterBuildCommand': instance.flutterBuildCommand,
      'cwd': instance.cwd,
      'baseBranch': instance.baseBranch,
    };
