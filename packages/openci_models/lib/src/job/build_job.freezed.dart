// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'build_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BuildJob {
  OpenCIGitHubChecksStatus get buildStatus;
  OpenCIGithub get github;
  String get id;
  String get workflowId;
  int? get createdAt;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BuildJobCopyWith<BuildJob> get copyWith =>
      _$BuildJobCopyWithImpl<BuildJob>(this as BuildJob, _$identity);

  /// Serializes this BuildJob to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BuildJob &&
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

  @override
  String toString() {
    return 'BuildJob(buildStatus: $buildStatus, github: $github, id: $id, workflowId: $workflowId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $BuildJobCopyWith<$Res> {
  factory $BuildJobCopyWith(BuildJob value, $Res Function(BuildJob) _then) =
      _$BuildJobCopyWithImpl;
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
class _$BuildJobCopyWithImpl<$Res> implements $BuildJobCopyWith<$Res> {
  _$BuildJobCopyWithImpl(this._self, this._then);

  final BuildJob _self;
  final $Res Function(BuildJob) _then;

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
    return _then(_self.copyWith(
      buildStatus: null == buildStatus
          ? _self.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as OpenCIGitHubChecksStatus,
      github: null == github
          ? _self.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIGithub,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _self.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenCIGithubCopyWith<$Res> get github {
    return $OpenCIGithubCopyWith<$Res>(_self.github, (value) {
      return _then(_self.copyWith(github: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _BuildJob implements BuildJob {
  const _BuildJob(
      {required this.buildStatus,
      required this.github,
      required this.id,
      required this.workflowId,
      this.createdAt = null});
  factory _BuildJob.fromJson(Map<String, dynamic> json) =>
      _$BuildJobFromJson(json);

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

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BuildJobCopyWith<_BuildJob> get copyWith =>
      __$BuildJobCopyWithImpl<_BuildJob>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BuildJobToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BuildJob &&
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

  @override
  String toString() {
    return 'BuildJob(buildStatus: $buildStatus, github: $github, id: $id, workflowId: $workflowId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$BuildJobCopyWith<$Res>
    implements $BuildJobCopyWith<$Res> {
  factory _$BuildJobCopyWith(_BuildJob value, $Res Function(_BuildJob) _then) =
      __$BuildJobCopyWithImpl;
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
class __$BuildJobCopyWithImpl<$Res> implements _$BuildJobCopyWith<$Res> {
  __$BuildJobCopyWithImpl(this._self, this._then);

  final _BuildJob _self;
  final $Res Function(_BuildJob) _then;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? buildStatus = null,
    Object? github = null,
    Object? id = null,
    Object? workflowId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_BuildJob(
      buildStatus: null == buildStatus
          ? _self.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as OpenCIGitHubChecksStatus,
      github: null == github
          ? _self.github
          : github // ignore: cast_nullable_to_non_nullable
              as OpenCIGithub,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workflowId: null == workflowId
          ? _self.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenCIGithubCopyWith<$Res> get github {
    return $OpenCIGithubCopyWith<$Res>(_self.github, (value) {
      return _then(_self.copyWith(github: value));
    });
  }
}

/// @nodoc
mixin _$OpenCIGithub {
  String get owner;
  String get repositoryName;
  int get installationId;
  int get appId;
  int get checkRunId;
  int? get issueNumber;
  String get baseBranch;
  String get buildBranch;

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OpenCIGithubCopyWith<OpenCIGithub> get copyWith =>
      _$OpenCIGithubCopyWithImpl<OpenCIGithub>(
          this as OpenCIGithub, _$identity);

  /// Serializes this OpenCIGithub to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OpenCIGithub &&
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
  int get hashCode => Object.hash(runtimeType, owner, repositoryName,
      installationId, appId, checkRunId, issueNumber, baseBranch, buildBranch);

  @override
  String toString() {
    return 'OpenCIGithub(owner: $owner, repositoryName: $repositoryName, installationId: $installationId, appId: $appId, checkRunId: $checkRunId, issueNumber: $issueNumber, baseBranch: $baseBranch, buildBranch: $buildBranch)';
  }
}

/// @nodoc
abstract mixin class $OpenCIGithubCopyWith<$Res> {
  factory $OpenCIGithubCopyWith(
          OpenCIGithub value, $Res Function(OpenCIGithub) _then) =
      _$OpenCIGithubCopyWithImpl;
  @useResult
  $Res call(
      {String owner,
      String repositoryName,
      int installationId,
      int appId,
      int checkRunId,
      int? issueNumber,
      String baseBranch,
      String buildBranch});
}

/// @nodoc
class _$OpenCIGithubCopyWithImpl<$Res> implements $OpenCIGithubCopyWith<$Res> {
  _$OpenCIGithubCopyWithImpl(this._self, this._then);

  final OpenCIGithub _self;
  final $Res Function(OpenCIGithub) _then;

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? appId = null,
    Object? checkRunId = null,
    Object? issueNumber = freezed,
    Object? baseBranch = null,
    Object? buildBranch = null,
  }) {
    return _then(_self.copyWith(
      owner: null == owner
          ? _self.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      repositoryName: null == repositoryName
          ? _self.repositoryName
          : repositoryName // ignore: cast_nullable_to_non_nullable
              as String,
      installationId: null == installationId
          ? _self.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int,
      appId: null == appId
          ? _self.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as int,
      checkRunId: null == checkRunId
          ? _self.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
      issueNumber: freezed == issueNumber
          ? _self.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      baseBranch: null == baseBranch
          ? _self.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      buildBranch: null == buildBranch
          ? _self.buildBranch
          : buildBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OpenCIGithub extends OpenCIGithub {
  const _OpenCIGithub(
      {required this.owner,
      required this.repositoryName,
      required this.installationId,
      required this.appId,
      required this.checkRunId,
      this.issueNumber = null,
      required this.baseBranch,
      required this.buildBranch})
      : super._();
  factory _OpenCIGithub.fromJson(Map<String, dynamic> json) =>
      _$OpenCIGithubFromJson(json);

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

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OpenCIGithubCopyWith<_OpenCIGithub> get copyWith =>
      __$OpenCIGithubCopyWithImpl<_OpenCIGithub>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OpenCIGithubToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OpenCIGithub &&
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
  int get hashCode => Object.hash(runtimeType, owner, repositoryName,
      installationId, appId, checkRunId, issueNumber, baseBranch, buildBranch);

  @override
  String toString() {
    return 'OpenCIGithub(owner: $owner, repositoryName: $repositoryName, installationId: $installationId, appId: $appId, checkRunId: $checkRunId, issueNumber: $issueNumber, baseBranch: $baseBranch, buildBranch: $buildBranch)';
  }
}

/// @nodoc
abstract mixin class _$OpenCIGithubCopyWith<$Res>
    implements $OpenCIGithubCopyWith<$Res> {
  factory _$OpenCIGithubCopyWith(
          _OpenCIGithub value, $Res Function(_OpenCIGithub) _then) =
      __$OpenCIGithubCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String owner,
      String repositoryName,
      int installationId,
      int appId,
      int checkRunId,
      int? issueNumber,
      String baseBranch,
      String buildBranch});
}

/// @nodoc
class __$OpenCIGithubCopyWithImpl<$Res>
    implements _$OpenCIGithubCopyWith<$Res> {
  __$OpenCIGithubCopyWithImpl(this._self, this._then);

  final _OpenCIGithub _self;
  final $Res Function(_OpenCIGithub) _then;

  /// Create a copy of OpenCIGithub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? appId = null,
    Object? checkRunId = null,
    Object? issueNumber = freezed,
    Object? baseBranch = null,
    Object? buildBranch = null,
  }) {
    return _then(_OpenCIGithub(
      owner: null == owner
          ? _self.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      repositoryName: null == repositoryName
          ? _self.repositoryName
          : repositoryName // ignore: cast_nullable_to_non_nullable
              as String,
      installationId: null == installationId
          ? _self.installationId
          : installationId // ignore: cast_nullable_to_non_nullable
              as int,
      appId: null == appId
          ? _self.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as int,
      checkRunId: null == checkRunId
          ? _self.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
      issueNumber: freezed == issueNumber
          ? _self.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      baseBranch: null == baseBranch
          ? _self.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      buildBranch: null == buildBranch
          ? _self.buildBranch
          : buildBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
