// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'openci_secret.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OpenciSecret _$OpenciSecretFromJson(Map<String, dynamic> json) {
  return _OpenciSecret.fromJson(json);
}

/// @nodoc
mixin _$OpenciSecret {
  String get key => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  List<String> get owners => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OpenciSecret to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenciSecret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenciSecretCopyWith<OpenciSecret> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenciSecretCopyWith<$Res> {
  factory $OpenciSecretCopyWith(
          OpenciSecret value, $Res Function(OpenciSecret) then) =
      _$OpenciSecretCopyWithImpl<$Res, OpenciSecret>;
  @useResult
  $Res call(
      {String key,
      String value,
      List<String> owners,
      @DateTimeConverter() DateTime createdAt,
      @DateTimeConverter() DateTime updatedAt});
}

/// @nodoc
class _$OpenciSecretCopyWithImpl<$Res, $Val extends OpenciSecret>
    implements $OpenciSecretCopyWith<$Res> {
  _$OpenciSecretCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenciSecret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? owners = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      owners: null == owners
          ? _value.owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenciSecretImplCopyWith<$Res>
    implements $OpenciSecretCopyWith<$Res> {
  factory _$$OpenciSecretImplCopyWith(
          _$OpenciSecretImpl value, $Res Function(_$OpenciSecretImpl) then) =
      __$$OpenciSecretImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String value,
      List<String> owners,
      @DateTimeConverter() DateTime createdAt,
      @DateTimeConverter() DateTime updatedAt});
}

/// @nodoc
class __$$OpenciSecretImplCopyWithImpl<$Res>
    extends _$OpenciSecretCopyWithImpl<$Res, _$OpenciSecretImpl>
    implements _$$OpenciSecretImplCopyWith<$Res> {
  __$$OpenciSecretImplCopyWithImpl(
      _$OpenciSecretImpl _value, $Res Function(_$OpenciSecretImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenciSecret
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? owners = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$OpenciSecretImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      owners: null == owners
          ? _value._owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenciSecretImpl implements _OpenciSecret {
  const _$OpenciSecretImpl(
      {required this.key,
      required this.value,
      required final List<String> owners,
      @DateTimeConverter() required this.createdAt,
      @DateTimeConverter() required this.updatedAt})
      : _owners = owners;

  factory _$OpenciSecretImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenciSecretImplFromJson(json);

  @override
  final String key;
  @override
  final String value;
  final List<String> _owners;
  @override
  List<String> get owners {
    if (_owners is EqualUnmodifiableListView) return _owners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_owners);
  }

  @override
  @DateTimeConverter()
  final DateTime createdAt;
  @override
  @DateTimeConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'OpenciSecret(key: $key, value: $value, owners: $owners, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenciSecretImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            const DeepCollectionEquality().equals(other._owners, _owners) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value,
      const DeepCollectionEquality().hash(_owners), createdAt, updatedAt);

  /// Create a copy of OpenciSecret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenciSecretImplCopyWith<_$OpenciSecretImpl> get copyWith =>
      __$$OpenciSecretImplCopyWithImpl<_$OpenciSecretImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenciSecretImplToJson(
      this,
    );
  }
}

abstract class _OpenciSecret implements OpenciSecret {
  const factory _OpenciSecret(
          {required final String key,
          required final String value,
          required final List<String> owners,
          @DateTimeConverter() required final DateTime createdAt,
          @DateTimeConverter() required final DateTime updatedAt}) =
      _$OpenciSecretImpl;

  factory _OpenciSecret.fromJson(Map<String, dynamic> json) =
      _$OpenciSecretImpl.fromJson;

  @override
  String get key;
  @override
  String get value;
  @override
  List<String> get owners;
  @override
  @DateTimeConverter()
  DateTime get createdAt;
  @override
  @DateTimeConverter()
  DateTime get updatedAt;

  /// Create a copy of OpenciSecret
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenciSecretImplCopyWith<_$OpenciSecretImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
