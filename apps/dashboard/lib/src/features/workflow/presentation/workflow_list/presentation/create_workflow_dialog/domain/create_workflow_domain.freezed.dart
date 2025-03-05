// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_workflow_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateWorkflowDomain _$CreateWorkflowDomainFromJson(Map<String, dynamic> json) {
  return _CreateWorkflowDomain.fromJson(json);
}

/// @nodoc
mixin _$CreateWorkflowDomain {
  OpenCIWorkflowTemplate get template => throw _privateConstructorUsedError;

  /// Serializes this CreateWorkflowDomain to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateWorkflowDomainCopyWith<CreateWorkflowDomain> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateWorkflowDomainCopyWith<$Res> {
  factory $CreateWorkflowDomainCopyWith(CreateWorkflowDomain value,
          $Res Function(CreateWorkflowDomain) then) =
      _$CreateWorkflowDomainCopyWithImpl<$Res, CreateWorkflowDomain>;
  @useResult
  $Res call({OpenCIWorkflowTemplate template});
}

/// @nodoc
class _$CreateWorkflowDomainCopyWithImpl<$Res,
        $Val extends CreateWorkflowDomain>
    implements $CreateWorkflowDomainCopyWith<$Res> {
  _$CreateWorkflowDomainCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? template = null,
  }) {
    return _then(_value.copyWith(
      template: null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as OpenCIWorkflowTemplate,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateWorkflowDomainImplCopyWith<$Res>
    implements $CreateWorkflowDomainCopyWith<$Res> {
  factory _$$CreateWorkflowDomainImplCopyWith(_$CreateWorkflowDomainImpl value,
          $Res Function(_$CreateWorkflowDomainImpl) then) =
      __$$CreateWorkflowDomainImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OpenCIWorkflowTemplate template});
}

/// @nodoc
class __$$CreateWorkflowDomainImplCopyWithImpl<$Res>
    extends _$CreateWorkflowDomainCopyWithImpl<$Res, _$CreateWorkflowDomainImpl>
    implements _$$CreateWorkflowDomainImplCopyWith<$Res> {
  __$$CreateWorkflowDomainImplCopyWithImpl(_$CreateWorkflowDomainImpl _value,
      $Res Function(_$CreateWorkflowDomainImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? template = null,
  }) {
    return _then(_$CreateWorkflowDomainImpl(
      template: null == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as OpenCIWorkflowTemplate,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateWorkflowDomainImpl implements _CreateWorkflowDomain {
  const _$CreateWorkflowDomainImpl(
      {this.template = OpenCIWorkflowTemplate.ipa});

  factory _$CreateWorkflowDomainImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateWorkflowDomainImplFromJson(json);

  @override
  @JsonKey()
  final OpenCIWorkflowTemplate template;

  @override
  String toString() {
    return 'CreateWorkflowDomain(template: $template)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateWorkflowDomainImpl &&
            (identical(other.template, template) ||
                other.template == template));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, template);

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateWorkflowDomainImplCopyWith<_$CreateWorkflowDomainImpl>
      get copyWith =>
          __$$CreateWorkflowDomainImplCopyWithImpl<_$CreateWorkflowDomainImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateWorkflowDomainImplToJson(
      this,
    );
  }
}

abstract class _CreateWorkflowDomain implements CreateWorkflowDomain {
  const factory _CreateWorkflowDomain({final OpenCIWorkflowTemplate template}) =
      _$CreateWorkflowDomainImpl;

  factory _CreateWorkflowDomain.fromJson(Map<String, dynamic> json) =
      _$CreateWorkflowDomainImpl.fromJson;

  @override
  OpenCIWorkflowTemplate get template;

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateWorkflowDomainImplCopyWith<_$CreateWorkflowDomainImpl>
      get copyWith => throw _privateConstructorUsedError;
}
