// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EditorDomain _$EditorDomainFromJson(Map<String, dynamic> json) {
  return _EditorDomain.fromJson(json);
}

/// @nodoc
mixin _$EditorDomain {
  ConfigureFirstActionDomain get firstAction =>
      throw _privateConstructorUsedError;
  List<ActionModel> get actionList => throw _privateConstructorUsedError;

  /// Serializes this EditorDomain to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EditorDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditorDomainCopyWith<EditorDomain> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorDomainCopyWith<$Res> {
  factory $EditorDomainCopyWith(
          EditorDomain value, $Res Function(EditorDomain) then) =
      _$EditorDomainCopyWithImpl<$Res, EditorDomain>;
  @useResult
  $Res call(
      {ConfigureFirstActionDomain firstAction, List<ActionModel> actionList});

  $ConfigureFirstActionDomainCopyWith<$Res> get firstAction;
}

/// @nodoc
class _$EditorDomainCopyWithImpl<$Res, $Val extends EditorDomain>
    implements $EditorDomainCopyWith<$Res> {
  _$EditorDomainCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditorDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstAction = null,
    Object? actionList = null,
  }) {
    return _then(_value.copyWith(
      firstAction: null == firstAction
          ? _value.firstAction
          : firstAction // ignore: cast_nullable_to_non_nullable
              as ConfigureFirstActionDomain,
      actionList: null == actionList
          ? _value.actionList
          : actionList // ignore: cast_nullable_to_non_nullable
              as List<ActionModel>,
    ) as $Val);
  }

  /// Create a copy of EditorDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConfigureFirstActionDomainCopyWith<$Res> get firstAction {
    return $ConfigureFirstActionDomainCopyWith<$Res>(_value.firstAction,
        (value) {
      return _then(_value.copyWith(firstAction: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EditorDomainImplCopyWith<$Res>
    implements $EditorDomainCopyWith<$Res> {
  factory _$$EditorDomainImplCopyWith(
          _$EditorDomainImpl value, $Res Function(_$EditorDomainImpl) then) =
      __$$EditorDomainImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ConfigureFirstActionDomain firstAction, List<ActionModel> actionList});

  @override
  $ConfigureFirstActionDomainCopyWith<$Res> get firstAction;
}

/// @nodoc
class __$$EditorDomainImplCopyWithImpl<$Res>
    extends _$EditorDomainCopyWithImpl<$Res, _$EditorDomainImpl>
    implements _$$EditorDomainImplCopyWith<$Res> {
  __$$EditorDomainImplCopyWithImpl(
      _$EditorDomainImpl _value, $Res Function(_$EditorDomainImpl) _then)
      : super(_value, _then);

  /// Create a copy of EditorDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstAction = null,
    Object? actionList = null,
  }) {
    return _then(_$EditorDomainImpl(
      firstAction: null == firstAction
          ? _value.firstAction
          : firstAction // ignore: cast_nullable_to_non_nullable
              as ConfigureFirstActionDomain,
      actionList: null == actionList
          ? _value._actionList
          : actionList // ignore: cast_nullable_to_non_nullable
              as List<ActionModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EditorDomainImpl implements _EditorDomain {
  const _$EditorDomainImpl(
      {this.firstAction = const ConfigureFirstActionDomain(),
      final List<ActionModel> actionList = const []})
      : _actionList = actionList;

  factory _$EditorDomainImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditorDomainImplFromJson(json);

  @override
  @JsonKey()
  final ConfigureFirstActionDomain firstAction;
  final List<ActionModel> _actionList;
  @override
  @JsonKey()
  List<ActionModel> get actionList {
    if (_actionList is EqualUnmodifiableListView) return _actionList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionList);
  }

  @override
  String toString() {
    return 'EditorDomain(firstAction: $firstAction, actionList: $actionList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditorDomainImpl &&
            (identical(other.firstAction, firstAction) ||
                other.firstAction == firstAction) &&
            const DeepCollectionEquality()
                .equals(other._actionList, _actionList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firstAction,
      const DeepCollectionEquality().hash(_actionList));

  /// Create a copy of EditorDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditorDomainImplCopyWith<_$EditorDomainImpl> get copyWith =>
      __$$EditorDomainImplCopyWithImpl<_$EditorDomainImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditorDomainImplToJson(
      this,
    );
  }
}

abstract class _EditorDomain implements EditorDomain {
  const factory _EditorDomain(
      {final ConfigureFirstActionDomain firstAction,
      final List<ActionModel> actionList}) = _$EditorDomainImpl;

  factory _EditorDomain.fromJson(Map<String, dynamic> json) =
      _$EditorDomainImpl.fromJson;

  @override
  ConfigureFirstActionDomain get firstAction;
  @override
  List<ActionModel> get actionList;

  /// Create a copy of EditorDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditorDomainImplCopyWith<_$EditorDomainImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
