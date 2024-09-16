// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActionModel _$ActionModelFromJson(Map<String, dynamic> json) {
  return _ActionModel.fromJson(json);
}

/// @nodoc
mixin _$ActionModel {
  String get title => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get uses => throw _privateConstructorUsedError;
  List<ActionModelProperties> get properties =>
      throw _privateConstructorUsedError;

  /// Serializes this ActionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionModelCopyWith<ActionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionModelCopyWith<$Res> {
  factory $ActionModelCopyWith(
          ActionModel value, $Res Function(ActionModel) then) =
      _$ActionModelCopyWithImpl<$Res, ActionModel>;
  @useResult
  $Res call(
      {String title,
      String source,
      String name,
      String uses,
      List<ActionModelProperties> properties});
}

/// @nodoc
class _$ActionModelCopyWithImpl<$Res, $Val extends ActionModel>
    implements $ActionModelCopyWith<$Res> {
  _$ActionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? source = null,
    Object? name = null,
    Object? uses = null,
    Object? properties = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uses: null == uses
          ? _value.uses
          : uses // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as List<ActionModelProperties>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionModelImplCopyWith<$Res>
    implements $ActionModelCopyWith<$Res> {
  factory _$$ActionModelImplCopyWith(
          _$ActionModelImpl value, $Res Function(_$ActionModelImpl) then) =
      __$$ActionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String source,
      String name,
      String uses,
      List<ActionModelProperties> properties});
}

/// @nodoc
class __$$ActionModelImplCopyWithImpl<$Res>
    extends _$ActionModelCopyWithImpl<$Res, _$ActionModelImpl>
    implements _$$ActionModelImplCopyWith<$Res> {
  __$$ActionModelImplCopyWithImpl(
      _$ActionModelImpl _value, $Res Function(_$ActionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? source = null,
    Object? name = null,
    Object? uses = null,
    Object? properties = null,
  }) {
    return _then(_$ActionModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uses: null == uses
          ? _value.uses
          : uses // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as List<ActionModelProperties>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionModelImpl implements _ActionModel {
  const _$ActionModelImpl(
      {required this.title,
      required this.source,
      required this.name,
      required this.uses,
      final List<ActionModelProperties> properties = const []})
      : _properties = properties;

  factory _$ActionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionModelImplFromJson(json);

  @override
  final String title;
  @override
  final String source;
  @override
  final String name;
  @override
  final String uses;
  final List<ActionModelProperties> _properties;
  @override
  @JsonKey()
  List<ActionModelProperties> get properties {
    if (_properties is EqualUnmodifiableListView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_properties);
  }

  @override
  String toString() {
    return 'ActionModel(title: $title, source: $source, name: $name, uses: $uses, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uses, uses) || other.uses == uses) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, source, name, uses,
      const DeepCollectionEquality().hash(_properties));

  /// Create a copy of ActionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionModelImplCopyWith<_$ActionModelImpl> get copyWith =>
      __$$ActionModelImplCopyWithImpl<_$ActionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionModelImplToJson(
      this,
    );
  }
}

abstract class _ActionModel implements ActionModel {
  const factory _ActionModel(
      {required final String title,
      required final String source,
      required final String name,
      required final String uses,
      final List<ActionModelProperties> properties}) = _$ActionModelImpl;

  factory _ActionModel.fromJson(Map<String, dynamic> json) =
      _$ActionModelImpl.fromJson;

  @override
  String get title;
  @override
  String get source;
  @override
  String get name;
  @override
  String get uses;
  @override
  List<ActionModelProperties> get properties;

  /// Create a copy of ActionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionModelImplCopyWith<_$ActionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionModelProperties _$ActionModelPropertiesFromJson(
    Map<String, dynamic> json) {
  return _ActionModelProperties.fromJson(json);
}

/// @nodoc
mixin _$ActionModelProperties {
  FormStyle get formStyle => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;

  /// Serializes this ActionModelProperties to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionModelProperties
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionModelPropertiesCopyWith<ActionModelProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionModelPropertiesCopyWith<$Res> {
  factory $ActionModelPropertiesCopyWith(ActionModelProperties value,
          $Res Function(ActionModelProperties) then) =
      _$ActionModelPropertiesCopyWithImpl<$Res, ActionModelProperties>;
  @useResult
  $Res call(
      {FormStyle formStyle,
      String label,
      String value,
      String key,
      List<String> options});
}

/// @nodoc
class _$ActionModelPropertiesCopyWithImpl<$Res,
        $Val extends ActionModelProperties>
    implements $ActionModelPropertiesCopyWith<$Res> {
  _$ActionModelPropertiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionModelProperties
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formStyle = null,
    Object? label = null,
    Object? value = null,
    Object? key = null,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      formStyle: null == formStyle
          ? _value.formStyle
          : formStyle // ignore: cast_nullable_to_non_nullable
              as FormStyle,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionModelPropertiesImplCopyWith<$Res>
    implements $ActionModelPropertiesCopyWith<$Res> {
  factory _$$ActionModelPropertiesImplCopyWith(
          _$ActionModelPropertiesImpl value,
          $Res Function(_$ActionModelPropertiesImpl) then) =
      __$$ActionModelPropertiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FormStyle formStyle,
      String label,
      String value,
      String key,
      List<String> options});
}

/// @nodoc
class __$$ActionModelPropertiesImplCopyWithImpl<$Res>
    extends _$ActionModelPropertiesCopyWithImpl<$Res,
        _$ActionModelPropertiesImpl>
    implements _$$ActionModelPropertiesImplCopyWith<$Res> {
  __$$ActionModelPropertiesImplCopyWithImpl(_$ActionModelPropertiesImpl _value,
      $Res Function(_$ActionModelPropertiesImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActionModelProperties
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formStyle = null,
    Object? label = null,
    Object? value = null,
    Object? key = null,
    Object? options = null,
  }) {
    return _then(_$ActionModelPropertiesImpl(
      formStyle: null == formStyle
          ? _value.formStyle
          : formStyle // ignore: cast_nullable_to_non_nullable
              as FormStyle,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionModelPropertiesImpl implements _ActionModelProperties {
  const _$ActionModelPropertiesImpl(
      {required this.formStyle,
      required this.label,
      required this.value,
      required this.key,
      final List<String> options = const []})
      : _options = options;

  factory _$ActionModelPropertiesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionModelPropertiesImplFromJson(json);

  @override
  final FormStyle formStyle;
  @override
  final String label;
  @override
  final String value;
  @override
  final String key;
  final List<String> _options;
  @override
  @JsonKey()
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'ActionModelProperties(formStyle: $formStyle, label: $label, value: $value, key: $key, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionModelPropertiesImpl &&
            (identical(other.formStyle, formStyle) ||
                other.formStyle == formStyle) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, formStyle, label, value, key,
      const DeepCollectionEquality().hash(_options));

  /// Create a copy of ActionModelProperties
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionModelPropertiesImplCopyWith<_$ActionModelPropertiesImpl>
      get copyWith => __$$ActionModelPropertiesImplCopyWithImpl<
          _$ActionModelPropertiesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionModelPropertiesImplToJson(
      this,
    );
  }
}

abstract class _ActionModelProperties implements ActionModelProperties {
  const factory _ActionModelProperties(
      {required final FormStyle formStyle,
      required final String label,
      required final String value,
      required final String key,
      final List<String> options}) = _$ActionModelPropertiesImpl;

  factory _ActionModelProperties.fromJson(Map<String, dynamic> json) =
      _$ActionModelPropertiesImpl.fromJson;

  @override
  FormStyle get formStyle;
  @override
  String get label;
  @override
  String get value;
  @override
  String get key;
  @override
  List<String> get options;

  /// Create a copy of ActionModelProperties
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionModelPropertiesImplCopyWith<_$ActionModelPropertiesImpl>
      get copyWith => throw _privateConstructorUsedError;
}
