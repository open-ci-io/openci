// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'env_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnvModel {
  String get firebaseServiceAccountBase64;
  String get firebaseProjectName;
  String get pemBase64;
  String get githubAppId;

  /// Create a copy of EnvModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvModelCopyWith<EnvModel> get copyWith =>
      _$EnvModelCopyWithImpl<EnvModel>(this as EnvModel, _$identity);

  /// Serializes this EnvModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvModel &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firebaseServiceAccountBase64,
      firebaseProjectName, pemBase64, githubAppId);

  @override
  String toString() {
    return 'EnvModel(firebaseServiceAccountBase64: $firebaseServiceAccountBase64, firebaseProjectName: $firebaseProjectName, pemBase64: $pemBase64, githubAppId: $githubAppId)';
  }
}

/// @nodoc
abstract mixin class $EnvModelCopyWith<$Res> {
  factory $EnvModelCopyWith(EnvModel value, $Res Function(EnvModel) _then) =
      _$EnvModelCopyWithImpl;
  @useResult
  $Res call(
      {String firebaseServiceAccountBase64,
      String firebaseProjectName,
      String pemBase64,
      String githubAppId});
}

/// @nodoc
class _$EnvModelCopyWithImpl<$Res> implements $EnvModelCopyWith<$Res> {
  _$EnvModelCopyWithImpl(this._self, this._then);

  final EnvModel _self;
  final $Res Function(EnvModel) _then;

  /// Create a copy of EnvModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebaseServiceAccountBase64 = null,
    Object? firebaseProjectName = null,
    Object? pemBase64 = null,
    Object? githubAppId = null,
  }) {
    return _then(_self.copyWith(
      firebaseServiceAccountBase64: null == firebaseServiceAccountBase64
          ? _self.firebaseServiceAccountBase64
          : firebaseServiceAccountBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      firebaseProjectName: null == firebaseProjectName
          ? _self.firebaseProjectName
          : firebaseProjectName // ignore: cast_nullable_to_non_nullable
              as String,
      pemBase64: null == pemBase64
          ? _self.pemBase64
          : pemBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      githubAppId: null == githubAppId
          ? _self.githubAppId
          : githubAppId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EnvModel implements EnvModel {
  const _EnvModel(
      {required this.firebaseServiceAccountBase64,
      required this.firebaseProjectName,
      required this.pemBase64,
      required this.githubAppId});
  factory _EnvModel.fromJson(Map<String, dynamic> json) =>
      _$EnvModelFromJson(json);

  @override
  final String firebaseServiceAccountBase64;
  @override
  final String firebaseProjectName;
  @override
  final String pemBase64;
  @override
  final String githubAppId;

  /// Create a copy of EnvModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvModelCopyWith<_EnvModel> get copyWith =>
      __$EnvModelCopyWithImpl<_EnvModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EnvModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvModel &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firebaseServiceAccountBase64,
      firebaseProjectName, pemBase64, githubAppId);

  @override
  String toString() {
    return 'EnvModel(firebaseServiceAccountBase64: $firebaseServiceAccountBase64, firebaseProjectName: $firebaseProjectName, pemBase64: $pemBase64, githubAppId: $githubAppId)';
  }
}

/// @nodoc
abstract mixin class _$EnvModelCopyWith<$Res>
    implements $EnvModelCopyWith<$Res> {
  factory _$EnvModelCopyWith(_EnvModel value, $Res Function(_EnvModel) _then) =
      __$EnvModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String firebaseServiceAccountBase64,
      String firebaseProjectName,
      String pemBase64,
      String githubAppId});
}

/// @nodoc
class __$EnvModelCopyWithImpl<$Res> implements _$EnvModelCopyWith<$Res> {
  __$EnvModelCopyWithImpl(this._self, this._then);

  final _EnvModel _self;
  final $Res Function(_EnvModel) _then;

  /// Create a copy of EnvModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? firebaseServiceAccountBase64 = null,
    Object? firebaseProjectName = null,
    Object? pemBase64 = null,
    Object? githubAppId = null,
  }) {
    return _then(_EnvModel(
      firebaseServiceAccountBase64: null == firebaseServiceAccountBase64
          ? _self.firebaseServiceAccountBase64
          : firebaseServiceAccountBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      firebaseProjectName: null == firebaseProjectName
          ? _self.firebaseProjectName
          : firebaseProjectName // ignore: cast_nullable_to_non_nullable
              as String,
      pemBase64: null == pemBase64
          ? _self.pemBase64
          : pemBase64 // ignore: cast_nullable_to_non_nullable
              as String,
      githubAppId: null == githubAppId
          ? _self.githubAppId
          : githubAppId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
