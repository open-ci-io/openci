// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommandLog _$CommandLogFromJson(Map<String, dynamic> json) {
  return _CommandLog.fromJson(json);
}

/// @nodoc
mixin _$CommandLog {
  String get command => throw _privateConstructorUsedError;
  String get logStdout => throw _privateConstructorUsedError;
  String get logStderr => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get exitCode => throw _privateConstructorUsedError;

  /// Serializes this CommandLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommandLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommandLogCopyWith<CommandLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommandLogCopyWith<$Res> {
  factory $CommandLogCopyWith(
          CommandLog value, $Res Function(CommandLog) then) =
      _$CommandLogCopyWithImpl<$Res, CommandLog>;
  @useResult
  $Res call(
      {String command,
      String logStdout,
      String logStderr,
      @DateTimeConverter() DateTime createdAt,
      int exitCode});
}

/// @nodoc
class _$CommandLogCopyWithImpl<$Res, $Val extends CommandLog>
    implements $CommandLogCopyWith<$Res> {
  _$CommandLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommandLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
    Object? logStdout = null,
    Object? logStderr = null,
    Object? createdAt = null,
    Object? exitCode = null,
  }) {
    return _then(_value.copyWith(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      logStdout: null == logStdout
          ? _value.logStdout
          : logStdout // ignore: cast_nullable_to_non_nullable
              as String,
      logStderr: null == logStderr
          ? _value.logStderr
          : logStderr // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exitCode: null == exitCode
          ? _value.exitCode
          : exitCode // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommandLogImplCopyWith<$Res>
    implements $CommandLogCopyWith<$Res> {
  factory _$$CommandLogImplCopyWith(
          _$CommandLogImpl value, $Res Function(_$CommandLogImpl) then) =
      __$$CommandLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String command,
      String logStdout,
      String logStderr,
      @DateTimeConverter() DateTime createdAt,
      int exitCode});
}

/// @nodoc
class __$$CommandLogImplCopyWithImpl<$Res>
    extends _$CommandLogCopyWithImpl<$Res, _$CommandLogImpl>
    implements _$$CommandLogImplCopyWith<$Res> {
  __$$CommandLogImplCopyWithImpl(
      _$CommandLogImpl _value, $Res Function(_$CommandLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommandLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
    Object? logStdout = null,
    Object? logStderr = null,
    Object? createdAt = null,
    Object? exitCode = null,
  }) {
    return _then(_$CommandLogImpl(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      logStdout: null == logStdout
          ? _value.logStdout
          : logStdout // ignore: cast_nullable_to_non_nullable
              as String,
      logStderr: null == logStderr
          ? _value.logStderr
          : logStderr // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      exitCode: null == exitCode
          ? _value.exitCode
          : exitCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommandLogImpl implements _CommandLog {
  const _$CommandLogImpl(
      {required this.command,
      required this.logStdout,
      required this.logStderr,
      @DateTimeConverter() required this.createdAt,
      required this.exitCode});

  factory _$CommandLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommandLogImplFromJson(json);

  @override
  final String command;
  @override
  final String logStdout;
  @override
  final String logStderr;
  @override
  @DateTimeConverter()
  final DateTime createdAt;
  @override
  final int exitCode;

  @override
  String toString() {
    return 'CommandLog(command: $command, logStdout: $logStdout, logStderr: $logStderr, createdAt: $createdAt, exitCode: $exitCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommandLogImpl &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.logStdout, logStdout) ||
                other.logStdout == logStdout) &&
            (identical(other.logStderr, logStderr) ||
                other.logStderr == logStderr) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.exitCode, exitCode) ||
                other.exitCode == exitCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, command, logStdout, logStderr, createdAt, exitCode);

  /// Create a copy of CommandLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommandLogImplCopyWith<_$CommandLogImpl> get copyWith =>
      __$$CommandLogImplCopyWithImpl<_$CommandLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommandLogImplToJson(
      this,
    );
  }
}

abstract class _CommandLog implements CommandLog {
  const factory _CommandLog(
      {required final String command,
      required final String logStdout,
      required final String logStderr,
      @DateTimeConverter() required final DateTime createdAt,
      required final int exitCode}) = _$CommandLogImpl;

  factory _CommandLog.fromJson(Map<String, dynamic> json) =
      _$CommandLogImpl.fromJson;

  @override
  String get command;
  @override
  String get logStdout;
  @override
  String get logStderr;
  @override
  @DateTimeConverter()
  DateTime get createdAt;
  @override
  int get exitCode;

  /// Create a copy of CommandLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommandLogImplCopyWith<_$CommandLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
