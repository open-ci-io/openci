// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlutterActionModelImpl _$$FlutterActionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FlutterActionModelImpl(
      title: json['title'] as String? ?? 'Install Flutter',
      source: json['source'] as String? ?? 'url',
      uses: json['uses'] as String? ?? 'subosito/flutter-action@v2',
      name: json['name'] as String? ?? 'Setup Flutter SDK',
      channel: $enumDecodeNullable(_$FlutterChannelEnumMap, json['channel']) ??
          FlutterChannel.stable,
      flutterVersion: json['flutterVersion'] as String? ?? '3.24.0',
      cache: json['cache'] as bool? ?? true,
      cacheKey: json['cacheKey'] as String? ?? 'default',
    );

Map<String, dynamic> _$$FlutterActionModelImplToJson(
        _$FlutterActionModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'source': instance.source,
      'uses': instance.uses,
      'name': instance.name,
      'channel': _$FlutterChannelEnumMap[instance.channel]!,
      'flutterVersion': instance.flutterVersion,
      'cache': instance.cache,
      'cacheKey': instance.cacheKey,
    };

const _$FlutterChannelEnumMap = {
  FlutterChannel.stable: 'stable',
  FlutterChannel.beta: 'beta',
  FlutterChannel.dev: 'dev',
  FlutterChannel.master: 'master',
};
