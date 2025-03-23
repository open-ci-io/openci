// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'openci_secret.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpenCISecret {
  String get key;
  String get value;
  List<String> get owners;
  int get createdAt;
  int get updatedAt;

  /// Create a copy of OpenCISecret
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OpenCISecretCopyWith<OpenCISecret> get copyWith =>
      _$OpenCISecretCopyWithImpl<OpenCISecret>(
          this as OpenCISecret, _$identity);

  /// Serializes this OpenCISecret to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OpenCISecret &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            const DeepCollectionEquality().equals(other.owners, owners) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value,
      const DeepCollectionEquality().hash(owners), createdAt, updatedAt);

  @override
  String toString() {
    return 'OpenCISecret(key: $key, value: $value, owners: $owners, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $OpenCISecretCopyWith<$Res> {
  factory $OpenCISecretCopyWith(
          OpenCISecret value, $Res Function(OpenCISecret) _then) =
      _$OpenCISecretCopyWithImpl;
  @useResult
  $Res call(
      {String key,
      String value,
      List<String> owners,
      int createdAt,
      int updatedAt});
}

/// @nodoc
class _$OpenCISecretCopyWithImpl<$Res> implements $OpenCISecretCopyWith<$Res> {
  _$OpenCISecretCopyWithImpl(this._self, this._then);

  final OpenCISecret _self;
  final $Res Function(OpenCISecret) _then;

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
    return _then(_self.copyWith(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      owners: null == owners
          ? _self.owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OpenCISecret implements OpenCISecret {
  const _OpenCISecret(
      {required this.key,
      required this.value,
      required final List<String> owners,
      required this.createdAt,
      required this.updatedAt})
      : _owners = owners;
  factory _OpenCISecret.fromJson(Map<String, dynamic> json) =>
      _$OpenCISecretFromJson(json);

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

  /// Create a copy of OpenCISecret
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OpenCISecretCopyWith<_OpenCISecret> get copyWith =>
      __$OpenCISecretCopyWithImpl<_OpenCISecret>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OpenCISecretToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OpenCISecret &&
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

  @override
  String toString() {
    return 'OpenCISecret(key: $key, value: $value, owners: $owners, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$OpenCISecretCopyWith<$Res>
    implements $OpenCISecretCopyWith<$Res> {
  factory _$OpenCISecretCopyWith(
          _OpenCISecret value, $Res Function(_OpenCISecret) _then) =
      __$OpenCISecretCopyWithImpl;
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
class __$OpenCISecretCopyWithImpl<$Res>
    implements _$OpenCISecretCopyWith<$Res> {
  __$OpenCISecretCopyWithImpl(this._self, this._then);

  final _OpenCISecret _self;
  final $Res Function(_OpenCISecret) _then;

  /// Create a copy of OpenCISecret
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? owners = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_OpenCISecret(
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      owners: null == owners
          ? _self._owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
