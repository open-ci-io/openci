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
  String get log => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

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
      {String command, String log, @DateTimeConverter() DateTime createdAt});
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
    Object? log = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      log: null == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      {String command, String log, @DateTimeConverter() DateTime createdAt});
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
    Object? log = null,
    Object? createdAt = null,
  }) {
    return _then(_$CommandLogImpl(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      log: null == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommandLogImpl implements _CommandLog {
  const _$CommandLogImpl(
      {required this.command,
      required this.log,
      @DateTimeConverter() required this.createdAt});

  factory _$CommandLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommandLogImplFromJson(json);

  @override
  final String command;
  @override
  final String log;
  @override
  @DateTimeConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'CommandLog(command: $command, log: $log, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommandLogImpl &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.log, log) || other.log == log) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, command, log, createdAt);

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
          required final String log,
          @DateTimeConverter() required final DateTime createdAt}) =
      _$CommandLogImpl;

  factory _CommandLog.fromJson(Map<String, dynamic> json) =
      _$CommandLogImpl.fromJson;

  @override
  String get command;
  @override
  String get log;
  @override
  @DateTimeConverter()
  DateTime get createdAt;

  /// Create a copy of CommandLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommandLogImplCopyWith<_$CommandLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
