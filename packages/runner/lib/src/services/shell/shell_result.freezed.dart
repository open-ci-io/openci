// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shell_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ShellResult {
  bool get result => throw _privateConstructorUsedError;
  SessionResult get sessionResult => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ShellResultCopyWith<ShellResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShellResultCopyWith<$Res> {
  factory $ShellResultCopyWith(
          ShellResult value, $Res Function(ShellResult) then) =
      _$ShellResultCopyWithImpl<$Res, ShellResult>;
  @useResult
  $Res call({bool result, SessionResult sessionResult});

  $SessionResultCopyWith<$Res> get sessionResult;
}

/// @nodoc
class _$ShellResultCopyWithImpl<$Res, $Val extends ShellResult>
    implements $ShellResultCopyWith<$Res> {
  _$ShellResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? sessionResult = null,
  }) {
    return _then(_value.copyWith(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionResult: null == sessionResult
          ? _value.sessionResult
          : sessionResult // ignore: cast_nullable_to_non_nullable
              as SessionResult,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SessionResultCopyWith<$Res> get sessionResult {
    return $SessionResultCopyWith<$Res>(_value.sessionResult, (value) {
      return _then(_value.copyWith(sessionResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShellResultImplCopyWith<$Res>
    implements $ShellResultCopyWith<$Res> {
  factory _$$ShellResultImplCopyWith(
          _$ShellResultImpl value, $Res Function(_$ShellResultImpl) then) =
      __$$ShellResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool result, SessionResult sessionResult});

  @override
  $SessionResultCopyWith<$Res> get sessionResult;
}

/// @nodoc
class __$$ShellResultImplCopyWithImpl<$Res>
    extends _$ShellResultCopyWithImpl<$Res, _$ShellResultImpl>
    implements _$$ShellResultImplCopyWith<$Res> {
  __$$ShellResultImplCopyWithImpl(
      _$ShellResultImpl _value, $Res Function(_$ShellResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? sessionResult = null,
  }) {
    return _then(_$ShellResultImpl(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionResult: null == sessionResult
          ? _value.sessionResult
          : sessionResult // ignore: cast_nullable_to_non_nullable
              as SessionResult,
    ));
  }
}

/// @nodoc

class _$ShellResultImpl implements _ShellResult {
  const _$ShellResultImpl({required this.result, required this.sessionResult});

  @override
  final bool result;
  @override
  final SessionResult sessionResult;

  @override
  String toString() {
    return 'ShellResult(result: $result, sessionResult: $sessionResult)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShellResultImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.sessionResult, sessionResult) ||
                other.sessionResult == sessionResult));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result, sessionResult);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShellResultImplCopyWith<_$ShellResultImpl> get copyWith =>
      __$$ShellResultImplCopyWithImpl<_$ShellResultImpl>(this, _$identity);
}

abstract class _ShellResult implements ShellResult {
  const factory _ShellResult(
      {required final bool result,
      required final SessionResult sessionResult}) = _$ShellResultImpl;

  @override
  bool get result;
  @override
  SessionResult get sessionResult;
  @override
  @JsonKey(ignore: true)
  _$$ShellResultImplCopyWith<_$ShellResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
