// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'build_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BuildJob _$BuildJobFromJson(Map<String, dynamic> json) {
  return _BuildJob.fromJson(json);
}

/// @nodoc
mixin _$BuildJob {
  int get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  JobStatus get statusV2 => throw _privateConstructorUsedError;

  /// Serializes this BuildJob to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BuildJobCopyWith<BuildJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuildJobCopyWith<$Res> {
  factory $BuildJobCopyWith(BuildJob value, $Res Function(BuildJob) then) =
      _$BuildJobCopyWithImpl<$Res, BuildJob>;
  @useResult
  $Res call({int id, DateTime createdAt, JobStatus statusV2});
}

/// @nodoc
class _$BuildJobCopyWithImpl<$Res, $Val extends BuildJob>
    implements $BuildJobCopyWith<$Res> {
  _$BuildJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? statusV2 = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statusV2: null == statusV2
          ? _value.statusV2
          : statusV2 // ignore: cast_nullable_to_non_nullable
              as JobStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuildJobImplCopyWith<$Res>
    implements $BuildJobCopyWith<$Res> {
  factory _$$BuildJobImplCopyWith(
          _$BuildJobImpl value, $Res Function(_$BuildJobImpl) then) =
      __$$BuildJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, DateTime createdAt, JobStatus statusV2});
}

/// @nodoc
class __$$BuildJobImplCopyWithImpl<$Res>
    extends _$BuildJobCopyWithImpl<$Res, _$BuildJobImpl>
    implements _$$BuildJobImplCopyWith<$Res> {
  __$$BuildJobImplCopyWithImpl(
      _$BuildJobImpl _value, $Res Function(_$BuildJobImpl) _then)
      : super(_value, _then);

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? statusV2 = null,
  }) {
    return _then(_$BuildJobImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statusV2: null == statusV2
          ? _value.statusV2
          : statusV2 // ignore: cast_nullable_to_non_nullable
              as JobStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuildJobImpl implements _BuildJob {
  const _$BuildJobImpl(
      {required this.id, required this.createdAt, required this.statusV2});

  factory _$BuildJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuildJobImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime createdAt;
  @override
  final JobStatus statusV2;

  @override
  String toString() {
    return 'BuildJob(id: $id, createdAt: $createdAt, statusV2: $statusV2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuildJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.statusV2, statusV2) ||
                other.statusV2 == statusV2));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, statusV2);

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BuildJobImplCopyWith<_$BuildJobImpl> get copyWith =>
      __$$BuildJobImplCopyWithImpl<_$BuildJobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuildJobImplToJson(
      this,
    );
  }
}

abstract class _BuildJob implements BuildJob {
  const factory _BuildJob(
      {required final int id,
      required final DateTime createdAt,
      required final JobStatus statusV2}) = _$BuildJobImpl;

  factory _BuildJob.fromJson(Map<String, dynamic> json) =
      _$BuildJobImpl.fromJson;

  @override
  int get id;
  @override
  DateTime get createdAt;
  @override
  JobStatus get statusV2;

  /// Create a copy of BuildJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BuildJobImplCopyWith<_$BuildJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
