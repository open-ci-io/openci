// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkflowDomain _$WorkflowDomainFromJson(Map<String, dynamic> json) {
  return _WorkflowDomain.fromJson(json);
}

/// @nodoc
mixin _$WorkflowDomain {
  String get workflowName => throw _privateConstructorUsedError;
  String get branch => throw _privateConstructorUsedError;
  OnPush get on => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowDomainCopyWith<WorkflowDomain> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowDomainCopyWith<$Res> {
  factory $WorkflowDomainCopyWith(
          WorkflowDomain value, $Res Function(WorkflowDomain) then) =
      _$WorkflowDomainCopyWithImpl<$Res, WorkflowDomain>;
  @useResult
  $Res call({String workflowName, String branch, OnPush on});
}

/// @nodoc
class _$WorkflowDomainCopyWithImpl<$Res, $Val extends WorkflowDomain>
    implements $WorkflowDomainCopyWith<$Res> {
  _$WorkflowDomainCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflowName = null,
    Object? branch = null,
    Object? on = null,
  }) {
    return _then(_value.copyWith(
      workflowName: null == workflowName
          ? _value.workflowName
          : workflowName // ignore: cast_nullable_to_non_nullable
              as String,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
      on: null == on
          ? _value.on
          : on // ignore: cast_nullable_to_non_nullable
              as OnPush,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowDomainImplCopyWith<$Res>
    implements $WorkflowDomainCopyWith<$Res> {
  factory _$$WorkflowDomainImplCopyWith(_$WorkflowDomainImpl value,
          $Res Function(_$WorkflowDomainImpl) then) =
      __$$WorkflowDomainImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String workflowName, String branch, OnPush on});
}

/// @nodoc
class __$$WorkflowDomainImplCopyWithImpl<$Res>
    extends _$WorkflowDomainCopyWithImpl<$Res, _$WorkflowDomainImpl>
    implements _$$WorkflowDomainImplCopyWith<$Res> {
  __$$WorkflowDomainImplCopyWithImpl(
      _$WorkflowDomainImpl _value, $Res Function(_$WorkflowDomainImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflowName = null,
    Object? branch = null,
    Object? on = null,
  }) {
    return _then(_$WorkflowDomainImpl(
      workflowName: null == workflowName
          ? _value.workflowName
          : workflowName // ignore: cast_nullable_to_non_nullable
              as String,
      branch: null == branch
          ? _value.branch
          : branch // ignore: cast_nullable_to_non_nullable
              as String,
      on: null == on
          ? _value.on
          : on // ignore: cast_nullable_to_non_nullable
              as OnPush,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowDomainImpl implements _WorkflowDomain {
  const _$WorkflowDomainImpl(
      {required this.workflowName, required this.branch, required this.on});

  factory _$WorkflowDomainImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowDomainImplFromJson(json);

  @override
  final String workflowName;
  @override
  final String branch;
  @override
  final OnPush on;

  @override
  String toString() {
    return 'WorkflowDomain(workflowName: $workflowName, branch: $branch, on: $on)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowDomainImpl &&
            (identical(other.workflowName, workflowName) ||
                other.workflowName == workflowName) &&
            (identical(other.branch, branch) || other.branch == branch) &&
            (identical(other.on, on) || other.on == on));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, workflowName, branch, on);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowDomainImplCopyWith<_$WorkflowDomainImpl> get copyWith =>
      __$$WorkflowDomainImplCopyWithImpl<_$WorkflowDomainImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowDomainImplToJson(
      this,
    );
  }
}

abstract class _WorkflowDomain implements WorkflowDomain {
  const factory _WorkflowDomain(
      {required final String workflowName,
      required final String branch,
      required final OnPush on}) = _$WorkflowDomainImpl;

  factory _WorkflowDomain.fromJson(Map<String, dynamic> json) =
      _$WorkflowDomainImpl.fromJson;

  @override
  String get workflowName;
  @override
  String get branch;
  @override
  OnPush get on;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowDomainImplCopyWith<_$WorkflowDomainImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
