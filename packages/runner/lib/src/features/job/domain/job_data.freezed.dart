// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

JobData _$JobDataFromJson(Map<String, dynamic> json) {
  return _JobData.fromJson(json);
}

/// @nodoc
mixin _$JobData {
  String get buildBranch => throw _privateConstructorUsedError;
  String get documentId => throw _privateConstructorUsedError;
  String get githubRepositoryUrl => throw _privateConstructorUsedError;
  String get baseBranch => throw _privateConstructorUsedError;
  String get githubPAT => throw _privateConstructorUsedError;
  TargetPlatform get platform => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JobDataCopyWith<JobData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobDataCopyWith<$Res> {
  factory $JobDataCopyWith(JobData value, $Res Function(JobData) then) =
      _$JobDataCopyWithImpl<$Res, JobData>;
  @useResult
  $Res call(
      {String buildBranch,
      String documentId,
      String githubRepositoryUrl,
      String baseBranch,
      String githubPAT,
      TargetPlatform platform,
      String userId});
}

/// @nodoc
class _$JobDataCopyWithImpl<$Res, $Val extends JobData>
    implements $JobDataCopyWith<$Res> {
  _$JobDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildBranch = null,
    Object? documentId = null,
    Object? githubRepositoryUrl = null,
    Object? baseBranch = null,
    Object? githubPAT = null,
    Object? platform = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      buildBranch: null == buildBranch
          ? _value.buildBranch
          : buildBranch // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      githubRepositoryUrl: null == githubRepositoryUrl
          ? _value.githubRepositoryUrl
          : githubRepositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      baseBranch: null == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      githubPAT: null == githubPAT
          ? _value.githubPAT
          : githubPAT // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TargetPlatform,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobDataImplCopyWith<$Res> implements $JobDataCopyWith<$Res> {
  factory _$$JobDataImplCopyWith(
          _$JobDataImpl value, $Res Function(_$JobDataImpl) then) =
      __$$JobDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String buildBranch,
      String documentId,
      String githubRepositoryUrl,
      String baseBranch,
      String githubPAT,
      TargetPlatform platform,
      String userId});
}

/// @nodoc
class __$$JobDataImplCopyWithImpl<$Res>
    extends _$JobDataCopyWithImpl<$Res, _$JobDataImpl>
    implements _$$JobDataImplCopyWith<$Res> {
  __$$JobDataImplCopyWithImpl(
      _$JobDataImpl _value, $Res Function(_$JobDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildBranch = null,
    Object? documentId = null,
    Object? githubRepositoryUrl = null,
    Object? baseBranch = null,
    Object? githubPAT = null,
    Object? platform = null,
    Object? userId = null,
  }) {
    return _then(_$JobDataImpl(
      buildBranch: null == buildBranch
          ? _value.buildBranch
          : buildBranch // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      githubRepositoryUrl: null == githubRepositoryUrl
          ? _value.githubRepositoryUrl
          : githubRepositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      baseBranch: null == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      githubPAT: null == githubPAT
          ? _value.githubPAT
          : githubPAT // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TargetPlatform,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobDataImpl implements _JobData {
  const _$JobDataImpl(
      {required this.buildBranch,
      required this.documentId,
      required this.githubRepositoryUrl,
      required this.baseBranch,
      required this.githubPAT,
      required this.platform,
      required this.userId});

  factory _$JobDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobDataImplFromJson(json);

  @override
  final String buildBranch;
  @override
  final String documentId;
  @override
  final String githubRepositoryUrl;
  @override
  final String baseBranch;
  @override
  final String githubPAT;
  @override
  final TargetPlatform platform;
  @override
  final String userId;

  @override
  String toString() {
    return 'JobData(buildBranch: $buildBranch, documentId: $documentId, githubRepositoryUrl: $githubRepositoryUrl, baseBranch: $baseBranch, githubPAT: $githubPAT, platform: $platform, userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobDataImpl &&
            (identical(other.buildBranch, buildBranch) ||
                other.buildBranch == buildBranch) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.githubRepositoryUrl, githubRepositoryUrl) ||
                other.githubRepositoryUrl == githubRepositoryUrl) &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch) &&
            (identical(other.githubPAT, githubPAT) ||
                other.githubPAT == githubPAT) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, buildBranch, documentId,
      githubRepositoryUrl, baseBranch, githubPAT, platform, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JobDataImplCopyWith<_$JobDataImpl> get copyWith =>
      __$$JobDataImplCopyWithImpl<_$JobDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobDataImplToJson(
      this,
    );
  }
}

abstract class _JobData implements JobData {
  const factory _JobData(
      {required final String buildBranch,
      required final String documentId,
      required final String githubRepositoryUrl,
      required final String baseBranch,
      required final String githubPAT,
      required final TargetPlatform platform,
      required final String userId}) = _$JobDataImpl;

  factory _JobData.fromJson(Map<String, dynamic> json) = _$JobDataImpl.fromJson;

  @override
  String get buildBranch;
  @override
  String get documentId;
  @override
  String get githubRepositoryUrl;
  @override
  String get baseBranch;
  @override
  String get githubPAT;
  @override
  TargetPlatform get platform;
  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$JobDataImplCopyWith<_$JobDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JobModelV2 _$JobModelV2FromJson(Map<String, dynamic> json) {
  return _BuildModel.fromJson(json);
}

/// @nodoc
mixin _$JobModelV2 {
  String get baseBranch => throw _privateConstructorUsedError;
  String get buildBranch =>
      throw _privateConstructorUsedError; // ignore: non_constant_identifier_names
  String get PAT => throw _privateConstructorUsedError;
  String get repositoryUrl => throw _privateConstructorUsedError;
  TargetPlatform get platform => throw _privateConstructorUsedError;
  String get workflowId => throw _privateConstructorUsedError;
  Checks get checks =>
      throw _privateConstructorUsedError; // Default values when not provided
  BuildStatus get buildStatus => throw _privateConstructorUsedError;
  int? get issueNumber => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get createdAt => throw _privateConstructorUsedError;
  String? get documentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JobModelV2CopyWith<JobModelV2> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobModelV2CopyWith<$Res> {
  factory $JobModelV2CopyWith(
          JobModelV2 value, $Res Function(JobModelV2) then) =
      _$JobModelV2CopyWithImpl<$Res, JobModelV2>;
  @useResult
  $Res call(
      {String baseBranch,
      String buildBranch,
      String PAT,
      String repositoryUrl,
      TargetPlatform platform,
      String workflowId,
      Checks checks,
      BuildStatus buildStatus,
      int? issueNumber,
      @TimestampConverter() Timestamp? createdAt,
      String? documentId});

  $ChecksCopyWith<$Res> get checks;
  $BuildStatusCopyWith<$Res> get buildStatus;
}

/// @nodoc
class _$JobModelV2CopyWithImpl<$Res, $Val extends JobModelV2>
    implements $JobModelV2CopyWith<$Res> {
  _$JobModelV2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseBranch = null,
    Object? buildBranch = null,
    Object? PAT = null,
    Object? repositoryUrl = null,
    Object? platform = null,
    Object? workflowId = null,
    Object? checks = null,
    Object? buildStatus = null,
    Object? issueNumber = freezed,
    Object? createdAt = freezed,
    Object? documentId = freezed,
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
      PAT: null == PAT
          ? _value.PAT
          : PAT // ignore: cast_nullable_to_non_nullable
              as String,
      repositoryUrl: null == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TargetPlatform,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      checks: null == checks
          ? _value.checks
          : checks // ignore: cast_nullable_to_non_nullable
              as Checks,
      buildStatus: null == buildStatus
          ? _value.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as BuildStatus,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      documentId: freezed == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChecksCopyWith<$Res> get checks {
    return $ChecksCopyWith<$Res>(_value.checks, (value) {
      return _then(_value.copyWith(checks: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BuildStatusCopyWith<$Res> get buildStatus {
    return $BuildStatusCopyWith<$Res>(_value.buildStatus, (value) {
      return _then(_value.copyWith(buildStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BuildModelImplCopyWith<$Res>
    implements $JobModelV2CopyWith<$Res> {
  factory _$$BuildModelImplCopyWith(
          _$BuildModelImpl value, $Res Function(_$BuildModelImpl) then) =
      __$$BuildModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String baseBranch,
      String buildBranch,
      String PAT,
      String repositoryUrl,
      TargetPlatform platform,
      String workflowId,
      Checks checks,
      BuildStatus buildStatus,
      int? issueNumber,
      @TimestampConverter() Timestamp? createdAt,
      String? documentId});

  @override
  $ChecksCopyWith<$Res> get checks;
  @override
  $BuildStatusCopyWith<$Res> get buildStatus;
}

/// @nodoc
class __$$BuildModelImplCopyWithImpl<$Res>
    extends _$JobModelV2CopyWithImpl<$Res, _$BuildModelImpl>
    implements _$$BuildModelImplCopyWith<$Res> {
  __$$BuildModelImplCopyWithImpl(
      _$BuildModelImpl _value, $Res Function(_$BuildModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseBranch = null,
    Object? buildBranch = null,
    Object? PAT = null,
    Object? repositoryUrl = null,
    Object? platform = null,
    Object? workflowId = null,
    Object? checks = null,
    Object? buildStatus = null,
    Object? issueNumber = freezed,
    Object? createdAt = freezed,
    Object? documentId = freezed,
  }) {
    return _then(_$BuildModelImpl(
      baseBranch: null == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      buildBranch: null == buildBranch
          ? _value.buildBranch
          : buildBranch // ignore: cast_nullable_to_non_nullable
              as String,
      PAT: null == PAT
          ? _value.PAT
          : PAT // ignore: cast_nullable_to_non_nullable
              as String,
      repositoryUrl: null == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TargetPlatform,
      workflowId: null == workflowId
          ? _value.workflowId
          : workflowId // ignore: cast_nullable_to_non_nullable
              as String,
      checks: null == checks
          ? _value.checks
          : checks // ignore: cast_nullable_to_non_nullable
              as Checks,
      buildStatus: null == buildStatus
          ? _value.buildStatus
          : buildStatus // ignore: cast_nullable_to_non_nullable
              as BuildStatus,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      documentId: freezed == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuildModelImpl implements _BuildModel {
  const _$BuildModelImpl(
      {required this.baseBranch,
      required this.buildBranch,
      required this.PAT,
      required this.repositoryUrl,
      required this.platform,
      required this.workflowId,
      required this.checks,
      this.buildStatus =
          const BuildStatus(processing: false, failure: false, success: false),
      this.issueNumber,
      @TimestampConverter() this.createdAt = null,
      this.documentId});

  factory _$BuildModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuildModelImplFromJson(json);

  @override
  final String baseBranch;
  @override
  final String buildBranch;
// ignore: non_constant_identifier_names
  @override
  final String PAT;
  @override
  final String repositoryUrl;
  @override
  final TargetPlatform platform;
  @override
  final String workflowId;
  @override
  final Checks checks;
// Default values when not provided
  @override
  @JsonKey()
  final BuildStatus buildStatus;
  @override
  final int? issueNumber;
  @override
  @JsonKey()
  @TimestampConverter()
  final Timestamp? createdAt;
  @override
  final String? documentId;

  @override
  String toString() {
    return 'JobModelV2(baseBranch: $baseBranch, buildBranch: $buildBranch, PAT: $PAT, repositoryUrl: $repositoryUrl, platform: $platform, workflowId: $workflowId, checks: $checks, buildStatus: $buildStatus, issueNumber: $issueNumber, createdAt: $createdAt, documentId: $documentId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuildModelImpl &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch) &&
            (identical(other.buildBranch, buildBranch) ||
                other.buildBranch == buildBranch) &&
            (identical(other.PAT, PAT) || other.PAT == PAT) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.checks, checks) || other.checks == checks) &&
            (identical(other.buildStatus, buildStatus) ||
                other.buildStatus == buildStatus) &&
            (identical(other.issueNumber, issueNumber) ||
                other.issueNumber == issueNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      baseBranch,
      buildBranch,
      PAT,
      repositoryUrl,
      platform,
      workflowId,
      checks,
      buildStatus,
      issueNumber,
      createdAt,
      documentId);

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

abstract class _BuildModel implements JobModelV2 {
  const factory _BuildModel(
      {required final String baseBranch,
      required final String buildBranch,
      required final String PAT,
      required final String repositoryUrl,
      required final TargetPlatform platform,
      required final String workflowId,
      required final Checks checks,
      final BuildStatus buildStatus,
      final int? issueNumber,
      @TimestampConverter() final Timestamp? createdAt,
      final String? documentId}) = _$BuildModelImpl;

  factory _BuildModel.fromJson(Map<String, dynamic> json) =
      _$BuildModelImpl.fromJson;

  @override
  String get baseBranch;
  @override
  String get buildBranch;
  @override // ignore: non_constant_identifier_names
  String get PAT;
  @override
  String get repositoryUrl;
  @override
  TargetPlatform get platform;
  @override
  String get workflowId;
  @override
  Checks get checks;
  @override // Default values when not provided
  BuildStatus get buildStatus;
  @override
  int? get issueNumber;
  @override
  @TimestampConverter()
  Timestamp? get createdAt;
  @override
  String? get documentId;
  @override
  @JsonKey(ignore: true)
  _$$BuildModelImplCopyWith<_$BuildModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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

Checks _$ChecksFromJson(Map<String, dynamic> json) {
  return _Checks.fromJson(json);
}

/// @nodoc
mixin _$Checks {
  int get checkRunId => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get repositoryName => throw _privateConstructorUsedError;
  int get installationId => throw _privateConstructorUsedError;
  String get jobId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChecksCopyWith<Checks> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecksCopyWith<$Res> {
  factory $ChecksCopyWith(Checks value, $Res Function(Checks) then) =
      _$ChecksCopyWithImpl<$Res, Checks>;
  @useResult
  $Res call(
      {int checkRunId,
      String owner,
      String repositoryName,
      int installationId,
      String jobId});
}

/// @nodoc
class _$ChecksCopyWithImpl<$Res, $Val extends Checks>
    implements $ChecksCopyWith<$Res> {
  _$ChecksCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkRunId = null,
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? jobId = null,
  }) {
    return _then(_value.copyWith(
      checkRunId: null == checkRunId
          ? _value.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
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
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChecksImplCopyWith<$Res> implements $ChecksCopyWith<$Res> {
  factory _$$ChecksImplCopyWith(
          _$ChecksImpl value, $Res Function(_$ChecksImpl) then) =
      __$$ChecksImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int checkRunId,
      String owner,
      String repositoryName,
      int installationId,
      String jobId});
}

/// @nodoc
class __$$ChecksImplCopyWithImpl<$Res>
    extends _$ChecksCopyWithImpl<$Res, _$ChecksImpl>
    implements _$$ChecksImplCopyWith<$Res> {
  __$$ChecksImplCopyWithImpl(
      _$ChecksImpl _value, $Res Function(_$ChecksImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkRunId = null,
    Object? owner = null,
    Object? repositoryName = null,
    Object? installationId = null,
    Object? jobId = null,
  }) {
    return _then(_$ChecksImpl(
      checkRunId: null == checkRunId
          ? _value.checkRunId
          : checkRunId // ignore: cast_nullable_to_non_nullable
              as int,
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
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecksImpl implements _Checks {
  const _$ChecksImpl(
      {required this.checkRunId,
      required this.owner,
      required this.repositoryName,
      required this.installationId,
      required this.jobId});

  factory _$ChecksImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecksImplFromJson(json);

  @override
  final int checkRunId;
  @override
  final String owner;
  @override
  final String repositoryName;
  @override
  final int installationId;
  @override
  final String jobId;

  @override
  String toString() {
    return 'Checks(checkRunId: $checkRunId, owner: $owner, repositoryName: $repositoryName, installationId: $installationId, jobId: $jobId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecksImpl &&
            (identical(other.checkRunId, checkRunId) ||
                other.checkRunId == checkRunId) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.repositoryName, repositoryName) ||
                other.repositoryName == repositoryName) &&
            (identical(other.installationId, installationId) ||
                other.installationId == installationId) &&
            (identical(other.jobId, jobId) || other.jobId == jobId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, checkRunId, owner, repositoryName, installationId, jobId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecksImplCopyWith<_$ChecksImpl> get copyWith =>
      __$$ChecksImplCopyWithImpl<_$ChecksImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecksImplToJson(
      this,
    );
  }
}

abstract class _Checks implements Checks {
  const factory _Checks(
      {required final int checkRunId,
      required final String owner,
      required final String repositoryName,
      required final int installationId,
      required final String jobId}) = _$ChecksImpl;

  factory _Checks.fromJson(Map<String, dynamic> json) = _$ChecksImpl.fromJson;

  @override
  int get checkRunId;
  @override
  String get owner;
  @override
  String get repositoryName;
  @override
  int get installationId;
  @override
  String get jobId;
  @override
  @JsonKey(ignore: true)
  _$$ChecksImplCopyWith<_$ChecksImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
