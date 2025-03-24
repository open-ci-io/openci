// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpenCIUserGitHub {
  int? get installationId;
  String? get login;
  List<OpenCIGitHubRepository>? get repositories;
  int? get userId;

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OpenCIUserGitHubCopyWith<OpenCIUserGitHub> get copyWith =>
      _$OpenCIUserGitHubCopyWithImpl<OpenCIUserGitHub>(
          this as OpenCIUserGitHub, _$identity);

  /// Serializes this OpenCIUserGitHub to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OpenCIUserGitHub &&
            (identical(other.installationId, installationId) ||
                other.installationId == installationId) &&
            (identical(other.login, login) || other.login == login) &&
            const DeepCollectionEquality()
                .equals(other.repositories, repositories) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, installationId, login,
      const DeepCollectionEquality().hash(repositories), userId);

  @override
  String toString() {
    return 'OpenCIUserGitHub(installationId: $installationId, login: $login, repositories: $repositories, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $OpenCIUserGitHubCopyWith<$Res> {
  factory $OpenCIUserGitHubCopyWith(
          OpenCIUserGitHub value, $Res Function(OpenCIUserGitHub) _then) =
      _$OpenCIUserGitHubCopyWithImpl;
  @useResult
  $Res call(
      {int? installationId,
      String? login,
      List<OpenCIGitHubRepository>? repositories,
      int? userId});
}

/// @nodoc
class _$OpenCIUserGitHubCopyWithImpl<$Res>
    implements $OpenCIUserGitHubCopyWith<$Res> {
  _$OpenCIUserGitHubCopyWithImpl(this._self, this._then);

  final OpenCIUserGitHub _self;
  final $Res Function(OpenCIUserGitHub) _then;

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
    return _then(_self.copyWith(
      installationId: freezed == installationId
          ? _self.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      repositories: freezed == repositories
          ? _self.repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<OpenCIGitHubRepository>?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OpenCIUserGitHub implements OpenCIUserGitHub {
  const _OpenCIUserGitHub(
      {this.installationId,
      this.login,
      final List<OpenCIGitHubRepository>? repositories,
      this.userId})
      : _repositories = repositories;
  factory _OpenCIUserGitHub.fromJson(Map<String, dynamic> json) =>
      _$OpenCIUserGitHubFromJson(json);

  @override
  final int? installationId;
  @override
  final String? login;
  final List<OpenCIGitHubRepository>? _repositories;
  @override
  List<OpenCIGitHubRepository>? get repositories {
    final value = _repositories;
    if (value == null) return null;
    if (_repositories is EqualUnmodifiableListView) return _repositories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? userId;

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OpenCIUserGitHubCopyWith<_OpenCIUserGitHub> get copyWith =>
      __$OpenCIUserGitHubCopyWithImpl<_OpenCIUserGitHub>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OpenCIUserGitHubToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OpenCIUserGitHub &&
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

  @override
  String toString() {
    return 'OpenCIUserGitHub(installationId: $installationId, login: $login, repositories: $repositories, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class _$OpenCIUserGitHubCopyWith<$Res>
    implements $OpenCIUserGitHubCopyWith<$Res> {
  factory _$OpenCIUserGitHubCopyWith(
          _OpenCIUserGitHub value, $Res Function(_OpenCIUserGitHub) _then) =
      __$OpenCIUserGitHubCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? installationId,
      String? login,
      List<OpenCIGitHubRepository>? repositories,
      int? userId});
}

/// @nodoc
class __$OpenCIUserGitHubCopyWithImpl<$Res>
    implements _$OpenCIUserGitHubCopyWith<$Res> {
  __$OpenCIUserGitHubCopyWithImpl(this._self, this._then);

  final _OpenCIUserGitHub _self;
  final $Res Function(_OpenCIUserGitHub) _then;

  /// Create a copy of OpenCIUserGitHub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? installationId = freezed,
    Object? login = freezed,
    Object? repositories = freezed,
    Object? userId = freezed,
  }) {
    return _then(_OpenCIUserGitHub(
      installationId: freezed == installationId
          ? _self.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      repositories: freezed == repositories
          ? _self._repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<OpenCIGitHubRepository>?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
