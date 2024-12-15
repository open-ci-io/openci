// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkflowModel _$WorkflowModelFromJson(Map<String, dynamic> json) {
  return _WorkflowModel.fromJson(json);
}

/// @nodoc
mixin _$WorkflowModel {
  String get currentWorkingDirectory => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  WorkflowModelFlutter get flutter => throw _privateConstructorUsedError;
  WorkflowModelGitHub get github => throw _privateConstructorUsedError;
  List<String> get owners => throw _privateConstructorUsedError;
  List<WorkflowModelStep> get steps => throw _privateConstructorUsedError;

  /// Serializes this WorkflowModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowModelCopyWith<WorkflowModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowModelCopyWith<$Res> {
  factory $WorkflowModelCopyWith(
          WorkflowModel value, $Res Function(WorkflowModel) then) =
      _$WorkflowModelCopyWithImpl<$Res, WorkflowModel>;
  @useResult
  $Res call(
      {String currentWorkingDirectory,
      String name,
      String id,
      WorkflowModelFlutter flutter,
      WorkflowModelGitHub github,
      List<String> owners,
      List<WorkflowModelStep> steps});

  $WorkflowModelFlutterCopyWith<$Res> get flutter;
  $WorkflowModelGitHubCopyWith<$Res> get github;
}

/// @nodoc
class _$WorkflowModelCopyWithImpl<$Res, $Val extends WorkflowModel>
    implements $WorkflowModelCopyWith<$Res> {
  _$WorkflowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWorkingDirectory = null,
    Object? name = null,
    Object? id = null,
    Object? flutter = null,
    Object? github = null,
    Object? owners = null,
    Object? steps = null,
  }) {
    return _then(_value.copyWith(
      currentWorkingDirectory: null == currentWorkingDirectory
          ? _value.currentWorkingDirectory
          : currentWorkingDirectory // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      flutter: null == flutter
          ? _value.flutter
          : flutter // ignore: cast_nullable_to_non_nullable
              as WorkflowModelFlutter,
      github: null == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as WorkflowModelGitHub,
      owners: null == owners
          ? _value.owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<WorkflowModelStep>,
    ) as $Val);
  }

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowModelFlutterCopyWith<$Res> get flutter {
    return $WorkflowModelFlutterCopyWith<$Res>(_value.flutter, (value) {
      return _then(_value.copyWith(flutter: value) as $Val);
    });
  }

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowModelGitHubCopyWith<$Res> get github {
    return $WorkflowModelGitHubCopyWith<$Res>(_value.github, (value) {
      return _then(_value.copyWith(github: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkflowModelImplCopyWith<$Res>
    implements $WorkflowModelCopyWith<$Res> {
  factory _$$WorkflowModelImplCopyWith(
          _$WorkflowModelImpl value, $Res Function(_$WorkflowModelImpl) then) =
      __$$WorkflowModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currentWorkingDirectory,
      String name,
      String id,
      WorkflowModelFlutter flutter,
      WorkflowModelGitHub github,
      List<String> owners,
      List<WorkflowModelStep> steps});

  @override
  $WorkflowModelFlutterCopyWith<$Res> get flutter;
  @override
  $WorkflowModelGitHubCopyWith<$Res> get github;
}

/// @nodoc
class __$$WorkflowModelImplCopyWithImpl<$Res>
    extends _$WorkflowModelCopyWithImpl<$Res, _$WorkflowModelImpl>
    implements _$$WorkflowModelImplCopyWith<$Res> {
  __$$WorkflowModelImplCopyWithImpl(
      _$WorkflowModelImpl _value, $Res Function(_$WorkflowModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWorkingDirectory = null,
    Object? name = null,
    Object? id = null,
    Object? flutter = null,
    Object? github = null,
    Object? owners = null,
    Object? steps = null,
  }) {
    return _then(_$WorkflowModelImpl(
      currentWorkingDirectory: null == currentWorkingDirectory
          ? _value.currentWorkingDirectory
          : currentWorkingDirectory // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      flutter: null == flutter
          ? _value.flutter
          : flutter // ignore: cast_nullable_to_non_nullable
              as WorkflowModelFlutter,
      github: null == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as WorkflowModelGitHub,
      owners: null == owners
          ? _value.owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<WorkflowModelStep>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowModelImpl implements _WorkflowModel {
  const _$WorkflowModelImpl(
      {required this.currentWorkingDirectory,
      required this.name,
      required this.id,
      required this.flutter,
      required this.github,
      required this.owners,
      required this.steps});

  factory _$WorkflowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowModelImplFromJson(json);

  @override
  final String currentWorkingDirectory;
  @override
  final String name;
  @override
  final String id;
  @override
  final WorkflowModelFlutter flutter;
  @override
  final WorkflowModelGitHub github;
  @override
  final List<String> owners;
  @override
  final List<WorkflowModelStep> steps;

  @override
  String toString() {
    return 'WorkflowModel(currentWorkingDirectory: $currentWorkingDirectory, name: $name, id: $id, flutter: $flutter, github: $github, owners: $owners, steps: $steps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowModelImpl &&
            (identical(
                    other.currentWorkingDirectory, currentWorkingDirectory) ||
                other.currentWorkingDirectory == currentWorkingDirectory) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.flutter, flutter) || other.flutter == flutter) &&
            (identical(other.github, github) || other.github == github) &&
            const DeepCollectionEquality().equals(other.owners, owners) &&
            const DeepCollectionEquality().equals(other.steps, steps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentWorkingDirectory,
      name,
      id,
      flutter,
      github,
      const DeepCollectionEquality().hash(owners),
      const DeepCollectionEquality().hash(steps));

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowModelImplCopyWith<_$WorkflowModelImpl> get copyWith =>
      __$$WorkflowModelImplCopyWithImpl<_$WorkflowModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowModelImplToJson(
      this,
    );
  }
}

abstract class _WorkflowModel implements WorkflowModel {
  const factory _WorkflowModel(
      {required final String currentWorkingDirectory,
      required final String name,
      required final String id,
      required final WorkflowModelFlutter flutter,
      required final WorkflowModelGitHub github,
      required final List<String> owners,
      required final List<WorkflowModelStep> steps}) = _$WorkflowModelImpl;

  factory _WorkflowModel.fromJson(Map<String, dynamic> json) =
      _$WorkflowModelImpl.fromJson;

  @override
  String get currentWorkingDirectory;
  @override
  String get name;
  @override
  String get id;
  @override
  WorkflowModelFlutter get flutter;
  @override
  WorkflowModelGitHub get github;
  @override
  List<String> get owners;
  @override
  List<WorkflowModelStep> get steps;

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowModelImplCopyWith<_$WorkflowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowModelFlutter _$WorkflowModelFlutterFromJson(Map<String, dynamic> json) {
  return _WorkflowModelFlutter.fromJson(json);
}

/// @nodoc
mixin _$WorkflowModelFlutter {
  String get version => throw _privateConstructorUsedError;

  /// Serializes this WorkflowModelFlutter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowModelFlutterCopyWith<WorkflowModelFlutter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowModelFlutterCopyWith<$Res> {
  factory $WorkflowModelFlutterCopyWith(WorkflowModelFlutter value,
          $Res Function(WorkflowModelFlutter) then) =
      _$WorkflowModelFlutterCopyWithImpl<$Res, WorkflowModelFlutter>;
  @useResult
  $Res call({String version});
}

/// @nodoc
class _$WorkflowModelFlutterCopyWithImpl<$Res,
        $Val extends WorkflowModelFlutter>
    implements $WorkflowModelFlutterCopyWith<$Res> {
  _$WorkflowModelFlutterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowModelFlutterImplCopyWith<$Res>
    implements $WorkflowModelFlutterCopyWith<$Res> {
  factory _$$WorkflowModelFlutterImplCopyWith(_$WorkflowModelFlutterImpl value,
          $Res Function(_$WorkflowModelFlutterImpl) then) =
      __$$WorkflowModelFlutterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String version});
}

/// @nodoc
class __$$WorkflowModelFlutterImplCopyWithImpl<$Res>
    extends _$WorkflowModelFlutterCopyWithImpl<$Res, _$WorkflowModelFlutterImpl>
    implements _$$WorkflowModelFlutterImplCopyWith<$Res> {
  __$$WorkflowModelFlutterImplCopyWithImpl(_$WorkflowModelFlutterImpl _value,
      $Res Function(_$WorkflowModelFlutterImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
  }) {
    return _then(_$WorkflowModelFlutterImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowModelFlutterImpl implements _WorkflowModelFlutter {
  const _$WorkflowModelFlutterImpl({required this.version});

  factory _$WorkflowModelFlutterImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowModelFlutterImplFromJson(json);

  @override
  final String version;

  @override
  String toString() {
    return 'WorkflowModelFlutter(version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowModelFlutterImpl &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version);

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowModelFlutterImplCopyWith<_$WorkflowModelFlutterImpl>
      get copyWith =>
          __$$WorkflowModelFlutterImplCopyWithImpl<_$WorkflowModelFlutterImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowModelFlutterImplToJson(
      this,
    );
  }
}

abstract class _WorkflowModelFlutter implements WorkflowModelFlutter {
  const factory _WorkflowModelFlutter({required final String version}) =
      _$WorkflowModelFlutterImpl;

  factory _WorkflowModelFlutter.fromJson(Map<String, dynamic> json) =
      _$WorkflowModelFlutterImpl.fromJson;

  @override
  String get version;

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowModelFlutterImplCopyWith<_$WorkflowModelFlutterImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkflowModelGitHub _$WorkflowModelGitHubFromJson(Map<String, dynamic> json) {
  return _WorkflowModelGitHub.fromJson(json);
}

/// @nodoc
mixin _$WorkflowModelGitHub {
  String get repositoryUrl => throw _privateConstructorUsedError;
  GitHubTriggerType get triggerType => throw _privateConstructorUsedError;
  String get baseBranch => throw _privateConstructorUsedError;

  /// Serializes this WorkflowModelGitHub to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowModelGitHubCopyWith<WorkflowModelGitHub> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowModelGitHubCopyWith<$Res> {
  factory $WorkflowModelGitHubCopyWith(
          WorkflowModelGitHub value, $Res Function(WorkflowModelGitHub) then) =
      _$WorkflowModelGitHubCopyWithImpl<$Res, WorkflowModelGitHub>;
  @useResult
  $Res call(
      {String repositoryUrl, GitHubTriggerType triggerType, String baseBranch});
}

/// @nodoc
class _$WorkflowModelGitHubCopyWithImpl<$Res, $Val extends WorkflowModelGitHub>
    implements $WorkflowModelGitHubCopyWith<$Res> {
  _$WorkflowModelGitHubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repositoryUrl = null,
    Object? triggerType = null,
    Object? baseBranch = null,
  }) {
    return _then(_value.copyWith(
      repositoryUrl: null == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      triggerType: null == triggerType
          ? _value.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as GitHubTriggerType,
      baseBranch: null == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowModelGitHubImplCopyWith<$Res>
    implements $WorkflowModelGitHubCopyWith<$Res> {
  factory _$$WorkflowModelGitHubImplCopyWith(_$WorkflowModelGitHubImpl value,
          $Res Function(_$WorkflowModelGitHubImpl) then) =
      __$$WorkflowModelGitHubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String repositoryUrl, GitHubTriggerType triggerType, String baseBranch});
}

/// @nodoc
class __$$WorkflowModelGitHubImplCopyWithImpl<$Res>
    extends _$WorkflowModelGitHubCopyWithImpl<$Res, _$WorkflowModelGitHubImpl>
    implements _$$WorkflowModelGitHubImplCopyWith<$Res> {
  __$$WorkflowModelGitHubImplCopyWithImpl(_$WorkflowModelGitHubImpl _value,
      $Res Function(_$WorkflowModelGitHubImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repositoryUrl = null,
    Object? triggerType = null,
    Object? baseBranch = null,
  }) {
    return _then(_$WorkflowModelGitHubImpl(
      repositoryUrl: null == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      triggerType: null == triggerType
          ? _value.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as GitHubTriggerType,
      baseBranch: null == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowModelGitHubImpl implements _WorkflowModelGitHub {
  const _$WorkflowModelGitHubImpl(
      {required this.repositoryUrl,
      required this.triggerType,
      required this.baseBranch});

  factory _$WorkflowModelGitHubImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowModelGitHubImplFromJson(json);

  @override
  final String repositoryUrl;
  @override
  final GitHubTriggerType triggerType;
  @override
  final String baseBranch;

  @override
  String toString() {
    return 'WorkflowModelGitHub(repositoryUrl: $repositoryUrl, triggerType: $triggerType, baseBranch: $baseBranch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowModelGitHubImpl &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.triggerType, triggerType) ||
                other.triggerType == triggerType) &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, repositoryUrl, triggerType, baseBranch);

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowModelGitHubImplCopyWith<_$WorkflowModelGitHubImpl> get copyWith =>
      __$$WorkflowModelGitHubImplCopyWithImpl<_$WorkflowModelGitHubImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowModelGitHubImplToJson(
      this,
    );
  }
}

abstract class _WorkflowModelGitHub implements WorkflowModelGitHub {
  const factory _WorkflowModelGitHub(
      {required final String repositoryUrl,
      required final GitHubTriggerType triggerType,
      required final String baseBranch}) = _$WorkflowModelGitHubImpl;

  factory _WorkflowModelGitHub.fromJson(Map<String, dynamic> json) =
      _$WorkflowModelGitHubImpl.fromJson;

  @override
  String get repositoryUrl;
  @override
  GitHubTriggerType get triggerType;
  @override
  String get baseBranch;

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowModelGitHubImplCopyWith<_$WorkflowModelGitHubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowModelStep _$WorkflowModelStepFromJson(Map<String, dynamic> json) {
  return _WorkflowModelStep.fromJson(json);
}

/// @nodoc
mixin _$WorkflowModelStep {
  String get name => throw _privateConstructorUsedError;
  List<String> get commands => throw _privateConstructorUsedError;

  /// Serializes this WorkflowModelStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkflowModelStepCopyWith<WorkflowModelStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowModelStepCopyWith<$Res> {
  factory $WorkflowModelStepCopyWith(
          WorkflowModelStep value, $Res Function(WorkflowModelStep) then) =
      _$WorkflowModelStepCopyWithImpl<$Res, WorkflowModelStep>;
  @useResult
  $Res call({String name, List<String> commands});
}

/// @nodoc
class _$WorkflowModelStepCopyWithImpl<$Res, $Val extends WorkflowModelStep>
    implements $WorkflowModelStepCopyWith<$Res> {
  _$WorkflowModelStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? commands = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      commands: null == commands
          ? _value.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowModelStepImplCopyWith<$Res>
    implements $WorkflowModelStepCopyWith<$Res> {
  factory _$$WorkflowModelStepImplCopyWith(_$WorkflowModelStepImpl value,
          $Res Function(_$WorkflowModelStepImpl) then) =
      __$$WorkflowModelStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<String> commands});
}

/// @nodoc
class __$$WorkflowModelStepImplCopyWithImpl<$Res>
    extends _$WorkflowModelStepCopyWithImpl<$Res, _$WorkflowModelStepImpl>
    implements _$$WorkflowModelStepImplCopyWith<$Res> {
  __$$WorkflowModelStepImplCopyWithImpl(_$WorkflowModelStepImpl _value,
      $Res Function(_$WorkflowModelStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? commands = null,
  }) {
    return _then(_$WorkflowModelStepImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      commands: null == commands
          ? _value.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowModelStepImpl implements _WorkflowModelStep {
  const _$WorkflowModelStepImpl({this.name = '', this.commands = const []});

  factory _$WorkflowModelStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowModelStepImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final List<String> commands;

  @override
  String toString() {
    return 'WorkflowModelStep(name: $name, commands: $commands)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowModelStepImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.commands, commands));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(commands));

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowModelStepImplCopyWith<_$WorkflowModelStepImpl> get copyWith =>
      __$$WorkflowModelStepImplCopyWithImpl<_$WorkflowModelStepImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowModelStepImplToJson(
      this,
    );
  }
}

abstract class _WorkflowModelStep implements WorkflowModelStep {
  const factory _WorkflowModelStep(
      {final String name,
      final List<String> commands}) = _$WorkflowModelStepImpl;

  factory _WorkflowModelStep.fromJson(Map<String, dynamic> json) =
      _$WorkflowModelStepImpl.fromJson;

  @override
  String get name;
  @override
  List<String> get commands;

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkflowModelStepImplCopyWith<_$WorkflowModelStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
