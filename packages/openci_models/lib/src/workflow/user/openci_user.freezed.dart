// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'openci_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OpenCIUser _$OpenCIUserFromJson(Map<String, dynamic> json) {
  return _OpenCIUser.fromJson(json);
}

/// @nodoc
mixin _$OpenCIUser {
  String get userId => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;
  OpenCIUserGitHub? get github => throw _privateConstructorUsedError;

  /// Serializes this OpenCIUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenCIUserCopyWith<OpenCIUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenCIUserCopyWith<$Res> {
  factory $OpenCIUserCopyWith(
          OpenCIUser value, $Res Function(OpenCIUser) then) =
      _$OpenCIUserCopyWithImpl<$Res, OpenCIUser>;
  @useResult
  $Res call({String userId, int createdAt, OpenCIUserGitHub? github});

  $OpenCIUserGitHubCopyWith<$Res>? get github;
}

/// @nodoc
class _$OpenCIUserCopyWithImpl<$Res, $Val extends OpenCIUser>
    implements $OpenCIUserCopyWith<$Res> {
  _$OpenCIUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? createdAt = null,
    Object? github = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      github: freezed == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIUserGitHub?,
    ) as $Val);
  }

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenCIUserGitHubCopyWith<$Res>? get github {
    if (_value.github == null) {
      return null;
    }

    return $OpenCIUserGitHubCopyWith<$Res>(_value.github!, (value) {
      return _then(_value.copyWith(github: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpenCIUserImplCopyWith<$Res>
    implements $OpenCIUserCopyWith<$Res> {
  factory _$$OpenCIUserImplCopyWith(
          _$OpenCIUserImpl value, $Res Function(_$OpenCIUserImpl) then) =
      __$$OpenCIUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, int createdAt, OpenCIUserGitHub? github});

  @override
  $OpenCIUserGitHubCopyWith<$Res>? get github;
}

/// @nodoc
class __$$OpenCIUserImplCopyWithImpl<$Res>
    extends _$OpenCIUserCopyWithImpl<$Res, _$OpenCIUserImpl>
    implements _$$OpenCIUserImplCopyWith<$Res> {
  __$$OpenCIUserImplCopyWithImpl(
      _$OpenCIUserImpl _value, $Res Function(_$OpenCIUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? createdAt = null,
    Object? github = freezed,
  }) {
    return _then(_$OpenCIUserImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      github: freezed == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIUserGitHub?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenCIUserImpl implements _OpenCIUser {
  const _$OpenCIUserImpl(
      {required this.userId, required this.createdAt, this.github});

  factory _$OpenCIUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenCIUserImplFromJson(json);

  @override
  final String userId;
  @override
  final int createdAt;
  @override
  final OpenCIUserGitHub? github;

  @override
  String toString() {
    return 'OpenCIUser(userId: $userId, createdAt: $createdAt, github: $github)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenCIUserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.github, github) || other.github == github));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, createdAt, github);

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenCIUserImplCopyWith<_$OpenCIUserImpl> get copyWith =>
      __$$OpenCIUserImplCopyWithImpl<_$OpenCIUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenCIUserImplToJson(
      this,
    );
  }
}

abstract class _OpenCIUser implements OpenCIUser {
  const factory _OpenCIUser(
      {required final String userId,
      required final int createdAt,
      final OpenCIUserGitHub? github}) = _$OpenCIUserImpl;

  factory _OpenCIUser.fromJson(Map<String, dynamic> json) =
      _$OpenCIUserImpl.fromJson;

  @override
  String get userId;
  @override
  int get createdAt;
  @override
  OpenCIUserGitHub? get github;

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenCIUserImplCopyWith<_$OpenCIUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenCIUserGitHub _$OpenCIUserGitHubFromJson(Map<String, dynamic> json) {
  return _OpenCIUserGitHub.fromJson(json);
}

/// @nodoc
mixin _$OpenCIUserGitHub {
  int? get installationId => throw _privateConstructorUsedError;
  String? get login => throw _privateConstructorUsedError;
  List<OpenCIRepository>? get repositories =>
      throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;

  /// Serializes this OpenCIUserGitHub to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenCIUserGitHubCopyWith<OpenCIUserGitHub> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenCIUserGitHubCopyWith<$Res> {
  factory $OpenCIUserGitHubCopyWith(
          OpenCIUserGitHub value, $Res Function(OpenCIUserGitHub) then) =
      _$OpenCIUserGitHubCopyWithImpl<$Res, OpenCIUserGitHub>;
  @useResult
  $Res call(
      {int? installationId,
      String? login,
      List<OpenCIRepository>? repositories,
      int? userId});
}

/// @nodoc
class _$OpenCIUserGitHubCopyWithImpl<$Res, $Val extends OpenCIUserGitHub>
    implements $OpenCIUserGitHubCopyWith<$Res> {
  _$OpenCIUserGitHubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? installationId = freezed,
    Object? login = freezed,
    Object? repositories = freezed,
    Object? userId = freezed,
  }) {
    return _then(_value.copyWith(
      installationId: freezed == installationId
          ? _value.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      repositories: freezed == repositories
          ? _value.repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<OpenCIRepository>?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenCIUserGitHubImplCopyWith<$Res>
    implements $OpenCIUserGitHubCopyWith<$Res> {
  factory _$$OpenCIUserGitHubImplCopyWith(_$OpenCIUserGitHubImpl value,
          $Res Function(_$OpenCIUserGitHubImpl) then) =
      __$$OpenCIUserGitHubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? installationId,
      String? login,
      List<OpenCIRepository>? repositories,
      int? userId});
}

/// @nodoc
class __$$OpenCIUserGitHubImplCopyWithImpl<$Res>
    extends _$OpenCIUserGitHubCopyWithImpl<$Res, _$OpenCIUserGitHubImpl>
    implements _$$OpenCIUserGitHubImplCopyWith<$Res> {
  __$$OpenCIUserGitHubImplCopyWithImpl(_$OpenCIUserGitHubImpl _value,
      $Res Function(_$OpenCIUserGitHubImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? installationId = freezed,
    Object? login = freezed,
    Object? repositories = freezed,
    Object? userId = freezed,
  }) {
    return _then(_$OpenCIUserGitHubImpl(
      installationId: freezed == installationId
          ? _value.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      repositories: freezed == repositories
          ? _value._repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<OpenCIRepository>?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenCIUserGitHubImpl implements _OpenCIUserGitHub {
  const _$OpenCIUserGitHubImpl(
      {this.installationId,
      this.login,
      final List<OpenCIRepository>? repositories,
      this.userId})
      : _repositories = repositories;

  factory _$OpenCIUserGitHubImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenCIUserGitHubImplFromJson(json);

  @override
  final int? installationId;
  @override
  final String? login;
  final List<OpenCIRepository>? _repositories;
  @override
  List<OpenCIRepository>? get repositories {
    final value = _repositories;
    if (value == null) return null;
    if (_repositories is EqualUnmodifiableListView) return _repositories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? userId;

  @override
  String toString() {
    return 'OpenCIUserGitHub(installationId: $installationId, login: $login, repositories: $repositories, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenCIUserGitHubImpl &&
            (identical(other.installationId, installationId) ||
                other.installationId == installationId) &&
            (identical(other.login, login) || other.login == login) &&
            const DeepCollectionEquality()
                .equals(other._repositories, _repositories) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, installationId, login,
      const DeepCollectionEquality().hash(_repositories), userId);

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenCIUserGitHubImplCopyWith<_$OpenCIUserGitHubImpl> get copyWith =>
      __$$OpenCIUserGitHubImplCopyWithImpl<_$OpenCIUserGitHubImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenCIUserGitHubImplToJson(
      this,
    );
  }
}

abstract class _OpenCIUserGitHub implements OpenCIUserGitHub {
  const factory _OpenCIUserGitHub(
      {final int? installationId,
      final String? login,
      final List<OpenCIRepository>? repositories,
      final int? userId}) = _$OpenCIUserGitHubImpl;

  factory _OpenCIUserGitHub.fromJson(Map<String, dynamic> json) =
      _$OpenCIUserGitHubImpl.fromJson;

  @override
  int? get installationId;
  @override
  String? get login;
  @override
  List<OpenCIRepository>? get repositories;
  @override
  int? get userId;

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenCIUserGitHubImplCopyWith<_$OpenCIUserGitHubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
