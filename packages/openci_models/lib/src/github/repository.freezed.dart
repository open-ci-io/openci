// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpenCIGitHubRepository {
  @JsonKey(name: 'full_name')
  String get fullName;
  int get id;
  String get name;
  @JsonKey(name: 'node_id')
  String get nodeId;
  bool get private;

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OpenCIGitHubRepositoryCopyWith<OpenCIGitHubRepository> get copyWith =>
      _$OpenCIGitHubRepositoryCopyWithImpl<OpenCIGitHubRepository>(
          this as OpenCIGitHubRepository, _$identity);

  /// Serializes this OpenCIGitHubRepository to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OpenCIGitHubRepository &&
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

  @override
  String toString() {
    return 'OpenCIGitHubRepository(fullName: $fullName, id: $id, name: $name, nodeId: $nodeId, private: $private)';
  }
}

/// @nodoc
abstract mixin class $OpenCIGitHubRepositoryCopyWith<$Res> {
  factory $OpenCIGitHubRepositoryCopyWith(OpenCIGitHubRepository value,
          $Res Function(OpenCIGitHubRepository) _then) =
      _$OpenCIGitHubRepositoryCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'full_name') String fullName,
      int id,
      String name,
      @JsonKey(name: 'node_id') String nodeId,
      bool private});
}

/// @nodoc
class _$OpenCIGitHubRepositoryCopyWithImpl<$Res>
    implements $OpenCIGitHubRepositoryCopyWith<$Res> {
  _$OpenCIGitHubRepositoryCopyWithImpl(this._self, this._then);

  final OpenCIGitHubRepository _self;
  final $Res Function(OpenCIGitHubRepository) _then;

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
    return _then(_self.copyWith(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: null == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
      private: null == private
          ? _self.private
          : private // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OpenCIGitHubRepository implements OpenCIGitHubRepository {
  const _OpenCIGitHubRepository(
      {@JsonKey(name: 'full_name') required this.fullName,
      required this.id,
      required this.name,
      @JsonKey(name: 'node_id') required this.nodeId,
      required this.private});
  factory _OpenCIGitHubRepository.fromJson(Map<String, dynamic> json) =>
      _$OpenCIGitHubRepositoryFromJson(json);

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

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OpenCIGitHubRepositoryCopyWith<_OpenCIGitHubRepository> get copyWith =>
      __$OpenCIGitHubRepositoryCopyWithImpl<_OpenCIGitHubRepository>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OpenCIGitHubRepositoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OpenCIGitHubRepository &&
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

  @override
  String toString() {
    return 'OpenCIGitHubRepository(fullName: $fullName, id: $id, name: $name, nodeId: $nodeId, private: $private)';
  }
}

/// @nodoc
abstract mixin class _$OpenCIGitHubRepositoryCopyWith<$Res>
    implements $OpenCIGitHubRepositoryCopyWith<$Res> {
  factory _$OpenCIGitHubRepositoryCopyWith(_OpenCIGitHubRepository value,
          $Res Function(_OpenCIGitHubRepository) _then) =
      __$OpenCIGitHubRepositoryCopyWithImpl;
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
class __$OpenCIGitHubRepositoryCopyWithImpl<$Res>
    implements _$OpenCIGitHubRepositoryCopyWith<$Res> {
  __$OpenCIGitHubRepositoryCopyWithImpl(this._self, this._then);

  final _OpenCIGitHubRepository _self;
  final $Res Function(_OpenCIGitHubRepository) _then;

  /// Create a copy of OpenCIGitHubRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fullName = null,
    Object? id = null,
    Object? name = null,
    Object? nodeId = null,
    Object? private = null,
  }) {
    return _then(_OpenCIGitHubRepository(
      fullName: null == fullName
          ? _self.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: null == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
      private: null == private
          ? _self.private
          : private // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
