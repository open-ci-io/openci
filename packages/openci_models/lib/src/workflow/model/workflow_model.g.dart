// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowModelImpl _$$WorkflowModelImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowModelImpl(
      android: json['android'] == null
          ? null
          : WorkflowAndroidConfig.fromJson(
              json['android'] as Map<String, dynamic>),
      firebase: WorkflowFirebaseConfig.fromJson(
          json['firebase'] as Map<String, dynamic>),
      ios: json['ios'] == null
          ? null
          : WorkflowIosConfig.fromJson(json['ios'] as Map<String, dynamic>),
      organizationId: json['organizationId'] as String,
      flutter: WorkflowFlutterConfig.fromJson(
          json['flutter'] as Map<String, dynamic>),
      github: json['github'] == null
          ? null
          : WorkflowGitHubConfig.fromJson(
              json['github'] as Map<String, dynamic>),
      shorebird: WorkflowShorebirdConfig.fromJson(
          json['shorebird'] as Map<String, dynamic>),
      workflowName: json['workflowName'] as String,
      platform: $enumDecode(_$TargetPlatformEnumMap, json['platform']),
      distribution: $enumDecodeNullable(
              _$BuildDistributionChannelEnumMap, json['distribution']) ??
          null,
    );

Map<String, dynamic> _$$WorkflowModelImplToJson(_$WorkflowModelImpl instance) =>
    <String, dynamic>{
      'android': instance.android?.toJson(),
      'firebase': instance.firebase.toJson(),
      'ios': instance.ios?.toJson(),
      'organizationId': instance.organizationId,
      'flutter': instance.flutter.toJson(),
      'github': instance.github?.toJson(),
      'shorebird': instance.shorebird.toJson(),
      'workflowName': instance.workflowName,
      'platform': _$TargetPlatformEnumMap[instance.platform]!,
      'distribution': _$BuildDistributionChannelEnumMap[instance.distribution],
    };

const _$TargetPlatformEnumMap = {
  TargetPlatform.android: 'android',
  TargetPlatform.ios: 'ios',
};

const _$BuildDistributionChannelEnumMap = {
  BuildDistributionChannel.firebaseAppDistribution: 'firebaseAppDistribution',
  BuildDistributionChannel.testFlight: 'testFlight',
  BuildDistributionChannel.playStoreInternal: 'playStoreInternal',
  BuildDistributionChannel.playStoreBeta: 'playStoreBeta',
};

_$WorkflowGitHubConfigImpl _$$WorkflowGitHubConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowGitHubConfigImpl(
      baseBranch: json['baseBranch'] as String? ?? null,
      repositoryUrl: json['repositoryUrl'] as String? ?? null,
      triggerType: json['triggerType'] as String? ?? null,
    );

Map<String, dynamic> _$$WorkflowGitHubConfigImplToJson(
        _$WorkflowGitHubConfigImpl instance) =>
    <String, dynamic>{
      'baseBranch': instance.baseBranch,
      'repositoryUrl': instance.repositoryUrl,
      'triggerType': instance.triggerType,
    };

_$WorkflowAndroidConfigImpl _$$WorkflowAndroidConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowAndroidConfigImpl(
      jks: json['jks'] as String? ?? null,
      jksName: json['jksName'] as String? ?? null,
      keyProperties: json['keyProperties'] as String? ?? null,
      jksDirectory: json['jksDirectory'] as String?,
    );

Map<String, dynamic> _$$WorkflowAndroidConfigImplToJson(
        _$WorkflowAndroidConfigImpl instance) =>
    <String, dynamic>{
      'jks': instance.jks,
      'jksName': instance.jksName,
      'keyProperties': instance.keyProperties,
      'jksDirectory': instance.jksDirectory,
    };

_$WorkflowShorebirdConfigImpl _$$WorkflowShorebirdConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowShorebirdConfigImpl(
      token: json['token'] as String? ?? null,
      yamlDownloadUrl: json['yamlDownloadUrl'] as String? ?? null,
      useShorebird: json['useShorebird'] as bool? ?? null,
      patch: json['patch'] as bool? ?? null,
    );

Map<String, dynamic> _$$WorkflowShorebirdConfigImplToJson(
        _$WorkflowShorebirdConfigImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'yamlDownloadUrl': instance.yamlDownloadUrl,
      'useShorebird': instance.useShorebird,
      'patch': instance.patch,
    };

_$WorkflowFirebaseConfigImpl _$$WorkflowFirebaseConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowFirebaseConfigImpl(
      appDistribution: AppDistributionConfig.fromJson(
          json['appDistribution'] as Map<String, dynamic>),
      appIdIos: json['appIdIos'] as String? ?? null,
      appIdAndroid: json['appIdAndroid'] as String? ?? null,
      serviceAccountJson: json['serviceAccountJson'] as String? ?? null,
    );

Map<String, dynamic> _$$WorkflowFirebaseConfigImplToJson(
        _$WorkflowFirebaseConfigImpl instance) =>
    <String, dynamic>{
      'appDistribution': instance.appDistribution.toJson(),
      'appIdIos': instance.appIdIos,
      'appIdAndroid': instance.appIdAndroid,
      'serviceAccountJson': instance.serviceAccountJson,
    };

_$WorkflowIosConfigImpl _$$WorkflowIosConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowIosConfigImpl(
      exportOptions: json['exportOptions'] as String? ?? null,
      p12: json['p12'] as String? ?? null,
      provisioningProfile: json['provisioningProfile'] == null
          ? null
          : WorkflowProvisioningProfileConfig.fromJson(
              json['provisioningProfile'] as Map<String, dynamic>),
      appStoreConnectAPI: json['appStoreConnectAPI'] == null
          ? null
          : WorkflowAppStoreConnectAPI.fromJson(
              json['appStoreConnectAPI'] as Map<String, dynamic>),
      teamId: json['teamId'] as String? ?? null,
    );

Map<String, dynamic> _$$WorkflowIosConfigImplToJson(
        _$WorkflowIosConfigImpl instance) =>
    <String, dynamic>{
      'exportOptions': instance.exportOptions,
      'p12': instance.p12,
      'provisioningProfile': instance.provisioningProfile?.toJson(),
      'appStoreConnectAPI': instance.appStoreConnectAPI?.toJson(),
      'teamId': instance.teamId,
    };

_$WorkflowAppStoreConnectAPIImpl _$$WorkflowAppStoreConnectAPIImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowAppStoreConnectAPIImpl(
      p8: json['p8'] as String? ?? null,
      keyId: json['keyId'] as String? ?? null,
      issuerId: json['issuerId'] as String? ?? null,
      appId: json['appId'] as String? ?? null,
    );

Map<String, dynamic> _$$WorkflowAppStoreConnectAPIImplToJson(
        _$WorkflowAppStoreConnectAPIImpl instance) =>
    <String, dynamic>{
      'p8': instance.p8,
      'keyId': instance.keyId,
      'issuerId': instance.issuerId,
      'appId': instance.appId,
    };

_$WorkflowProvisioningProfileConfigImpl
    _$$WorkflowProvisioningProfileConfigImplFromJson(
            Map<String, dynamic> json) =>
        _$WorkflowProvisioningProfileConfigImpl(
          url: json['url'] as String? ?? null,
          name: json['name'] as String? ?? null,
        );

Map<String, dynamic> _$$WorkflowProvisioningProfileConfigImplToJson(
        _$WorkflowProvisioningProfileConfigImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
    };

_$WorkflowFlutterConfigImpl _$$WorkflowFlutterConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkflowFlutterConfigImpl(
      flavor: json['flavor'] as String,
      version: json['version'] as String,
      entryPoint: json['entryPoint'] as String?,
      dartDefine: (json['dartDefine'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          null,
    );

Map<String, dynamic> _$$WorkflowFlutterConfigImplToJson(
        _$WorkflowFlutterConfigImpl instance) =>
    <String, dynamic>{
      'flavor': instance.flavor,
      'version': instance.version,
      'entryPoint': instance.entryPoint,
      'dartDefine': instance.dartDefine,
    };

_$AppDistributionConfigImpl _$$AppDistributionConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$AppDistributionConfigImpl(
      testerGroups: (json['testerGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          null,
    );

Map<String, dynamic> _$$AppDistributionConfigImplToJson(
        _$AppDistributionConfigImpl instance) =>
    <String, dynamic>{
      'testerGroups': instance.testerGroups,
    };
