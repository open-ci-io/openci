// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'runner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Runner {
  String get key => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RunnerCopyWith<Runner> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RunnerCopyWith<$Res> {
  factory $RunnerCopyWith(Runner value, $Res Function(Runner) then) =
      _$RunnerCopyWithImpl<$Res, Runner>;
  @useResult
  $Res call({String key, String error});
}

/// @nodoc
class _$RunnerCopyWithImpl<$Res, $Val extends Runner>
    implements $RunnerCopyWith<$Res> {
  _$RunnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RunnerImplCopyWith<$Res> implements $RunnerCopyWith<$Res> {
  factory _$$RunnerImplCopyWith(
          _$RunnerImpl value, $Res Function(_$RunnerImpl) then) =
      __$$RunnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String error});
}

/// @nodoc
class __$$RunnerImplCopyWithImpl<$Res>
    extends _$RunnerCopyWithImpl<$Res, _$RunnerImpl>
    implements _$$RunnerImplCopyWith<$Res> {
  __$$RunnerImplCopyWithImpl(
      _$RunnerImpl _value, $Res Function(_$RunnerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? error = null,
  }) {
    return _then(_$RunnerImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RunnerImpl implements _Runner {
  const _$RunnerImpl({required this.key, required this.error});

  @override
  final String key;
  @override
  final String error;

  @override
  String toString() {
    return 'Runner(key: $key, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RunnerImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RunnerImplCopyWith<_$RunnerImpl> get copyWith =>
      __$$RunnerImplCopyWithImpl<_$RunnerImpl>(this, _$identity);
}

abstract class _Runner implements Runner {
  const factory _Runner(
      {required final String key, required final String error}) = _$RunnerImpl;

  @override
  String get key;
  @override
  String get error;
  @override
  @JsonKey(ignore: true)
  _$$RunnerImplCopyWith<_$RunnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
