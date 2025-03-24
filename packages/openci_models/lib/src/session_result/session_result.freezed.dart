// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionResult {
  String get stdout;
  String get stderr;
  int get exitCode;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionResultCopyWith<SessionResult> get copyWith =>
      _$SessionResultCopyWithImpl<SessionResult>(
          this as SessionResult, _$identity);

  /// Serializes this SessionResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionResult &&
            (identical(other.stdout, stdout) || other.stdout == stdout) &&
            (identical(other.stderr, stderr) || other.stderr == stderr) &&
            (identical(other.exitCode, exitCode) ||
                other.exitCode == exitCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, stdout, stderr, exitCode);

  @override
  String toString() {
    return 'SessionResult(stdout: $stdout, stderr: $stderr, exitCode: $exitCode)';
  }
}

/// @nodoc
abstract mixin class $SessionResultCopyWith<$Res> {
  factory $SessionResultCopyWith(
          SessionResult value, $Res Function(SessionResult) _then) =
      _$SessionResultCopyWithImpl;
  @useResult
  $Res call({String stdout, String stderr, int exitCode});
}

/// @nodoc
class _$SessionResultCopyWithImpl<$Res>
    implements $SessionResultCopyWith<$Res> {
  _$SessionResultCopyWithImpl(this._self, this._then);

  final SessionResult _self;
  final $Res Function(SessionResult) _then;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stdout = null,
    Object? stderr = null,
    Object? exitCode = null,
  }) {
    return _then(_self.copyWith(
      stdout: null == stdout
          ? _self.stdout
          : stdout // ignore: cast_nullable_to_non_nullable
              as String,
      stderr: null == stderr
          ? _self.stderr
          : stderr // ignore: cast_nullable_to_non_nullable
              as String,
      exitCode: null == exitCode
          ? _self.exitCode
          : exitCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SessionResult implements SessionResult {
  const _SessionResult(
      {required this.stdout, required this.stderr, required this.exitCode});
  factory _SessionResult.fromJson(Map<String, dynamic> json) =>
      _$SessionResultFromJson(json);

  @override
  final String stdout;
  @override
  final String stderr;
  @override
  final int exitCode;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionResultCopyWith<_SessionResult> get copyWith =>
      __$SessionResultCopyWithImpl<_SessionResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionResult &&
            (identical(other.stdout, stdout) || other.stdout == stdout) &&
            (identical(other.stderr, stderr) || other.stderr == stderr) &&
            (identical(other.exitCode, exitCode) ||
                other.exitCode == exitCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, stdout, stderr, exitCode);

  @override
  String toString() {
    return 'SessionResult(stdout: $stdout, stderr: $stderr, exitCode: $exitCode)';
  }
}

/// @nodoc
abstract mixin class _$SessionResultCopyWith<$Res>
    implements $SessionResultCopyWith<$Res> {
  factory _$SessionResultCopyWith(
          _SessionResult value, $Res Function(_SessionResult) _then) =
      __$SessionResultCopyWithImpl;
  @override
  @useResult
  $Res call({String stdout, String stderr, int exitCode});
}

/// @nodoc
class __$SessionResultCopyWithImpl<$Res>
    implements _$SessionResultCopyWith<$Res> {
  __$SessionResultCopyWithImpl(this._self, this._then);

  final _SessionResult _self;
  final $Res Function(_SessionResult) _then;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stdout = null,
    Object? stderr = null,
    Object? exitCode = null,
  }) {
    return _then(_SessionResult(
      stdout: null == stdout
          ? _self.stdout
          : stdout // ignore: cast_nullable_to_non_nullable
              as String,
      stderr: null == stderr
          ? _self.stderr
          : stderr // ignore: cast_nullable_to_non_nullable
              as String,
      exitCode: null == exitCode
          ? _self.exitCode
          : exitCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
