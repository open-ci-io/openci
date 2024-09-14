// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActionModel _$ActionModelFromJson(Map<String, dynamic> json) {
  return _ActionModel.fromJson(json);
}

/// @nodoc
mixin _$ActionModel {
  /// Serializes this ActionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionModelCopyWith<$Res> {
  factory $ActionModelCopyWith(
          ActionModel value, $Res Function(ActionModel) then) =
      _$ActionModelCopyWithImpl<$Res, ActionModel>;
}

/// @nodoc
class _$ActionModelCopyWithImpl<$Res, $Val extends ActionModel>
    implements $ActionModelCopyWith<$Res> {
  _$ActionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionModel
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ActionModelImplCopyWith<$Res> {
  factory _$$ActionModelImplCopyWith(
          _$ActionModelImpl value, $Res Function(_$ActionModelImpl) then) =
      __$$ActionModelImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActionModelImplCopyWithImpl<$Res>
    extends _$ActionModelCopyWithImpl<$Res, _$ActionModelImpl>
    implements _$$ActionModelImplCopyWith<$Res> {
  __$$ActionModelImplCopyWithImpl(
      _$ActionModelImpl _value, $Res Function(_$ActionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActionModel
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$ActionModelImpl implements _ActionModel {
  const _$ActionModelImpl();

  factory _$ActionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionModelImplFromJson(json);

  @override
  String toString() {
    return 'ActionModel()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ActionModelImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionModelImplToJson(
      this,
    );
  }
}

abstract class _ActionModel implements ActionModel {
  const factory _ActionModel() = _$ActionModelImpl;

  factory _ActionModel.fromJson(Map<String, dynamic> json) =
      _$ActionModelImpl.fromJson;
}
