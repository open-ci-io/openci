// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubRepository {
  String get selectedRepository;
  List<String> get repositories;

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubRepositoryCopyWith<GithubRepository> get copyWith =>
      _$GithubRepositoryCopyWithImpl<GithubRepository>(
          this as GithubRepository, _$identity);

  /// Serializes this GithubRepository to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubRepository &&
            (identical(other.selectedRepository, selectedRepository) ||
                other.selectedRepository == selectedRepository) &&
            const DeepCollectionEquality()
                .equals(other.repositories, repositories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, selectedRepository,
      const DeepCollectionEquality().hash(repositories));

  @override
  String toString() {
    return 'GithubRepository(selectedRepository: $selectedRepository, repositories: $repositories)';
  }
}

/// @nodoc
abstract mixin class $GithubRepositoryCopyWith<$Res> {
  factory $GithubRepositoryCopyWith(
          GithubRepository value, $Res Function(GithubRepository) _then) =
      _$GithubRepositoryCopyWithImpl;
  @useResult
  $Res call({String selectedRepository, List<String> repositories});
}

/// @nodoc
class _$GithubRepositoryCopyWithImpl<$Res>
    implements $GithubRepositoryCopyWith<$Res> {
  _$GithubRepositoryCopyWithImpl(this._self, this._then);

  final GithubRepository _self;
  final $Res Function(GithubRepository) _then;

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRepository = null,
    Object? repositories = null,
  }) {
    return _then(_self.copyWith(
      selectedRepository: null == selectedRepository
          ? _self.selectedRepository
          : selectedRepository // ignore: cast_nullable_to_non_nullable
              as String,
      repositories: null == repositories
          ? _self.repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GithubRepository implements GithubRepository {
  const _GithubRepository(
      {required this.selectedRepository,
      required final List<String> repositories})
      : _repositories = repositories;
  factory _GithubRepository.fromJson(Map<String, dynamic> json) =>
      _$GithubRepositoryFromJson(json);

  @override
  final String selectedRepository;
  final List<String> _repositories;
  @override
  List<String> get repositories {
    if (_repositories is EqualUnmodifiableListView) return _repositories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_repositories);
  }

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubRepositoryCopyWith<_GithubRepository> get copyWith =>
      __$GithubRepositoryCopyWithImpl<_GithubRepository>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubRepositoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubRepository &&
            (identical(other.selectedRepository, selectedRepository) ||
                other.selectedRepository == selectedRepository) &&
            const DeepCollectionEquality()
                .equals(other._repositories, _repositories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, selectedRepository,
      const DeepCollectionEquality().hash(_repositories));

  @override
  String toString() {
    return 'GithubRepository(selectedRepository: $selectedRepository, repositories: $repositories)';
  }
}

/// @nodoc
abstract mixin class _$GithubRepositoryCopyWith<$Res>
    implements $GithubRepositoryCopyWith<$Res> {
  factory _$GithubRepositoryCopyWith(
          _GithubRepository value, $Res Function(_GithubRepository) _then) =
      __$GithubRepositoryCopyWithImpl;
  @override
  @useResult
  $Res call({String selectedRepository, List<String> repositories});
}

/// @nodoc
class __$GithubRepositoryCopyWithImpl<$Res>
    implements _$GithubRepositoryCopyWith<$Res> {
  __$GithubRepositoryCopyWithImpl(this._self, this._then);

  final _GithubRepository _self;
  final $Res Function(_GithubRepository) _then;

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedRepository = null,
    Object? repositories = null,
  }) {
    return _then(_GithubRepository(
      selectedRepository: null == selectedRepository
          ? _self.selectedRepository
          : selectedRepository // ignore: cast_nullable_to_non_nullable
              as String,
      repositories: null == repositories
          ? _self._repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
