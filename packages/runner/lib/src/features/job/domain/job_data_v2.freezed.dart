// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_data_v2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BuildStatus _$BuildStatusFromJson(Map<String, dynamic> json) {
  return _BuildStatus.fromJson(json);
}

/// @nodoc
mixin _$BuildStatus {
  bool get processing => throw _privateConstructorUsedError;
  bool get failure => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BuildStatusCopyWith<BuildStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuildStatusCopyWith<$Res> {
  factory $BuildStatusCopyWith(
          BuildStatus value, $Res Function(BuildStatus) then) =
      _$BuildStatusCopyWithImpl<$Res, BuildStatus>;
  @useResult
  $Res call({bool processing, bool failure, bool success});
}

/// @nodoc
class _$BuildStatusCopyWithImpl<$Res, $Val extends BuildStatus>
    implements $BuildStatusCopyWith<$Res> {
  _$BuildStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processing = null,
    Object? failure = null,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      processing: null == processing
          ? _value.processing
          : processing // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuildStatusImplCopyWith<$Res>
    implements $BuildStatusCopyWith<$Res> {
  factory _$$BuildStatusImplCopyWith(
          _$BuildStatusImpl value, $Res Function(_$BuildStatusImpl) then) =
      __$$BuildStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool processing, bool failure, bool success});
}

/// @nodoc
class __$$BuildStatusImplCopyWithImpl<$Res>
    extends _$BuildStatusCopyWithImpl<$Res, _$BuildStatusImpl>
    implements _$$BuildStatusImplCopyWith<$Res> {
  __$$BuildStatusImplCopyWithImpl(
      _$BuildStatusImpl _value, $Res Function(_$BuildStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processing = null,
    Object? failure = null,
    Object? success = null,
  }) {
    return _then(_$BuildStatusImpl(
      processing: null == processing
          ? _value.processing
          : processing // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as bool,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuildStatusImpl implements _BuildStatus {
  const _$BuildStatusImpl(
      {required this.processing, required this.failure, required this.success});

  factory _$BuildStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuildStatusImplFromJson(json);

  @override
  final bool processing;
  @override
  final bool failure;
  @override
  final bool success;

  @override
  String toString() {
    return 'BuildStatus(processing: $processing, failure: $failure, success: $success)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuildStatusImpl &&
            (identical(other.processing, processing) ||
                other.processing == processing) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, processing, failure, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuildStatusImplCopyWith<_$BuildStatusImpl> get copyWith =>
      __$$BuildStatusImplCopyWithImpl<_$BuildStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuildStatusImplToJson(
      this,
    );
  }
}

abstract class _BuildStatus implements BuildStatus {
  const factory _BuildStatus(
      {required final bool processing,
      required final bool failure,
      required final bool success}) = _$BuildStatusImpl;

  factory _BuildStatus.fromJson(Map<String, dynamic> json) =
      _$BuildStatusImpl.fromJson;

  @override
  bool get processing;
  @override
  bool get failure;
  @override
  bool get success;
  @override
  @JsonKey(ignore: true)
  _$$BuildStatusImplCopyWith<_$BuildStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return _Branch.fromJson(json);
}

/// @nodoc
mixin _$Branch {
  String get baseBranch => throw _privateConstructorUsedError;
  String get buildBranch => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BranchCopyWith<Branch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchCopyWith<$Res> {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) then) =
      _$BranchCopyWithImpl<$Res, Branch>;
  @useResult
  $Res call({String baseBranch, String buildBranch});
}

/// @nodoc
class _$BranchCopyWithImpl<$Res, $Val extends Branch>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseBranch = null,
    Object? buildBranch = null,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$BranchImplCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$$BranchImplCopyWith(
          _$BranchImpl value, $Res Function(_$BranchImpl) then) =
      __$$BranchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String baseBranch, String buildBranch});
}

/// @nodoc
class __$$BranchImplCopyWithImpl<$Res>
    extends _$BranchCopyWithImpl<$Res, _$BranchImpl>
    implements _$$BranchImplCopyWith<$Res> {
  __$$BranchImplCopyWithImpl(
      _$BranchImpl _value, $Res Function(_$BranchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseBranch = null,
    Object? buildBranch = null,
  }) {
    return _then(_$BranchImpl(
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
class _$BranchImpl implements _Branch {
  const _$BranchImpl({required this.baseBranch, required this.buildBranch});

  factory _$BranchImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchImplFromJson(json);

  @override
  final String baseBranch;
  @override
  final String buildBranch;

  @override
  String toString() {
    return 'Branch(baseBranch: $baseBranch, buildBranch: $buildBranch)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchImpl &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch) &&
            (identical(other.buildBranch, buildBranch) ||
                other.buildBranch == buildBranch));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, baseBranch, buildBranch);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      __$$BranchImplCopyWithImpl<_$BranchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchImplToJson(
      this,
    );
  }
}

abstract class _Branch implements Branch {
  const factory _Branch(
      {required final String baseBranch,
      required final String buildBranch}) = _$BranchImpl;

  factory _Branch.fromJson(Map<String, dynamic> json) = _$BranchImpl.fromJson;

  @override
  String get baseBranch;
  @override
  String get buildBranch;
  @override
  @JsonKey(ignore: true)
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GithubChecks _$GithubChecksFromJson(Map<String, dynamic> json) {
  return _GithubChecks.fromJson(json);
}

/// @nodoc
mixin _$GithubChecks {
  int get checkRunId => throw _privateConstructorUsedError;
  int? get issueNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GithubChecksCopyWith<GithubChecks> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GithubChecksCopyWith<$Res> {
  factory $GithubChecksCopyWith(
          GithubChecks value, $Res Function(GithubChecks) then) =
      _$GithubChecksCopyWithImpl<$Res, GithubChecks>;
  @useResult
  $Res call({int checkRunId, int? issueNumber});
}

/// @nodoc
class _$GithubChecksCopyWithImpl<$Res, $Val extends GithubChecks>
    implements $GithubChecksCopyWith<$Res> {
  _$GithubChecksCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkRunId = null,
    Object? issueNumber = freezed,
  }) {
    return _then(_value.copyWith(
      checkRunId: null == checkRunId
          ? _value.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GithubChecksImplCopyWith<$Res>
    implements $GithubChecksCopyWith<$Res> {
  factory _$$GithubChecksImplCopyWith(
          _$GithubChecksImpl value, $Res Function(_$GithubChecksImpl) then) =
      __$$GithubChecksImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int checkRunId, int? issueNumber});
}

/// @nodoc
class __$$GithubChecksImplCopyWithImpl<$Res>
    extends _$GithubChecksCopyWithImpl<$Res, _$GithubChecksImpl>
    implements _$$GithubChecksImplCopyWith<$Res> {
  __$$GithubChecksImplCopyWithImpl(
      _$GithubChecksImpl _value, $Res Function(_$GithubChecksImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkRunId = null,
    Object? issueNumber = freezed,
  }) {
    return _then(_$GithubChecksImpl(
      checkRunId: null == checkRunId
          ? _value.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GithubChecksImpl implements _GithubChecks {
  const _$GithubChecksImpl({required this.checkRunId, this.issueNumber = null});

  factory _$GithubChecksImpl.fromJson(Map<String, dynamic> json) =>
      _$$GithubChecksImplFromJson(json);

  @override
  final int checkRunId;
  @override
  @JsonKey()
  final int? issueNumber;

  @override
  String toString() {
    return 'GithubChecks(checkRunId: $checkRunId, issueNumber: $issueNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GithubChecksImpl &&
            (identical(other.checkRunId, checkRunId) ||
                other.checkRunId == checkRunId) &&
            (identical(other.issueNumber, issueNumber) ||
                other.issueNumber == issueNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, checkRunId, issueNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GithubChecksImplCopyWith<_$GithubChecksImpl> get copyWith =>
      __$$GithubChecksImplCopyWithImpl<_$GithubChecksImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GithubChecksImplToJson(
      this,
    );
  }
}

abstract class _GithubChecks implements GithubChecks {
  const factory _GithubChecks(
      {required final int checkRunId,
      final int? issueNumber}) = _$GithubChecksImpl;

  factory _GithubChecks.fromJson(Map<String, dynamic> json) =
      _$GithubChecksImpl.fromJson;

  @override
  int get checkRunId;
  @override
  int? get issueNumber;
  @override
  @JsonKey(ignore: true)
  _$$GithubChecksImplCopyWith<_$GithubChecksImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Github _$GithubFromJson(Map<String, dynamic> json) {
  return _Github.fromJson(json);
}

/// @nodoc
mixin _$Github {
  String get repositoryUrl => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get repositoryName => throw _privateConstructorUsedError;
  int get installationId => throw _privateConstructorUsedError;
  int get appId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GithubCopyWith<Github> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GithubCopyWith<$Res> {
  factory $GithubCopyWith(Github value, $Res Function(Github) then) =
      _$GithubCopyWithImpl<$Res, Github>;
  @useResult
  $Res call(
      {String repositoryUrl,
      String owner,
      String repositoryName,
      int installationId,
      int appId});
}

/// @nodoc
class _$GithubCopyWithImpl<$Res, $Val extends Github>
    implements $GithubCopyWith<$Res> {
  _$GithubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repositoryUrl = null,
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? appId = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GithubImplCopyWith<$Res> implements $GithubCopyWith<$Res> {
  factory _$$GithubImplCopyWith(
          _$GithubImpl value, $Res Function(_$GithubImpl) then) =
      __$$GithubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String repositoryUrl,
      String owner,
      String repositoryName,
      int installationId,
      int appId});
}

/// @nodoc
class __$$GithubImplCopyWithImpl<$Res>
    extends _$GithubCopyWithImpl<$Res, _$GithubImpl>
    implements _$$GithubImplCopyWith<$Res> {
  __$$GithubImplCopyWithImpl(
      _$GithubImpl _value, $Res Function(_$GithubImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repositoryUrl = null,
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? appId = null,
  }) {
    return _then(_$GithubImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GithubImpl implements _Github {
  const _$GithubImpl(
      {required this.repositoryUrl,
      required this.owner,
      required this.repositoryName,
      required this.installationId,
      required this.appId});

  factory _$GithubImpl.fromJson(Map<String, dynamic> json) =>
      _$$GithubImplFromJson(json);

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
  String toString() {
    return 'Github(repositoryUrl: $repositoryUrl, owner: $owner, repositoryName: $repositoryName, installationId: $installationId, appId: $appId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GithubImpl &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.repositoryName, repositoryName) ||
                other.repositoryName == repositoryName) &&
            (identical(other.installationId, installationId) ||
                other.installationId == installationId) &&
            (identical(other.appId, appId) || other.appId == appId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, repositoryUrl, owner, repositoryName, installationId, appId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GithubImplCopyWith<_$GithubImpl> get copyWith =>
      __$$GithubImplCopyWithImpl<_$GithubImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GithubImplToJson(
      this,
    );
  }
}

abstract class _Github implements Github {
  const factory _Github(
      {required final String repositoryUrl,
      required final String owner,
      required final String repositoryName,
      required final int installationId,
      required final int appId}) = _$GithubImpl;

  factory _Github.fromJson(Map<String, dynamic> json) = _$GithubImpl.fromJson;

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
  @JsonKey(ignore: true)
  _$$GithubImplCopyWith<_$GithubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuildModel _$BuildModelFromJson(Map<String, dynamic> json) {
  return _BuildModel.fromJson(json);
}

/// @nodoc
mixin _$BuildModel {
  BuildStatus get buildStatus => throw _privateConstructorUsedError;
  Branch get branch => throw _privateConstructorUsedError;
  GithubChecks get githubChecks => throw _privateConstructorUsedError;
  Github get github => throw _privateConstructorUsedError;
  String get documentId => throw _privateConstructorUsedError;
  TargetPlatform get platform => throw _privateConstructorUsedError;
  String get workflowId => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BuildModelCopyWith<BuildModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuildModelCopyWith<$Res> {
  factory $BuildModelCopyWith(
          BuildModel value, $Res Function(BuildModel) then) =
      _$BuildModelCopyWithImpl<$Res, BuildModel>;
  @useResult
  $Res call(
      {BuildStatus buildStatus,
      Branch branch,
      GithubChecks githubChecks,
      Github github,
      String documentId,
      TargetPlatform platform,
      String workflowId,
      @TimestampConverter() Timestamp? createdAt});

  $BuildStatusCopyWith<$Res> get buildStatus;
  $BranchCopyWith<$Res> get branch;
  $GithubChecksCopyWith<$Res> get githubChecks;
  $GithubCopyWith<$Res> get github;
}

/// @nodoc
class _$BuildModelCopyWithImpl<$Res, $Val extends BuildModel>
    implements $BuildModelCopyWith<$Res> {
  _$BuildModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildStatus = null,
    Object? branch = null,
    Object? githubChecks = null,
    Object? github = null,
    Object? documentId = null,
    Object? platform = null,
    Object? workflowId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      buildStatus: null == buildStatus
          ? _value.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as BuildStatus,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as Branch,
      githubChecks: null == githubChecks
          ? _value.githubChecks
          : githubChecks // ignore: cast_nullable_to_non_nullable
              as GithubChecks,
      github: null == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as Github,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TargetPlatform,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BuildStatusCopyWith<$Res> get buildStatus {
    return $BuildStatusCopyWith<$Res>(_value.buildStatus, (value) {
      return _then(_value.copyWith(buildStatus: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BranchCopyWith<$Res> get branch {
    return $BranchCopyWith<$Res>(_value.branch, (value) {
      return _then(_value.copyWith(branch: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GithubChecksCopyWith<$Res> get githubChecks {
    return $GithubChecksCopyWith<$Res>(_value.githubChecks, (value) {
      return _then(_value.copyWith(githubChecks: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GithubCopyWith<$Res> get github {
    return $GithubCopyWith<$Res>(_value.github, (value) {
      return _then(_value.copyWith(github: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BuildModelImplCopyWith<$Res>
    implements $BuildModelCopyWith<$Res> {
  factory _$$BuildModelImplCopyWith(
          _$BuildModelImpl value, $Res Function(_$BuildModelImpl) then) =
      __$$BuildModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BuildStatus buildStatus,
      Branch branch,
      GithubChecks githubChecks,
      Github github,
      String documentId,
      TargetPlatform platform,
      String workflowId,
      @TimestampConverter() Timestamp? createdAt});

  @override
  $BuildStatusCopyWith<$Res> get buildStatus;
  @override
  $BranchCopyWith<$Res> get branch;
  @override
  $GithubChecksCopyWith<$Res> get githubChecks;
  @override
  $GithubCopyWith<$Res> get github;
}

/// @nodoc
class __$$BuildModelImplCopyWithImpl<$Res>
    extends _$BuildModelCopyWithImpl<$Res, _$BuildModelImpl>
    implements _$$BuildModelImplCopyWith<$Res> {
  __$$BuildModelImplCopyWithImpl(
      _$BuildModelImpl _value, $Res Function(_$BuildModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildStatus = null,
    Object? branch = null,
    Object? githubChecks = null,
    Object? github = null,
    Object? documentId = null,
    Object? platform = null,
    Object? workflowId = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$BuildModelImpl(
      buildStatus: null == buildStatus
          ? _value.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as BuildStatus,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as Branch,
      githubChecks: null == githubChecks
          ? _value.githubChecks
          : githubChecks // ignore: cast_nullable_to_non_nullable
              as GithubChecks,
      github: null == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as Github,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TargetPlatform,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuildModelImpl implements _BuildModel {
  const _$BuildModelImpl(
      {required this.buildStatus,
      required this.branch,
      required this.githubChecks,
      required this.github,
      required this.documentId,
      required this.platform,
      required this.workflowId,
      @TimestampConverter() this.createdAt = null});

  factory _$BuildModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuildModelImplFromJson(json);

  @override
  final BuildStatus buildStatus;
  @override
  final Branch branch;
  @override
  final GithubChecks githubChecks;
  @override
  final Github github;
  @override
  final String documentId;
  @override
  final TargetPlatform platform;
  @override
  final String workflowId;
  @override
  @JsonKey()
  @TimestampConverter()
  final Timestamp? createdAt;

  @override
  String toString() {
    return 'BuildModel(buildStatus: $buildStatus, branch: $branch, githubChecks: $githubChecks, github: $github, documentId: $documentId, platform: $platform, workflowId: $workflowId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuildModelImpl &&
            (identical(other.buildStatus, buildStatus) ||
                other.buildStatus == buildStatus) &&
            (identical(other.branch, branch) || other.branch == branch) &&
            (identical(other.githubChecks, githubChecks) ||
                other.githubChecks == githubChecks) &&
            (identical(other.github, github) || other.github == github) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, buildStatus, branch,
      githubChecks, github, documentId, platform, workflowId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuildModelImplCopyWith<_$BuildModelImpl> get copyWith =>
      __$$BuildModelImplCopyWithImpl<_$BuildModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuildModelImplToJson(
      this,
    );
  }
}

abstract class _BuildModel implements BuildModel {
  const factory _BuildModel(
      {required final BuildStatus buildStatus,
      required final Branch branch,
      required final GithubChecks githubChecks,
      required final Github github,
      required final String documentId,
      required final TargetPlatform platform,
      required final String workflowId,
      @TimestampConverter() final Timestamp? createdAt}) = _$BuildModelImpl;

  factory _BuildModel.fromJson(Map<String, dynamic> json) =
      _$BuildModelImpl.fromJson;

  @override
  BuildStatus get buildStatus;
  @override
  Branch get branch;
  @override
  GithubChecks get githubChecks;
  @override
  Github get github;
  @override
  String get documentId;
  @override
  TargetPlatform get platform;
  @override
  String get workflowId;
  @override
  @TimestampConverter()
  Timestamp? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BuildModelImplCopyWith<_$BuildModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
