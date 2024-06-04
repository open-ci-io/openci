// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) {
  return _OrganizationModel.fromJson(json);
}

/// @nodoc
mixin _$OrganizationModel {
  BuildNumber get buildNumber => throw _privateConstructorUsedError;
  String get documentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizationModelCopyWith<OrganizationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationModelCopyWith<$Res> {
  factory $OrganizationModelCopyWith(
          OrganizationModel value, $Res Function(OrganizationModel) then) =
      _$OrganizationModelCopyWithImpl<$Res, OrganizationModel>;
  @useResult
  $Res call({BuildNumber buildNumber, String documentId});

  $BuildNumberCopyWith<$Res> get buildNumber;
}

/// @nodoc
class _$OrganizationModelCopyWithImpl<$Res, $Val extends OrganizationModel>
    implements $OrganizationModelCopyWith<$Res> {
  _$OrganizationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildNumber = null,
    Object? documentId = null,
  }) {
    return _then(_value.copyWith(
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as BuildNumber,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BuildNumberCopyWith<$Res> get buildNumber {
    return $BuildNumberCopyWith<$Res>(_value.buildNumber, (value) {
      return _then(_value.copyWith(buildNumber: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizationModelImplCopyWith<$Res>
    implements $OrganizationModelCopyWith<$Res> {
  factory _$$OrganizationModelImplCopyWith(_$OrganizationModelImpl value,
          $Res Function(_$OrganizationModelImpl) then) =
      __$$OrganizationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BuildNumber buildNumber, String documentId});

  @override
  $BuildNumberCopyWith<$Res> get buildNumber;
}

/// @nodoc
class __$$OrganizationModelImplCopyWithImpl<$Res>
    extends _$OrganizationModelCopyWithImpl<$Res, _$OrganizationModelImpl>
    implements _$$OrganizationModelImplCopyWith<$Res> {
  __$$OrganizationModelImplCopyWithImpl(_$OrganizationModelImpl _value,
      $Res Function(_$OrganizationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buildNumber = null,
    Object? documentId = null,
  }) {
    return _then(_$OrganizationModelImpl(
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as BuildNumber,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationModelImpl implements _OrganizationModel {
  const _$OrganizationModelImpl(
      {required this.buildNumber, required this.documentId});

  factory _$OrganizationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationModelImplFromJson(json);

  @override
  final BuildNumber buildNumber;
  @override
  final String documentId;

  @override
  String toString() {
    return 'OrganizationModel(buildNumber: $buildNumber, documentId: $documentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationModelImpl &&
            (identical(other.buildNumber, buildNumber) ||
                other.buildNumber == buildNumber) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, buildNumber, documentId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      __$$OrganizationModelImplCopyWithImpl<_$OrganizationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationModelImplToJson(
      this,
    );
  }
}

abstract class _OrganizationModel implements OrganizationModel {
  const factory _OrganizationModel(
      {required final BuildNumber buildNumber,
      required final String documentId}) = _$OrganizationModelImpl;

  factory _OrganizationModel.fromJson(Map<String, dynamic> json) =
      _$OrganizationModelImpl.fromJson;

  @override
  BuildNumber get buildNumber;
  @override
  String get documentId;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuildNumber _$BuildNumberFromJson(Map<String, dynamic> json) {
  return _BuildNumber.fromJson(json);
}

/// @nodoc
mixin _$BuildNumber {
  int get android => throw _privateConstructorUsedError;
  int get ios => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BuildNumberCopyWith<BuildNumber> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuildNumberCopyWith<$Res> {
  factory $BuildNumberCopyWith(
          BuildNumber value, $Res Function(BuildNumber) then) =
      _$BuildNumberCopyWithImpl<$Res, BuildNumber>;
  @useResult
  $Res call({int android, int ios});
}

/// @nodoc
class _$BuildNumberCopyWithImpl<$Res, $Val extends BuildNumber>
    implements $BuildNumberCopyWith<$Res> {
  _$BuildNumberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? android = null,
    Object? ios = null,
  }) {
    return _then(_value.copyWith(
      android: null == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as int,
      ios: null == ios
          ? _value.ios
          : ios // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuildNumberImplCopyWith<$Res>
    implements $BuildNumberCopyWith<$Res> {
  factory _$$BuildNumberImplCopyWith(
          _$BuildNumberImpl value, $Res Function(_$BuildNumberImpl) then) =
      __$$BuildNumberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int android, int ios});
}

/// @nodoc
class __$$BuildNumberImplCopyWithImpl<$Res>
    extends _$BuildNumberCopyWithImpl<$Res, _$BuildNumberImpl>
    implements _$$BuildNumberImplCopyWith<$Res> {
  __$$BuildNumberImplCopyWithImpl(
      _$BuildNumberImpl _value, $Res Function(_$BuildNumberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? android = null,
    Object? ios = null,
  }) {
    return _then(_$BuildNumberImpl(
      android: null == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as int,
      ios: null == ios
          ? _value.ios
          : ios // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuildNumberImpl implements _BuildNumber {
  const _$BuildNumberImpl({required this.android, required this.ios});

  factory _$BuildNumberImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuildNumberImplFromJson(json);

  @override
  final int android;
  @override
  final int ios;

  @override
  String toString() {
    return 'BuildNumber(android: $android, ios: $ios)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuildNumberImpl &&
            (identical(other.android, android) || other.android == android) &&
            (identical(other.ios, ios) || other.ios == ios));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, android, ios);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuildNumberImplCopyWith<_$BuildNumberImpl> get copyWith =>
      __$$BuildNumberImplCopyWithImpl<_$BuildNumberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuildNumberImplToJson(
      this,
    );
  }
}

abstract class _BuildNumber implements BuildNumber {
  const factory _BuildNumber(
      {required final int android, required final int ios}) = _$BuildNumberImpl;

  factory _BuildNumber.fromJson(Map<String, dynamic> json) =
      _$BuildNumberImpl.fromJson;

  @override
  int get android;
  @override
  int get ios;
  @override
  @JsonKey(ignore: true)
  _$$BuildNumberImplCopyWith<_$BuildNumberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
