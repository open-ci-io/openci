// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JobModel _$JobModelFromJson(Map<String, dynamic> json) {
  return _JobModel.fromJson(json);
}

/// @nodoc
mixin _$JobModel {
  int get id => throw _privateConstructorUsedError;
  DateTime get created_at => throw _privateConstructorUsedError;
  DateTime get updated_at => throw _privateConstructorUsedError;
  JobStatus get status => throw _privateConstructorUsedError;
  String get github_org_name => throw _privateConstructorUsedError;
  String get github_repo_name => throw _privateConstructorUsedError;
  int get workflow_run_id => throw _privateConstructorUsedError;
  int get github_installation_id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JobModelCopyWith<JobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobModelCopyWith<$Res> {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) then) =
      _$JobModelCopyWithImpl<$Res, JobModel>;
  @useResult
  $Res call(
      {int id,
      DateTime created_at,
      DateTime updated_at,
      JobStatus status,
      String github_org_name,
      String github_repo_name,
      int workflow_run_id,
      int github_installation_id});
}

/// @nodoc
class _$JobModelCopyWithImpl<$Res, $Val extends JobModel>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? created_at = null,
    Object? updated_at = null,
    Object? status = null,
    Object? github_org_name = null,
    Object? github_repo_name = null,
    Object? workflow_run_id = null,
    Object? github_installation_id = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JobStatus,
      github_org_name: null == github_org_name
          ? _value.github_org_name
          : github_org_name // ignore: cast_nullable_to_non_nullable
              as String,
      github_repo_name: null == github_repo_name
          ? _value.github_repo_name
          : github_repo_name // ignore: cast_nullable_to_non_nullable
              as String,
      workflow_run_id: null == workflow_run_id
          ? _value.workflow_run_id
          : workflow_run_id // ignore: cast_nullable_to_non_nullable
              as int,
      github_installation_id: null == github_installation_id
          ? _value.github_installation_id
          : github_installation_id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JobModelImplCopyWith<$Res>
    implements $JobModelCopyWith<$Res> {
  factory _$$JobModelImplCopyWith(
          _$JobModelImpl value, $Res Function(_$JobModelImpl) then) =
      __$$JobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime created_at,
      DateTime updated_at,
      JobStatus status,
      String github_org_name,
      String github_repo_name,
      int workflow_run_id,
      int github_installation_id});
}

/// @nodoc
class __$$JobModelImplCopyWithImpl<$Res>
    extends _$JobModelCopyWithImpl<$Res, _$JobModelImpl>
    implements _$$JobModelImplCopyWith<$Res> {
  __$$JobModelImplCopyWithImpl(
      _$JobModelImpl _value, $Res Function(_$JobModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? created_at = null,
    Object? updated_at = null,
    Object? status = null,
    Object? github_org_name = null,
    Object? github_repo_name = null,
    Object? workflow_run_id = null,
    Object? github_installation_id = null,
  }) {
    return _then(_$JobModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JobStatus,
      github_org_name: null == github_org_name
          ? _value.github_org_name
          : github_org_name // ignore: cast_nullable_to_non_nullable
              as String,
      github_repo_name: null == github_repo_name
          ? _value.github_repo_name
          : github_repo_name // ignore: cast_nullable_to_non_nullable
              as String,
      workflow_run_id: null == workflow_run_id
          ? _value.workflow_run_id
          : workflow_run_id // ignore: cast_nullable_to_non_nullable
              as int,
      github_installation_id: null == github_installation_id
          ? _value.github_installation_id
          : github_installation_id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobModelImpl implements _JobModel {
  const _$JobModelImpl(
      {required this.id,
      required this.created_at,
      required this.updated_at,
      required this.status,
      required this.github_org_name,
      required this.github_repo_name,
      required this.workflow_run_id,
      required this.github_installation_id});

  factory _$JobModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobModelImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime created_at;
  @override
  final DateTime updated_at;
  @override
  final JobStatus status;
  @override
  final String github_org_name;
  @override
  final String github_repo_name;
  @override
  final int workflow_run_id;
  @override
  final int github_installation_id;

  @override
  String toString() {
    return 'JobModel(id: $id, created_at: $created_at, updated_at: $updated_at, status: $status, github_org_name: $github_org_name, github_repo_name: $github_repo_name, workflow_run_id: $workflow_run_id, github_installation_id: $github_installation_id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.github_org_name, github_org_name) ||
                other.github_org_name == github_org_name) &&
            (identical(other.github_repo_name, github_repo_name) ||
                other.github_repo_name == github_repo_name) &&
            (identical(other.workflow_run_id, workflow_run_id) ||
                other.workflow_run_id == workflow_run_id) &&
            (identical(other.github_installation_id, github_installation_id) ||
                other.github_installation_id == github_installation_id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      created_at,
      updated_at,
      status,
      github_org_name,
      github_repo_name,
      workflow_run_id,
      github_installation_id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      __$$JobModelImplCopyWithImpl<_$JobModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobModelImplToJson(
      this,
    );
  }
}

abstract class _JobModel implements JobModel {
  const factory _JobModel(
      {required final int id,
      required final DateTime created_at,
      required final DateTime updated_at,
      required final JobStatus status,
      required final String github_org_name,
      required final String github_repo_name,
      required final int workflow_run_id,
      required final int github_installation_id}) = _$JobModelImpl;

  factory _JobModel.fromJson(Map<String, dynamic> json) =
      _$JobModelImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get created_at;
  @override
  DateTime get updated_at;
  @override
  JobStatus get status;
  @override
  String get github_org_name;
  @override
  String get github_repo_name;
  @override
  int get workflow_run_id;
  @override
  int get github_installation_id;
  @override
  @JsonKey(ignore: true)
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
