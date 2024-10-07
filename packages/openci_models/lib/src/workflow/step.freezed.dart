// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OpenCIStep _$OpenCIStepFromJson(Map<String, dynamic> json) {
  return _OpenCIStep.fromJson(json);
}

/// @nodoc
mixin _$OpenCIStep {
  String get name => throw _privateConstructorUsedError;
  List<String> get commands => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OpenCIStepCopyWith<OpenCIStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenCIStepCopyWith<$Res> {
  factory $OpenCIStepCopyWith(
          OpenCIStep value, $Res Function(OpenCIStep) then) =
      _$OpenCIStepCopyWithImpl<$Res, OpenCIStep>;
  @useResult
  $Res call({String name, List<String> commands});
}

/// @nodoc
class _$OpenCIStepCopyWithImpl<$Res, $Val extends OpenCIStep>
    implements $OpenCIStepCopyWith<$Res> {
  _$OpenCIStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? commands = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      commands: null == commands
          ? _value.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenCIStepImplCopyWith<$Res>
    implements $OpenCIStepCopyWith<$Res> {
  factory _$$OpenCIStepImplCopyWith(
          _$OpenCIStepImpl value, $Res Function(_$OpenCIStepImpl) then) =
      __$$OpenCIStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<String> commands});
}

/// @nodoc
class __$$OpenCIStepImplCopyWithImpl<$Res>
    extends _$OpenCIStepCopyWithImpl<$Res, _$OpenCIStepImpl>
    implements _$$OpenCIStepImplCopyWith<$Res> {
  __$$OpenCIStepImplCopyWithImpl(
      _$OpenCIStepImpl _value, $Res Function(_$OpenCIStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? commands = null,
  }) {
    return _then(_$OpenCIStepImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      commands: null == commands
          ? _value._commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenCIStepImpl implements _OpenCIStep {
  const _$OpenCIStepImpl(
      {required this.name, required final List<String> commands})
      : _commands = commands;

  factory _$OpenCIStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenCIStepImplFromJson(json);

  @override
  final String name;
  final List<String> _commands;
  @override
  List<String> get commands {
    if (_commands is EqualUnmodifiableListView) return _commands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commands);
  }

  @override
  String toString() {
    return 'OpenCIStep(name: $name, commands: $commands)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenCIStepImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._commands, _commands));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_commands));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenCIStepImplCopyWith<_$OpenCIStepImpl> get copyWith =>
      __$$OpenCIStepImplCopyWithImpl<_$OpenCIStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenCIStepImplToJson(
      this,
    );
  }
}

abstract class _OpenCIStep implements OpenCIStep {
  const factory _OpenCIStep(
      {required final String name,
      required final List<String> commands}) = _$OpenCIStepImpl;

  factory _OpenCIStep.fromJson(Map<String, dynamic> json) =
      _$OpenCIStepImpl.fromJson;

  @override
  String get name;
  @override
  List<String> get commands;
  @override
  @JsonKey(ignore: true)
  _$$OpenCIStepImplCopyWith<_$OpenCIStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
