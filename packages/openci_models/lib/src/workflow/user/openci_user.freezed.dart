// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'openci_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpenCIUser {
  String get userId;
  int get createdAt;
  OpenCIUserGitHub? get github;

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OpenCIUserCopyWith<OpenCIUser> get copyWith =>
      _$OpenCIUserCopyWithImpl<OpenCIUser>(this as OpenCIUser, _$identity);

  /// Serializes this OpenCIUser to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OpenCIUser &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.github, github) || other.github == github));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, createdAt, github);

  @override
  String toString() {
    return 'OpenCIUser(userId: $userId, createdAt: $createdAt, github: $github)';
  }
}

/// @nodoc
abstract mixin class $OpenCIUserCopyWith<$Res> {
  factory $OpenCIUserCopyWith(
          OpenCIUser value, $Res Function(OpenCIUser) _then) =
      _$OpenCIUserCopyWithImpl;
  @useResult
  $Res call({String userId, int createdAt, OpenCIUserGitHub? github});

  $OpenCIUserGitHubCopyWith<$Res>? get github;
}

/// @nodoc
class _$OpenCIUserCopyWithImpl<$Res> implements $OpenCIUserCopyWith<$Res> {
  _$OpenCIUserCopyWithImpl(this._self, this._then);

  final OpenCIUser _self;
  final $Res Function(OpenCIUser) _then;

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? createdAt = null,
    Object? github = freezed,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      github: freezed == github
          ? _self.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIUserGitHub?,
    ));
  }

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenCIUserGitHubCopyWith<$Res>? get github {
    if (_self.github == null) {
      return null;
    }

    return $OpenCIUserGitHubCopyWith<$Res>(_self.github!, (value) {
      return _then(_self.copyWith(github: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _OpenCIUser implements OpenCIUser {
  const _OpenCIUser(
      {required this.userId, required this.createdAt, this.github});
  factory _OpenCIUser.fromJson(Map<String, dynamic> json) =>
      _$OpenCIUserFromJson(json);

  @override
  final String userId;
  @override
  final int createdAt;
  @override
  final OpenCIUserGitHub? github;

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OpenCIUserCopyWith<_OpenCIUser> get copyWith =>
      __$OpenCIUserCopyWithImpl<_OpenCIUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OpenCIUserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OpenCIUser &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.github, github) || other.github == github));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, createdAt, github);

  @override
  String toString() {
    return 'OpenCIUser(userId: $userId, createdAt: $createdAt, github: $github)';
  }
}

/// @nodoc
abstract mixin class _$OpenCIUserCopyWith<$Res>
    implements $OpenCIUserCopyWith<$Res> {
  factory _$OpenCIUserCopyWith(
          _OpenCIUser value, $Res Function(_OpenCIUser) _then) =
      __$OpenCIUserCopyWithImpl;
  @override
  @useResult
  $Res call({String userId, int createdAt, OpenCIUserGitHub? github});

  @override
  $OpenCIUserGitHubCopyWith<$Res>? get github;
}

/// @nodoc
class __$OpenCIUserCopyWithImpl<$Res> implements _$OpenCIUserCopyWith<$Res> {
  __$OpenCIUserCopyWithImpl(this._self, this._then);

  final _OpenCIUser _self;
  final $Res Function(_OpenCIUser) _then;

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? createdAt = null,
    Object? github = freezed,
  }) {
    return _then(_OpenCIUser(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int,
      github: freezed == github
          ? _self.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIUserGitHub?,
    ));
  }

  /// Create a copy of OpenCIUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenCIUserGitHubCopyWith<$Res>? get github {
    if (_self.github == null) {
      return null;
    }

    return $OpenCIUserGitHubCopyWith<$Res>(_self.github!, (value) {
      return _then(_self.copyWith(github: value));
    });
  }
}

// dart format on
