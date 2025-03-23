// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_step_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SelectStepDomain {
  String get title;
  String get base64;
  String get location;
  StepTemplate get template;
  String? get selectedKey;

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SelectStepDomainCopyWith<SelectStepDomain> get copyWith =>
      _$SelectStepDomainCopyWithImpl<SelectStepDomain>(
          this as SelectStepDomain, _$identity);

  /// Serializes this SelectStepDomain to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SelectStepDomain &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.base64, base64) || other.base64 == base64) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.template, template) ||
                other.template == template) &&
            (identical(other.selectedKey, selectedKey) ||
                other.selectedKey == selectedKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, base64, location, template, selectedKey);

  @override
  String toString() {
    return 'SelectStepDomain(title: $title, base64: $base64, location: $location, template: $template, selectedKey: $selectedKey)';
  }
}

/// @nodoc
abstract mixin class $SelectStepDomainCopyWith<$Res> {
  factory $SelectStepDomainCopyWith(
          SelectStepDomain value, $Res Function(SelectStepDomain) _then) =
      _$SelectStepDomainCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String base64,
      String location,
      StepTemplate template,
      String? selectedKey});
}

/// @nodoc
class _$SelectStepDomainCopyWithImpl<$Res>
    implements $SelectStepDomainCopyWith<$Res> {
  _$SelectStepDomainCopyWithImpl(this._self, this._then);

  final SelectStepDomain _self;
  final $Res Function(SelectStepDomain) _then;

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? base64 = null,
    Object? location = null,
    Object? template = null,
    Object? selectedKey = freezed,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      base64: null == base64
          ? _self.base64
          : base64 // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _self.template
          : template // ignore: cast_nullable_to_non_nullable
              as StepTemplate,
      selectedKey: freezed == selectedKey
          ? _self.selectedKey
          : selectedKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SelectStepDomain implements SelectStepDomain {
  const _SelectStepDomain(
      {this.title = 'Base64 to File',
      this.base64 = '',
      this.location = '',
      this.template = StepTemplate.blank,
      this.selectedKey});
  factory _SelectStepDomain.fromJson(Map<String, dynamic> json) =>
      _$SelectStepDomainFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String base64;
  @override
  @JsonKey()
  final String location;
  @override
  @JsonKey()
  final StepTemplate template;
  @override
  final String? selectedKey;

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SelectStepDomainCopyWith<_SelectStepDomain> get copyWith =>
      __$SelectStepDomainCopyWithImpl<_SelectStepDomain>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SelectStepDomainToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SelectStepDomain &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.base64, base64) || other.base64 == base64) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.template, template) ||
                other.template == template) &&
            (identical(other.selectedKey, selectedKey) ||
                other.selectedKey == selectedKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, base64, location, template, selectedKey);

  @override
  String toString() {
    return 'SelectStepDomain(title: $title, base64: $base64, location: $location, template: $template, selectedKey: $selectedKey)';
  }
}

/// @nodoc
abstract mixin class _$SelectStepDomainCopyWith<$Res>
    implements $SelectStepDomainCopyWith<$Res> {
  factory _$SelectStepDomainCopyWith(
          _SelectStepDomain value, $Res Function(_SelectStepDomain) _then) =
      __$SelectStepDomainCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      String base64,
      String location,
      StepTemplate template,
      String? selectedKey});
}

/// @nodoc
class __$SelectStepDomainCopyWithImpl<$Res>
    implements _$SelectStepDomainCopyWith<$Res> {
  __$SelectStepDomainCopyWithImpl(this._self, this._then);

  final _SelectStepDomain _self;
  final $Res Function(_SelectStepDomain) _then;

  /// Create a copy of SelectStepDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? base64 = null,
    Object? location = null,
    Object? template = null,
    Object? selectedKey = freezed,
  }) {
    return _then(_SelectStepDomain(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      base64: null == base64
          ? _self.base64
          : base64 // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      template: null == template
          ? _self.template
          : template // ignore: cast_nullable_to_non_nullable
              as StepTemplate,
      selectedKey: freezed == selectedKey
          ? _self.selectedKey
          : selectedKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
