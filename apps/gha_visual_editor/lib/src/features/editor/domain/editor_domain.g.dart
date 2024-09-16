// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EditorDomainImpl _$$EditorDomainImplFromJson(Map<String, dynamic> json) =>
    _$EditorDomainImpl(
      firstAction: json['firstAction'] == null
          ? const ConfigureFirstActionDomain()
          : ConfigureFirstActionDomain.fromJson(
              json['firstAction'] as Map<String, dynamic>),
      actionList: (json['actionList'] as List<dynamic>?)
              ?.map((e) => ActionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$EditorDomainImplToJson(_$EditorDomainImpl instance) =>
    <String, dynamic>{
      'firstAction': instance.firstAction,
      'actionList': instance.actionList,
    };
