// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_step_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SelectStepDomain _$SelectStepDomainFromJson(Map<String, dynamic> json) {
  return _SelectStepDomain.fromJson(json);
}

/// @nodoc
mixin _$SelectStepDomain {
  String get title => throw _privateConstructorUsedError;
  String get base64 => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  StepTemplate get template => throw _privateConstructorUsedError;

  /// Serializes this SelectStepDomain to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectStepDomainCopyWith<SelectStepDomain> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectStepDomainCopyWith<$Res> {
  factory $SelectStepDomainCopyWith(
          SelectStepDomain value, $Res Function(SelectStepDomain) then) =
      _$SelectStepDomainCopyWithImpl<$Res, SelectStepDomain>;
  @useResult
  $Res call(
      {String title, String base64, String location, StepTemplate template});
}

/// @nodoc
class _$SelectStepDomainCopyWithImpl<$Res, $Val extends SelectStepDomain>
    implements $SelectStepDomainCopyWith<$Res> {
  _$SelectStepDomainCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? base64 = null,
    Object? location = null,
    Object? template = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      base64: null == base64
          ? _value.base64
          : base64 // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as StepTemplate,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectStepDomainImplCopyWith<$Res>
    implements $SelectStepDomainCopyWith<$Res> {
  factory _$$SelectStepDomainImplCopyWith(_$SelectStepDomainImpl value,
          $Res Function(_$SelectStepDomainImpl) then) =
      __$$SelectStepDomainImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title, String base64, String location, StepTemplate template});
}

/// @nodoc
class __$$SelectStepDomainImplCopyWithImpl<$Res>
    extends _$SelectStepDomainCopyWithImpl<$Res, _$SelectStepDomainImpl>
    implements _$$SelectStepDomainImplCopyWith<$Res> {
  __$$SelectStepDomainImplCopyWithImpl(_$SelectStepDomainImpl _value,
      $Res Function(_$SelectStepDomainImpl) _then)
      : super(_value, _then);

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? base64 = null,
    Object? location = null,
    Object? template = null,
  }) {
    return _then(_$SelectStepDomainImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      base64: null == base64
          ? _value.base64
          : base64 // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as StepTemplate,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectStepDomainImpl implements _SelectStepDomain {
  const _$SelectStepDomainImpl(
      {this.title = 'Base64 to File',
      this.base64 = '',
      required this.location,
      this.template = StepTemplate.blank});

  factory _$SelectStepDomainImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectStepDomainImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String base64;
  @override
  final String location;
  @override
  @JsonKey()
  final StepTemplate template;

  @override
  String toString() {
    return 'SelectStepDomain(title: $title, base64: $base64, location: $location, template: $template)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectStepDomainImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.base64, base64) || other.base64 == base64) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.template, template) ||
                other.template == template));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, base64, location, template);

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectStepDomainImplCopyWith<_$SelectStepDomainImpl> get copyWith =>
      __$$SelectStepDomainImplCopyWithImpl<_$SelectStepDomainImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectStepDomainImplToJson(
      this,
    );
  }
}

abstract class _SelectStepDomain implements SelectStepDomain {
  const factory _SelectStepDomain(
      {final String title,
      final String base64,
      required final String location,
      final StepTemplate template}) = _$SelectStepDomainImpl;

  factory _SelectStepDomain.fromJson(Map<String, dynamic> json) =
      _$SelectStepDomainImpl.fromJson;

  @override
  String get title;
  @override
  String get base64;
  @override
  String get location;
  @override
  StepTemplate get template;

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectStepDomainImplCopyWith<_$SelectStepDomainImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
