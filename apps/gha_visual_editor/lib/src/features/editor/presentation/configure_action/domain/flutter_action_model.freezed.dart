// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flutter_action_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FlutterActionModel _$FlutterActionModelFromJson(Map<String, dynamic> json) {
  return _FlutterActionModel.fromJson(json);
}

/// @nodoc
mixin _$FlutterActionModel {
  String get title => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get uses => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FlutterChannel get channel => throw _privateConstructorUsedError;
  String get flutterVersion => throw _privateConstructorUsedError;
  bool get cache => throw _privateConstructorUsedError;
  String get cacheKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlutterActionModelCopyWith<FlutterActionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlutterActionModelCopyWith<$Res> {
  factory $FlutterActionModelCopyWith(
          FlutterActionModel value, $Res Function(FlutterActionModel) then) =
      _$FlutterActionModelCopyWithImpl<$Res, FlutterActionModel>;
  @useResult
  $Res call(
      {String title,
      String source,
      String uses,
      String name,
      FlutterChannel channel,
      String flutterVersion,
      bool cache,
      String cacheKey});
}

/// @nodoc
class _$FlutterActionModelCopyWithImpl<$Res, $Val extends FlutterActionModel>
    implements $FlutterActionModelCopyWith<$Res> {
  _$FlutterActionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? source = null,
    Object? uses = null,
    Object? name = null,
    Object? channel = null,
    Object? flutterVersion = null,
    Object? cache = null,
    Object? cacheKey = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      uses: null == uses
          ? _value.uses
          : uses // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as FlutterChannel,
      flutterVersion: null == flutterVersion
          ? _value.flutterVersion
          : flutterVersion // ignore: cast_nullable_to_non_nullable
              as String,
      cache: null == cache
          ? _value.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheKey: null == cacheKey
          ? _value.cacheKey
          : cacheKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlutterActionModelImplCopyWith<$Res>
    implements $FlutterActionModelCopyWith<$Res> {
  factory _$$FlutterActionModelImplCopyWith(_$FlutterActionModelImpl value,
          $Res Function(_$FlutterActionModelImpl) then) =
      __$$FlutterActionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String source,
      String uses,
      String name,
      FlutterChannel channel,
      String flutterVersion,
      bool cache,
      String cacheKey});
}

/// @nodoc
class __$$FlutterActionModelImplCopyWithImpl<$Res>
    extends _$FlutterActionModelCopyWithImpl<$Res, _$FlutterActionModelImpl>
    implements _$$FlutterActionModelImplCopyWith<$Res> {
  __$$FlutterActionModelImplCopyWithImpl(_$FlutterActionModelImpl _value,
      $Res Function(_$FlutterActionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? source = null,
    Object? uses = null,
    Object? name = null,
    Object? channel = null,
    Object? flutterVersion = null,
    Object? cache = null,
    Object? cacheKey = null,
  }) {
    return _then(_$FlutterActionModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      uses: null == uses
          ? _value.uses
          : uses // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as FlutterChannel,
      flutterVersion: null == flutterVersion
          ? _value.flutterVersion
          : flutterVersion // ignore: cast_nullable_to_non_nullable
              as String,
      cache: null == cache
          ? _value.cache
          : cache // ignore: cast_nullable_to_non_nullable
              as bool,
      cacheKey: null == cacheKey
          ? _value.cacheKey
          : cacheKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlutterActionModelImpl implements _FlutterActionModel {
  const _$FlutterActionModelImpl(
      {this.title = 'Install Flutter',
      this.source = 'url',
      this.uses = 'subosito/flutter-action@v2',
      this.name = 'Setup Flutter SDK',
      this.channel = FlutterChannel.stable,
      this.flutterVersion = '3.24.0',
      this.cache = true,
      this.cacheKey = 'default'});

  factory _$FlutterActionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlutterActionModelImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final String uses;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final FlutterChannel channel;
  @override
  @JsonKey()
  final String flutterVersion;
  @override
  @JsonKey()
  final bool cache;
  @override
  @JsonKey()
  final String cacheKey;

  @override
  String toString() {
    return 'FlutterActionModel(title: $title, source: $source, uses: $uses, name: $name, channel: $channel, flutterVersion: $flutterVersion, cache: $cache, cacheKey: $cacheKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlutterActionModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.uses, uses) || other.uses == uses) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.flutterVersion, flutterVersion) ||
                other.flutterVersion == flutterVersion) &&
            (identical(other.cache, cache) || other.cache == cache) &&
            (identical(other.cacheKey, cacheKey) ||
                other.cacheKey == cacheKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, source, uses, name,
      channel, flutterVersion, cache, cacheKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FlutterActionModelImplCopyWith<_$FlutterActionModelImpl> get copyWith =>
      __$$FlutterActionModelImplCopyWithImpl<_$FlutterActionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlutterActionModelImplToJson(
      this,
    );
  }
}

abstract class _FlutterActionModel implements FlutterActionModel {
  const factory _FlutterActionModel(
      {final String title,
      final String source,
      final String uses,
      final String name,
      final FlutterChannel channel,
      final String flutterVersion,
      final bool cache,
      final String cacheKey}) = _$FlutterActionModelImpl;

  factory _FlutterActionModel.fromJson(Map<String, dynamic> json) =
      _$FlutterActionModelImpl.fromJson;

  @override
  String get title;
  @override
  String get source;
  @override
  String get uses;
  @override
  String get name;
  @override
  FlutterChannel get channel;
  @override
  String get flutterVersion;
  @override
  bool get cache;
  @override
  String get cacheKey;
  @override
  @JsonKey(ignore: true)
  _$$FlutterActionModelImplCopyWith<_$FlutterActionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
