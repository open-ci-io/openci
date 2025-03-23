// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OpenCIGitHubRepository _$OpenCIGitHubRepositoryFromJson(
    Map<String, dynamic> json) {
  return _OpenCIGitHubRepository.fromJson(json);
}

/// @nodoc
mixin _$OpenCIGitHubRepository {
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'node_id')
  String get nodeId => throw _privateConstructorUsedError;
  bool get private => throw _privateConstructorUsedError;

  /// Serializes this OpenCIGitHubRepository to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenCIGitHubRepositoryCopyWith<OpenCIGitHubRepository> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenCIGitHubRepositoryCopyWith<$Res> {
  factory $OpenCIGitHubRepositoryCopyWith(OpenCIGitHubRepository value,
          $Res Function(OpenCIGitHubRepository) then) =
      _$OpenCIGitHubRepositoryCopyWithImpl<$Res, OpenCIGitHubRepository>;
  @useResult
  $Res call(
      {@JsonKey(name: 'full_name') String fullName,
      int id,
      String name,
      @JsonKey(name: 'node_id') String nodeId,
      bool private});
}

/// @nodoc
class _$OpenCIGitHubRepositoryCopyWithImpl<$Res,
        $Val extends OpenCIGitHubRepository>
    implements $OpenCIGitHubRepositoryCopyWith<$Res> {
  _$OpenCIGitHubRepositoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? id = null,
    Object? name = null,
    Object? nodeId = null,
    Object? private = null,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: null == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
      private: null == private
          ? _value.private
          : private // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenCIGitHubRepositoryImplCopyWith<$Res>
    implements $OpenCIGitHubRepositoryCopyWith<$Res> {
  factory _$$OpenCIGitHubRepositoryImplCopyWith(
          _$OpenCIGitHubRepositoryImpl value,
          $Res Function(_$OpenCIGitHubRepositoryImpl) then) =
      __$$OpenCIGitHubRepositoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'full_name') String fullName,
      int id,
      String name,
      @JsonKey(name: 'node_id') String nodeId,
      bool private});
}

/// @nodoc
class __$$OpenCIGitHubRepositoryImplCopyWithImpl<$Res>
    extends _$OpenCIGitHubRepositoryCopyWithImpl<$Res,
        _$OpenCIGitHubRepositoryImpl>
    implements _$$OpenCIGitHubRepositoryImplCopyWith<$Res> {
  __$$OpenCIGitHubRepositoryImplCopyWithImpl(
      _$OpenCIGitHubRepositoryImpl _value,
      $Res Function(_$OpenCIGitHubRepositoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? id = null,
    Object? name = null,
    Object? nodeId = null,
    Object? private = null,
  }) {
    return _then(_$OpenCIGitHubRepositoryImpl(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: null == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
      private: null == private
          ? _value.private
          : private // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenCIGitHubRepositoryImpl implements _OpenCIGitHubRepository {
  const _$OpenCIGitHubRepositoryImpl(
      {@JsonKey(name: 'full_name') required this.fullName,
      required this.id,
      required this.name,
      @JsonKey(name: 'node_id') required this.nodeId,
      required this.private});

  factory _$OpenCIGitHubRepositoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenCIGitHubRepositoryImplFromJson(json);

  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'node_id')
  final String nodeId;
  @override
  final bool private;

  @override
  String toString() {
    return 'OpenCIGitHubRepository(fullName: $fullName, id: $id, name: $name, nodeId: $nodeId, private: $private)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenCIGitHubRepositoryImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.private, private) || other.private == private));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fullName, id, name, nodeId, private);

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenCIGitHubRepositoryImplCopyWith<_$OpenCIGitHubRepositoryImpl>
      get copyWith => __$$OpenCIGitHubRepositoryImplCopyWithImpl<
          _$OpenCIGitHubRepositoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenCIGitHubRepositoryImplToJson(
      this,
    );
  }
}

abstract class _OpenCIGitHubRepository implements OpenCIGitHubRepository {
  const factory _OpenCIGitHubRepository(
      {@JsonKey(name: 'full_name') required final String fullName,
      required final int id,
      required final String name,
      @JsonKey(name: 'node_id') required final String nodeId,
      required final bool private}) = _$OpenCIGitHubRepositoryImpl;

  factory _OpenCIGitHubRepository.fromJson(Map<String, dynamic> json) =
      _$OpenCIGitHubRepositoryImpl.fromJson;

  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'node_id')
  String get nodeId;
  @override
  bool get private;

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenCIGitHubRepositoryImplCopyWith<_$OpenCIGitHubRepositoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
