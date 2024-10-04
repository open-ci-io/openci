// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionResult _$SessionResultFromJson(Map<String, dynamic> json) {
  return _SessionResult.fromJson(json);
}

/// @nodoc
mixin _$SessionResult {
  String get sessionStdout => throw _privateConstructorUsedError;
  String get sessionStderr => throw _privateConstructorUsedError;
  int? get sessionExitCode => throw _privateConstructorUsedError;

  /// Serializes this SessionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionResultCopyWith<SessionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionResultCopyWith<$Res> {
  factory $SessionResultCopyWith(
          SessionResult value, $Res Function(SessionResult) then) =
      _$SessionResultCopyWithImpl<$Res, SessionResult>;
  @useResult
  $Res call({String sessionStdout, String sessionStderr, int? sessionExitCode});
}

/// @nodoc
class _$SessionResultCopyWithImpl<$Res, $Val extends SessionResult>
    implements $SessionResultCopyWith<$Res> {
  _$SessionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionStdout = null,
    Object? sessionStderr = null,
    Object? sessionExitCode = freezed,
  }) {
    return _then(_value.copyWith(
      sessionStdout: null == sessionStdout
          ? _value.sessionStdout
          : sessionStdout // ignore: cast_nullable_to_non_nullable
              as String,
      sessionStderr: null == sessionStderr
          ? _value.sessionStderr
          : sessionStderr // ignore: cast_nullable_to_non_nullable
              as String,
      sessionExitCode: freezed == sessionExitCode
          ? _value.sessionExitCode
          : sessionExitCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionResultImplCopyWith<$Res>
    implements $SessionResultCopyWith<$Res> {
  factory _$$SessionResultImplCopyWith(
          _$SessionResultImpl value, $Res Function(_$SessionResultImpl) then) =
      __$$SessionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sessionStdout, String sessionStderr, int? sessionExitCode});
}

/// @nodoc
class __$$SessionResultImplCopyWithImpl<$Res>
    extends _$SessionResultCopyWithImpl<$Res, _$SessionResultImpl>
    implements _$$SessionResultImplCopyWith<$Res> {
  __$$SessionResultImplCopyWithImpl(
      _$SessionResultImpl _value, $Res Function(_$SessionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionStdout = null,
    Object? sessionStderr = null,
    Object? sessionExitCode = freezed,
  }) {
    return _then(_$SessionResultImpl(
      sessionStdout: null == sessionStdout
          ? _value.sessionStdout
          : sessionStdout // ignore: cast_nullable_to_non_nullable
              as String,
      sessionStderr: null == sessionStderr
          ? _value.sessionStderr
          : sessionStderr // ignore: cast_nullable_to_non_nullable
              as String,
      sessionExitCode: freezed == sessionExitCode
          ? _value.sessionExitCode
          : sessionExitCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionResultImpl implements _SessionResult {
  const _$SessionResultImpl(
      {this.sessionStdout = '', this.sessionStderr = '', this.sessionExitCode});

  factory _$SessionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionResultImplFromJson(json);

  @override
  @JsonKey()
  final String sessionStdout;
  @override
  @JsonKey()
  final String sessionStderr;
  @override
  final int? sessionExitCode;

  @override
  String toString() {
    return 'SessionResult(sessionStdout: $sessionStdout, sessionStderr: $sessionStderr, sessionExitCode: $sessionExitCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionResultImpl &&
            (identical(other.sessionStdout, sessionStdout) ||
                other.sessionStdout == sessionStdout) &&
            (identical(other.sessionStderr, sessionStderr) ||
                other.sessionStderr == sessionStderr) &&
            (identical(other.sessionExitCode, sessionExitCode) ||
                other.sessionExitCode == sessionExitCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sessionStdout, sessionStderr, sessionExitCode);

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionResultImplCopyWith<_$SessionResultImpl> get copyWith =>
      __$$SessionResultImplCopyWithImpl<_$SessionResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionResultImplToJson(
      this,
    );
  }
}

abstract class _SessionResult implements SessionResult {
  const factory _SessionResult(
      {final String sessionStdout,
      final String sessionStderr,
      final int? sessionExitCode}) = _$SessionResultImpl;

  factory _SessionResult.fromJson(Map<String, dynamic> json) =
      _$SessionResultImpl.fromJson;

  @override
  String get sessionStdout;
  @override
  String get sessionStderr;
  @override
  int? get sessionExitCode;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionResultImplCopyWith<_$SessionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
