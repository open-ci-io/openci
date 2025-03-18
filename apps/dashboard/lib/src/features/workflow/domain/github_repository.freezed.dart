// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GithubRepository _$GithubRepositoryFromJson(Map<String, dynamic> json) {
  return _GithubRepository.fromJson(json);
}

/// @nodoc
mixin _$GithubRepository {
  String get selectedRepository => throw _privateConstructorUsedError;
  List<String> get repositories => throw _privateConstructorUsedError;

  /// Serializes this GithubRepository to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GithubRepositoryCopyWith<GithubRepository> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GithubRepositoryCopyWith<$Res> {
  factory $GithubRepositoryCopyWith(
          GithubRepository value, $Res Function(GithubRepository) then) =
      _$GithubRepositoryCopyWithImpl<$Res, GithubRepository>;
  @useResult
  $Res call({String selectedRepository, List<String> repositories});
}

/// @nodoc
class _$GithubRepositoryCopyWithImpl<$Res, $Val extends GithubRepository>
    implements $GithubRepositoryCopyWith<$Res> {
  _$GithubRepositoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRepository = null,
    Object? repositories = null,
  }) {
    return _then(_value.copyWith(
      selectedRepository: null == selectedRepository
          ? _value.selectedRepository
          : selectedRepository // ignore: cast_nullable_to_non_nullable
              as String,
      repositories: null == repositories
          ? _value.repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GithubRepositoryImplCopyWith<$Res>
    implements $GithubRepositoryCopyWith<$Res> {
  factory _$$GithubRepositoryImplCopyWith(_$GithubRepositoryImpl value,
          $Res Function(_$GithubRepositoryImpl) then) =
      __$$GithubRepositoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String selectedRepository, List<String> repositories});
}

/// @nodoc
class __$$GithubRepositoryImplCopyWithImpl<$Res>
    extends _$GithubRepositoryCopyWithImpl<$Res, _$GithubRepositoryImpl>
    implements _$$GithubRepositoryImplCopyWith<$Res> {
  __$$GithubRepositoryImplCopyWithImpl(_$GithubRepositoryImpl _value,
      $Res Function(_$GithubRepositoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRepository = null,
    Object? repositories = null,
  }) {
    return _then(_$GithubRepositoryImpl(
      selectedRepository: null == selectedRepository
          ? _value.selectedRepository
          : selectedRepository // ignore: cast_nullable_to_non_nullable
              as String,
      repositories: null == repositories
          ? _value._repositories
          : repositories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GithubRepositoryImpl implements _GithubRepository {
  const _$GithubRepositoryImpl(
      {required this.selectedRepository,
      required final List<String> repositories})
      : _repositories = repositories;

  factory _$GithubRepositoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$GithubRepositoryImplFromJson(json);

  @override
  final String selectedRepository;
  final List<String> _repositories;
  @override
  List<String> get repositories {
    if (_repositories is EqualUnmodifiableListView) return _repositories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_repositories);
  }

  @override
  String toString() {
    return 'GithubRepository(selectedRepository: $selectedRepository, repositories: $repositories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GithubRepositoryImpl &&
            (identical(other.selectedRepository, selectedRepository) ||
                other.selectedRepository == selectedRepository) &&
            const DeepCollectionEquality()
                .equals(other._repositories, _repositories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, selectedRepository,
      const DeepCollectionEquality().hash(_repositories));

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GithubRepositoryImplCopyWith<_$GithubRepositoryImpl> get copyWith =>
      __$$GithubRepositoryImplCopyWithImpl<_$GithubRepositoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GithubRepositoryImplToJson(
      this,
    );
  }
}

abstract class _GithubRepository implements GithubRepository {
  const factory _GithubRepository(
      {required final String selectedRepository,
      required final List<String> repositories}) = _$GithubRepositoryImpl;

  factory _GithubRepository.fromJson(Map<String, dynamic> json) =
      _$GithubRepositoryImpl.fromJson;

  @override
  String get selectedRepository;
  @override
  List<String> get repositories;

  /// Create a copy of GithubRepository
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GithubRepositoryImplCopyWith<_$GithubRepositoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
