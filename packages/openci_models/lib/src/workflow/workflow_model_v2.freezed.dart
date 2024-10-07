// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_model_v2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkflowModelV2 _$WorkflowModelV2FromJson(Map<String, dynamic> json) {
  return _WorkflowModelV2.fromJson(json);
}

/// @nodoc
mixin _$WorkflowModelV2 {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<OpenCIStep> get steps => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowModelV2CopyWith<WorkflowModelV2> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowModelV2CopyWith<$Res> {
  factory $WorkflowModelV2CopyWith(
          WorkflowModelV2 value, $Res Function(WorkflowModelV2) then) =
      _$WorkflowModelV2CopyWithImpl<$Res, WorkflowModelV2>;
  @useResult
  $Res call({String id, String name, List<OpenCIStep> steps});
}

/// @nodoc
class _$WorkflowModelV2CopyWithImpl<$Res, $Val extends WorkflowModelV2>
    implements $WorkflowModelV2CopyWith<$Res> {
  _$WorkflowModelV2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? steps = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<OpenCIStep>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowModelV2ImplCopyWith<$Res>
    implements $WorkflowModelV2CopyWith<$Res> {
  factory _$$WorkflowModelV2ImplCopyWith(_$WorkflowModelV2Impl value,
          $Res Function(_$WorkflowModelV2Impl) then) =
      __$$WorkflowModelV2ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<OpenCIStep> steps});
}

/// @nodoc
class __$$WorkflowModelV2ImplCopyWithImpl<$Res>
    extends _$WorkflowModelV2CopyWithImpl<$Res, _$WorkflowModelV2Impl>
    implements _$$WorkflowModelV2ImplCopyWith<$Res> {
  __$$WorkflowModelV2ImplCopyWithImpl(
      _$WorkflowModelV2Impl _value, $Res Function(_$WorkflowModelV2Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? steps = null,
  }) {
    return _then(_$WorkflowModelV2Impl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<OpenCIStep>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowModelV2Impl implements _WorkflowModelV2 {
  const _$WorkflowModelV2Impl(
      {required this.id,
      required this.name,
      required final List<OpenCIStep> steps})
      : _steps = steps;

  factory _$WorkflowModelV2Impl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowModelV2ImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<OpenCIStep> _steps;
  @override
  List<OpenCIStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  String toString() {
    return 'WorkflowModelV2(id: $id, name: $name, steps: $steps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowModelV2Impl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._steps, _steps));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(_steps));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowModelV2ImplCopyWith<_$WorkflowModelV2Impl> get copyWith =>
      __$$WorkflowModelV2ImplCopyWithImpl<_$WorkflowModelV2Impl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowModelV2ImplToJson(
      this,
    );
  }
}

abstract class _WorkflowModelV2 implements WorkflowModelV2 {
  const factory _WorkflowModelV2(
      {required final String id,
      required final String name,
      required final List<OpenCIStep> steps}) = _$WorkflowModelV2Impl;

  factory _WorkflowModelV2.fromJson(Map<String, dynamic> json) =
      _$WorkflowModelV2Impl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<OpenCIStep> get steps;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowModelV2ImplCopyWith<_$WorkflowModelV2Impl> get copyWith =>
      throw _privateConstructorUsedError;
}
