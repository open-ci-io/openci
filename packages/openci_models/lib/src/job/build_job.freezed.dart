// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'build_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BuildJob _$BuildJobFromJson(Map<String, dynamic> json) {
  return _BuildJob.fromJson(json);
}

/// @nodoc
mixin _$BuildJob {
  OpenCIGitHubChecksStatus get buildStatus =>
      throw _privateConstructorUsedError;
  OpenCIGithub get github => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get workflowId => throw _privateConstructorUsedError;
  int? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BuildJob to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuildJobCopyWith<BuildJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuildJobCopyWith<$Res> {
  factory $BuildJobCopyWith(BuildJob value, $Res Function(BuildJob) then) =
      _$BuildJobCopyWithImpl<$Res, BuildJob>;
  @useResult
  $Res call(
      {OpenCIGitHubChecksStatus buildStatus,
      OpenCIGithub github,
      String id,
      String workflowId,
      int? createdAt});

  $OpenCIGithubCopyWith<$Res> get github;
}

/// @nodoc
class _$BuildJobCopyWithImpl<$Res, $Val extends BuildJob>
    implements $BuildJobCopyWith<$Res> {
  _$BuildJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildStatus = null,
    Object? github = null,
    Object? id = null,
    Object? workflowId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      buildStatus: null == buildStatus
          ? _value.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as OpenCIGitHubChecksStatus,
      github: null == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIGithub,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenCIGithubCopyWith<$Res> get github {
    return $OpenCIGithubCopyWith<$Res>(_value.github, (value) {
      return _then(_value.copyWith(github: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BuildJobImplCopyWith<$Res>
    implements $BuildJobCopyWith<$Res> {
  factory _$$BuildJobImplCopyWith(
          _$BuildJobImpl value, $Res Function(_$BuildJobImpl) then) =
      __$$BuildJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OpenCIGitHubChecksStatus buildStatus,
      OpenCIGithub github,
      String id,
      String workflowId,
      int? createdAt});

  @override
  $OpenCIGithubCopyWith<$Res> get github;
}

/// @nodoc
class __$$BuildJobImplCopyWithImpl<$Res>
    extends _$BuildJobCopyWithImpl<$Res, _$BuildJobImpl>
    implements _$$BuildJobImplCopyWith<$Res> {
  __$$BuildJobImplCopyWithImpl(
      _$BuildJobImpl _value, $Res Function(_$BuildJobImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildStatus = null,
    Object? github = null,
    Object? id = null,
    Object? workflowId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$BuildJobImpl(
      buildStatus: null == buildStatus
          ? _value.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as OpenCIGitHubChecksStatus,
      github: null == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIGithub,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuildJobImpl implements _BuildJob {
  const _$BuildJobImpl(
      {required this.buildStatus,
      required this.github,
      required this.id,
      required this.workflowId,
      this.createdAt = null});

  factory _$BuildJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuildJobImplFromJson(json);

  @override
  final OpenCIGitHubChecksStatus buildStatus;
  @override
  final OpenCIGithub github;
  @override
  final String id;
  @override
  final String workflowId;
  @override
  @JsonKey()
  final int? createdAt;

  @override
  String toString() {
    return 'BuildJob(buildStatus: $buildStatus, github: $github, id: $id, workflowId: $workflowId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuildJobImpl &&
            (identical(other.buildStatus, buildStatus) ||
                other.buildStatus == buildStatus) &&
            (identical(other.github, github) || other.github == github) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, buildStatus, github, id, workflowId, createdAt);

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuildJobImplCopyWith<_$BuildJobImpl> get copyWith =>
      __$$BuildJobImplCopyWithImpl<_$BuildJobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuildJobImplToJson(
      this,
    );
  }
}

abstract class _BuildJob implements BuildJob {
  const factory _BuildJob(
      {required final OpenCIGitHubChecksStatus buildStatus,
      required final OpenCIGithub github,
      required final String id,
      required final String workflowId,
      final int? createdAt}) = _$BuildJobImpl;

  factory _BuildJob.fromJson(Map<String, dynamic> json) =
      _$BuildJobImpl.fromJson;

  @override
  OpenCIGitHubChecksStatus get buildStatus;
  @override
  OpenCIGithub get github;
  @override
  String get id;
  @override
  String get workflowId;
  @override
  int? get createdAt;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuildJobImplCopyWith<_$BuildJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenCIGithub _$OpenCIGithubFromJson(Map<String, dynamic> json) {
  return _OpenCIGithub.fromJson(json);
}

/// @nodoc
mixin _$OpenCIGithub {
// TODO(someone): rename to repositoryFullName
  String get repositoryUrl => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get repositoryName => throw _privateConstructorUsedError;
  int get installationId => throw _privateConstructorUsedError;
  int get appId => throw _privateConstructorUsedError;
  int get checkRunId => throw _privateConstructorUsedError;
  int? get issueNumber => throw _privateConstructorUsedError;
  String get baseBranch => throw _privateConstructorUsedError;
  String get buildBranch => throw _privateConstructorUsedError;

  /// Serializes this OpenCIGithub to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenCIGithubCopyWith<OpenCIGithub> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenCIGithubCopyWith<$Res> {
  factory $OpenCIGithubCopyWith(
          OpenCIGithub value, $Res Function(OpenCIGithub) then) =
      _$OpenCIGithubCopyWithImpl<$Res, OpenCIGithub>;
  @useResult
  $Res call(
      {String repositoryUrl,
      String owner,
      String repositoryName,
      int installationId,
      int appId,
      int checkRunId,
      int? issueNumber,
      String baseBranch,
      String buildBranch});
}

/// @nodoc
class _$OpenCIGithubCopyWithImpl<$Res, $Val extends OpenCIGithub>
    implements $OpenCIGithubCopyWith<$Res> {
  _$OpenCIGithubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repositoryUrl = null,
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? appId = null,
    Object? checkRunId = null,
    Object? issueNumber = freezed,
    Object? baseBranch = null,
    Object? buildBranch = null,
  }) {
    return _then(_value.copyWith(
      repositoryUrl: null == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      repositoryName: null == repositoryName
          ? _value.repositoryName
          : repositoryName // ignore: cast_nullable_to_non_nullable
              as String,
      installationId: null == installationId
          ? _value.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as int,
      checkRunId: null == checkRunId
          ? _value.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      baseBranch: null == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      buildBranch: null == buildBranch
          ? _value.buildBranch
          : buildBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenCIGithubImplCopyWith<$Res>
    implements $OpenCIGithubCopyWith<$Res> {
  factory _$$OpenCIGithubImplCopyWith(
          _$OpenCIGithubImpl value, $Res Function(_$OpenCIGithubImpl) then) =
      __$$OpenCIGithubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String repositoryUrl,
      String owner,
      String repositoryName,
      int installationId,
      int appId,
      int checkRunId,
      int? issueNumber,
      String baseBranch,
      String buildBranch});
}

/// @nodoc
class __$$OpenCIGithubImplCopyWithImpl<$Res>
    extends _$OpenCIGithubCopyWithImpl<$Res, _$OpenCIGithubImpl>
    implements _$$OpenCIGithubImplCopyWith<$Res> {
  __$$OpenCIGithubImplCopyWithImpl(
      _$OpenCIGithubImpl _value, $Res Function(_$OpenCIGithubImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repositoryUrl = null,
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? appId = null,
    Object? checkRunId = null,
    Object? issueNumber = freezed,
    Object? baseBranch = null,
    Object? buildBranch = null,
  }) {
    return _then(_$OpenCIGithubImpl(
      repositoryUrl: null == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      repositoryName: null == repositoryName
          ? _value.repositoryName
          : repositoryName // ignore: cast_nullable_to_non_nullable
              as String,
      installationId: null == installationId
          ? _value.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as int,
      checkRunId: null == checkRunId
          ? _value.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      baseBranch: null == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      buildBranch: null == buildBranch
          ? _value.buildBranch
          : buildBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenCIGithubImpl implements _OpenCIGithub {
  const _$OpenCIGithubImpl(
      {required this.repositoryUrl,
      required this.owner,
      required this.repositoryName,
      required this.installationId,
      required this.appId,
      required this.checkRunId,
      this.issueNumber = null,
      required this.baseBranch,
      required this.buildBranch});

  factory _$OpenCIGithubImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenCIGithubImplFromJson(json);

// TODO(someone): rename to repositoryFullName
  @override
  final String repositoryUrl;
  @override
  final String owner;
  @override
  final String repositoryName;
  @override
  final int installationId;
  @override
  final int appId;
  @override
  final int checkRunId;
  @override
  @JsonKey()
  final int? issueNumber;
  @override
  final String baseBranch;
  @override
  final String buildBranch;

  @override
  String toString() {
    return 'OpenCIGithub(repositoryUrl: $repositoryUrl, owner: $owner, repositoryName: $repositoryName, installationId: $installationId, appId: $appId, checkRunId: $checkRunId, issueNumber: $issueNumber, baseBranch: $baseBranch, buildBranch: $buildBranch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenCIGithubImpl &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.repositoryName, repositoryName) ||
                other.repositoryName == repositoryName) &&
            (identical(other.installationId, installationId) ||
                other.installationId == installationId) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.checkRunId, checkRunId) ||
                other.checkRunId == checkRunId) &&
            (identical(other.issueNumber, issueNumber) ||
                other.issueNumber == issueNumber) &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch) &&
            (identical(other.buildBranch, buildBranch) ||
                other.buildBranch == buildBranch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      repositoryUrl,
      owner,
      repositoryName,
      installationId,
      appId,
      checkRunId,
      issueNumber,
      baseBranch,
      buildBranch);

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenCIGithubImplCopyWith<_$OpenCIGithubImpl> get copyWith =>
      __$$OpenCIGithubImplCopyWithImpl<_$OpenCIGithubImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenCIGithubImplToJson(
      this,
    );
  }
}

abstract class _OpenCIGithub implements OpenCIGithub {
  const factory _OpenCIGithub(
      {required final String repositoryUrl,
      required final String owner,
      required final String repositoryName,
      required final int installationId,
      required final int appId,
      required final int checkRunId,
      final int? issueNumber,
      required final String baseBranch,
      required final String buildBranch}) = _$OpenCIGithubImpl;

  factory _OpenCIGithub.fromJson(Map<String, dynamic> json) =
      _$OpenCIGithubImpl.fromJson;

// TODO(someone): rename to repositoryFullName
  @override
  String get repositoryUrl;
  @override
  String get owner;
  @override
  String get repositoryName;
  @override
  int get installationId;
  @override
  int get appId;
  @override
  int get checkRunId;
  @override
  int? get issueNumber;
  @override
  String get baseBranch;
  @override
  String get buildBranch;

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenCIGithubImplCopyWith<_$OpenCIGithubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
