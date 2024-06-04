// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'env_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EnvModel _$EnvModelFromJson(Map<String, dynamic> json) {
  return _EnvModel.fromJson(json);
}

/// @nodoc
mixin _$EnvModel {
  String get firebaseServiceAccountBase64 => throw _privateConstructorUsedError;
  String get firebaseProjectName => throw _privateConstructorUsedError;
  String get pemBase64 => throw _privateConstructorUsedError;
  String get githubAppId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EnvModelCopyWith<EnvModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvModelCopyWith<$Res> {
  factory $EnvModelCopyWith(EnvModel value, $Res Function(EnvModel) then) =
      _$EnvModelCopyWithImpl<$Res, EnvModel>;
  @useResult
  $Res call(
      {String firebaseServiceAccountBase64,
      String firebaseProjectName,
      String pemBase64,
      String githubAppId});
}

/// @nodoc
class _$EnvModelCopyWithImpl<$Res, $Val extends EnvModel>
    implements $EnvModelCopyWith<$Res> {
  _$EnvModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebaseServiceAccountBase64 = null,
    Object? firebaseProjectName = null,
    Object? pemBase64 = null,
    Object? githubAppId = null,
  }) {
    return _then(_value.copyWith(
      firebaseServiceAccountBase64: null == firebaseServiceAccountBase64
          ? _value.firebaseServiceAccountBase64
          : firebaseServiceAccountBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      firebaseProjectName: null == firebaseProjectName
          ? _value.firebaseProjectName
          : firebaseProjectName // ignore: cast_nullable_to_non_nullable
              as String,
      pemBase64: null == pemBase64
          ? _value.pemBase64
          : pemBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      githubAppId: null == githubAppId
          ? _value.githubAppId
          : githubAppId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EnvModelImplCopyWith<$Res>
    implements $EnvModelCopyWith<$Res> {
  factory _$$EnvModelImplCopyWith(
          _$EnvModelImpl value, $Res Function(_$EnvModelImpl) then) =
      __$$EnvModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firebaseServiceAccountBase64,
      String firebaseProjectName,
      String pemBase64,
      String githubAppId});
}

/// @nodoc
class __$$EnvModelImplCopyWithImpl<$Res>
    extends _$EnvModelCopyWithImpl<$Res, _$EnvModelImpl>
    implements _$$EnvModelImplCopyWith<$Res> {
  __$$EnvModelImplCopyWithImpl(
      _$EnvModelImpl _value, $Res Function(_$EnvModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebaseServiceAccountBase64 = null,
    Object? firebaseProjectName = null,
    Object? pemBase64 = null,
    Object? githubAppId = null,
  }) {
    return _then(_$EnvModelImpl(
      firebaseServiceAccountBase64: null == firebaseServiceAccountBase64
          ? _value.firebaseServiceAccountBase64
          : firebaseServiceAccountBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      firebaseProjectName: null == firebaseProjectName
          ? _value.firebaseProjectName
          : firebaseProjectName // ignore: cast_nullable_to_non_nullable
              as String,
      pemBase64: null == pemBase64
          ? _value.pemBase64
          : pemBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      githubAppId: null == githubAppId
          ? _value.githubAppId
          : githubAppId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EnvModelImpl implements _EnvModel {
  const _$EnvModelImpl(
      {required this.firebaseServiceAccountBase64,
      required this.firebaseProjectName,
      required this.pemBase64,
      required this.githubAppId});

  factory _$EnvModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnvModelImplFromJson(json);

  @override
  final String firebaseServiceAccountBase64;
  @override
  final String firebaseProjectName;
  @override
  final String pemBase64;
  @override
  final String githubAppId;

  @override
  String toString() {
    return 'EnvModel(firebaseServiceAccountBase64: $firebaseServiceAccountBase64, firebaseProjectName: $firebaseProjectName, pemBase64: $pemBase64, githubAppId: $githubAppId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnvModelImpl &&
            (identical(other.firebaseServiceAccountBase64,
                    firebaseServiceAccountBase64) ||
                other.firebaseServiceAccountBase64 ==
                    firebaseServiceAccountBase64) &&
            (identical(other.firebaseProjectName, firebaseProjectName) ||
                other.firebaseProjectName == firebaseProjectName) &&
            (identical(other.pemBase64, pemBase64) ||
                other.pemBase64 == pemBase64) &&
            (identical(other.githubAppId, githubAppId) ||
                other.githubAppId == githubAppId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firebaseServiceAccountBase64,
      firebaseProjectName, pemBase64, githubAppId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EnvModelImplCopyWith<_$EnvModelImpl> get copyWith =>
      __$$EnvModelImplCopyWithImpl<_$EnvModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnvModelImplToJson(
      this,
    );
  }
}

abstract class _EnvModel implements EnvModel {
  const factory _EnvModel(
      {required final String firebaseServiceAccountBase64,
      required final String firebaseProjectName,
      required final String pemBase64,
      required final String githubAppId}) = _$EnvModelImpl;

  factory _EnvModel.fromJson(Map<String, dynamic> json) =
      _$EnvModelImpl.fromJson;

  @override
  String get firebaseServiceAccountBase64;
  @override
  String get firebaseProjectName;
  @override
  String get pemBase64;
  @override
  String get githubAppId;
  @override
  @JsonKey(ignore: true)
  _$$EnvModelImplCopyWith<_$EnvModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
