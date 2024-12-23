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

OpenCISecret _$OpenCISecretFromJson(Map<String, dynamic> json) {
  return _OpenCISecret.fromJson(json);
}

/// @nodoc
mixin _$OpenCISecret {
  String get key => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  List<String> get owners => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;
  int get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OpenCISecret to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenCISecret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenCISecretCopyWith<OpenCISecret> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenCISecretCopyWith<$Res> {
  factory $OpenCISecretCopyWith(
          OpenCISecret value, $Res Function(OpenCISecret) then) =
      _$OpenCISecretCopyWithImpl<$Res, OpenCISecret>;
  @useResult
  $Res call(
      {String key,
      String value,
      List<String> owners,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class _$OpenCISecretCopyWithImpl<$Res, $Val extends OpenCISecret>
    implements $OpenCISecretCopyWith<$Res> {
  _$OpenCISecretCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenCISecret
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
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenCISecretImplCopyWith<$Res>
    implements $OpenCISecretCopyWith<$Res> {
  factory _$$OpenCISecretImplCopyWith(
          _$OpenCISecretImpl value, $Res Function(_$OpenCISecretImpl) then) =
      __$$OpenCISecretImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      String value,
      List<String> owners,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class __$$OpenCISecretImplCopyWithImpl<$Res>
    extends _$OpenCISecretCopyWithImpl<$Res, _$OpenCISecretImpl>
    implements _$$OpenCISecretImplCopyWith<$Res> {
  __$$OpenCISecretImplCopyWithImpl(
      _$OpenCISecretImpl _value, $Res Function(_$OpenCISecretImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenCISecret
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
    return _then(_$OpenCISecretImpl(
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
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenCISecretImpl implements _OpenCISecret {
  const _$OpenCISecretImpl(
      {required this.key,
      required this.value,
      required final List<String> owners,
      required this.createdAt,
      required this.updatedAt})
      : _owners = owners;

  factory _$OpenCISecretImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenCISecretImplFromJson(json);

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
  final int createdAt;
  @override
  final int updatedAt;

  @override
  String toString() {
    return 'OpenCISecret(key: $key, value: $value, owners: $owners, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenCISecretImpl &&
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

  /// Create a copy of OpenCISecret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenCISecretImplCopyWith<_$OpenCISecretImpl> get copyWith =>
      __$$OpenCISecretImplCopyWithImpl<_$OpenCISecretImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenCISecretImplToJson(
      this,
    );
  }
}

abstract class _OpenCISecret implements OpenCISecret {
  const factory _OpenCISecret(
      {required final String key,
      required final String value,
      required final List<String> owners,
      required final int createdAt,
      required final int updatedAt}) = _$OpenCISecretImpl;

  factory _OpenCISecret.fromJson(Map<String, dynamic> json) =
      _$OpenCISecretImpl.fromJson;

  @override
  String get key;
  @override
  String get value;
  @override
  List<String> get owners;
  @override
  int get createdAt;
  @override
  int get updatedAt;

  /// Create a copy of OpenCISecret
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenCISecretImplCopyWith<_$OpenCISecretImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
