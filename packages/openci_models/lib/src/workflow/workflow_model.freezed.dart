// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowModel {
  String get currentWorkingDirectory;
  String get name;
  String get id;
  WorkflowModelFlutter get flutter;
  WorkflowModelGitHub get github;
  List<String> get owners;
  List<WorkflowModelStep> get steps;

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowModelCopyWith<WorkflowModel> get copyWith =>
      _$WorkflowModelCopyWithImpl<WorkflowModel>(
          this as WorkflowModel, _$identity);

  /// Serializes this WorkflowModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowModel &&
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

  @override
  String toString() {
    return 'WorkflowModel(currentWorkingDirectory: $currentWorkingDirectory, name: $name, id: $id, flutter: $flutter, github: $github, owners: $owners, steps: $steps)';
  }
}

/// @nodoc
abstract mixin class $WorkflowModelCopyWith<$Res> {
  factory $WorkflowModelCopyWith(
          WorkflowModel value, $Res Function(WorkflowModel) _then) =
      _$WorkflowModelCopyWithImpl;
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
class _$WorkflowModelCopyWithImpl<$Res>
    implements $WorkflowModelCopyWith<$Res> {
  _$WorkflowModelCopyWithImpl(this._self, this._then);

  final WorkflowModel _self;
  final $Res Function(WorkflowModel) _then;

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
    return _then(_self.copyWith(
      currentWorkingDirectory: null == currentWorkingDirectory
          ? _self.currentWorkingDirectory
          : currentWorkingDirectory // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      flutter: null == flutter
          ? _self.flutter
          : flutter // ignore: cast_nullable_to_non_nullable
              as WorkflowModelFlutter,
      github: null == github
          ? _self.github
          : github // ignore: cast_nullable_to_non_nullable
              as WorkflowModelGitHub,
      owners: null == owners
          ? _self.owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<WorkflowModelStep>,
    ));
  }

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowModelFlutterCopyWith<$Res> get flutter {
    return $WorkflowModelFlutterCopyWith<$Res>(_self.flutter, (value) {
      return _then(_self.copyWith(flutter: value));
    });
  }

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowModelGitHubCopyWith<$Res> get github {
    return $WorkflowModelGitHubCopyWith<$Res>(_self.github, (value) {
      return _then(_self.copyWith(github: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowModel implements WorkflowModel {
  const _WorkflowModel(
      {required this.currentWorkingDirectory,
      required this.name,
      required this.id,
      required this.flutter,
      required this.github,
      required this.owners,
      required this.steps});
  factory _WorkflowModel.fromJson(Map<String, dynamic> json) =>
      _$WorkflowModelFromJson(json);

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

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowModelCopyWith<_WorkflowModel> get copyWith =>
      __$WorkflowModelCopyWithImpl<_WorkflowModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowModel &&
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

  @override
  String toString() {
    return 'WorkflowModel(currentWorkingDirectory: $currentWorkingDirectory, name: $name, id: $id, flutter: $flutter, github: $github, owners: $owners, steps: $steps)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowModelCopyWith<$Res>
    implements $WorkflowModelCopyWith<$Res> {
  factory _$WorkflowModelCopyWith(
          _WorkflowModel value, $Res Function(_WorkflowModel) _then) =
      __$WorkflowModelCopyWithImpl;
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
class __$WorkflowModelCopyWithImpl<$Res>
    implements _$WorkflowModelCopyWith<$Res> {
  __$WorkflowModelCopyWithImpl(this._self, this._then);

  final _WorkflowModel _self;
  final $Res Function(_WorkflowModel) _then;

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentWorkingDirectory = null,
    Object? name = null,
    Object? id = null,
    Object? flutter = null,
    Object? github = null,
    Object? owners = null,
    Object? steps = null,
  }) {
    return _then(_WorkflowModel(
      currentWorkingDirectory: null == currentWorkingDirectory
          ? _self.currentWorkingDirectory
          : currentWorkingDirectory // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      flutter: null == flutter
          ? _self.flutter
          : flutter // ignore: cast_nullable_to_non_nullable
              as WorkflowModelFlutter,
      github: null == github
          ? _self.github
          : github // ignore: cast_nullable_to_non_nullable
              as WorkflowModelGitHub,
      owners: null == owners
          ? _self.owners
          : owners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _self.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<WorkflowModelStep>,
    ));
  }

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowModelFlutterCopyWith<$Res> get flutter {
    return $WorkflowModelFlutterCopyWith<$Res>(_self.flutter, (value) {
      return _then(_self.copyWith(flutter: value));
    });
  }

  /// Create a copy of WorkflowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkflowModelGitHubCopyWith<$Res> get github {
    return $WorkflowModelGitHubCopyWith<$Res>(_self.github, (value) {
      return _then(_self.copyWith(github: value));
    });
  }
}

/// @nodoc
mixin _$WorkflowModelFlutter {
  @FlutterVersionConverter()
  FlutterVersion get version;

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowModelFlutterCopyWith<WorkflowModelFlutter> get copyWith =>
      _$WorkflowModelFlutterCopyWithImpl<WorkflowModelFlutter>(
          this as WorkflowModelFlutter, _$identity);

  /// Serializes this WorkflowModelFlutter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowModelFlutter &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version);

  @override
  String toString() {
    return 'WorkflowModelFlutter(version: $version)';
  }
}

/// @nodoc
abstract mixin class $WorkflowModelFlutterCopyWith<$Res> {
  factory $WorkflowModelFlutterCopyWith(WorkflowModelFlutter value,
          $Res Function(WorkflowModelFlutter) _then) =
      _$WorkflowModelFlutterCopyWithImpl;
  @useResult
  $Res call({@FlutterVersionConverter() FlutterVersion version});
}

/// @nodoc
class _$WorkflowModelFlutterCopyWithImpl<$Res>
    implements $WorkflowModelFlutterCopyWith<$Res> {
  _$WorkflowModelFlutterCopyWithImpl(this._self, this._then);

  final WorkflowModelFlutter _self;
  final $Res Function(WorkflowModelFlutter) _then;

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
  }) {
    return _then(_self.copyWith(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as FlutterVersion,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowModelFlutter implements WorkflowModelFlutter {
  _WorkflowModelFlutter({@FlutterVersionConverter() required this.version});
  factory _WorkflowModelFlutter.fromJson(Map<String, dynamic> json) =>
      _$WorkflowModelFlutterFromJson(json);

  @override
  @FlutterVersionConverter()
  final FlutterVersion version;

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowModelFlutterCopyWith<_WorkflowModelFlutter> get copyWith =>
      __$WorkflowModelFlutterCopyWithImpl<_WorkflowModelFlutter>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowModelFlutterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowModelFlutter &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version);

  @override
  String toString() {
    return 'WorkflowModelFlutter(version: $version)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowModelFlutterCopyWith<$Res>
    implements $WorkflowModelFlutterCopyWith<$Res> {
  factory _$WorkflowModelFlutterCopyWith(_WorkflowModelFlutter value,
          $Res Function(_WorkflowModelFlutter) _then) =
      __$WorkflowModelFlutterCopyWithImpl;
  @override
  @useResult
  $Res call({@FlutterVersionConverter() FlutterVersion version});
}

/// @nodoc
class __$WorkflowModelFlutterCopyWithImpl<$Res>
    implements _$WorkflowModelFlutterCopyWith<$Res> {
  __$WorkflowModelFlutterCopyWithImpl(this._self, this._then);

  final _WorkflowModelFlutter _self;
  final $Res Function(_WorkflowModelFlutter) _then;

  /// Create a copy of WorkflowModelFlutter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? version = null,
  }) {
    return _then(_WorkflowModelFlutter(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as FlutterVersion,
    ));
  }
}

/// @nodoc
mixin _$WorkflowModelGitHub {
  String get repositoryUrl;
  GitHubTriggerType get triggerType;
  String get baseBranch;

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowModelGitHubCopyWith<WorkflowModelGitHub> get copyWith =>
      _$WorkflowModelGitHubCopyWithImpl<WorkflowModelGitHub>(
          this as WorkflowModelGitHub, _$identity);

  /// Serializes this WorkflowModelGitHub to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowModelGitHub &&
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

  @override
  String toString() {
    return 'WorkflowModelGitHub(repositoryUrl: $repositoryUrl, triggerType: $triggerType, baseBranch: $baseBranch)';
  }
}

/// @nodoc
abstract mixin class $WorkflowModelGitHubCopyWith<$Res> {
  factory $WorkflowModelGitHubCopyWith(
          WorkflowModelGitHub value, $Res Function(WorkflowModelGitHub) _then) =
      _$WorkflowModelGitHubCopyWithImpl;
  @useResult
  $Res call(
      {String repositoryUrl, GitHubTriggerType triggerType, String baseBranch});
}

/// @nodoc
class _$WorkflowModelGitHubCopyWithImpl<$Res>
    implements $WorkflowModelGitHubCopyWith<$Res> {
  _$WorkflowModelGitHubCopyWithImpl(this._self, this._then);

  final WorkflowModelGitHub _self;
  final $Res Function(WorkflowModelGitHub) _then;

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repositoryUrl = null,
    Object? triggerType = null,
    Object? baseBranch = null,
  }) {
    return _then(_self.copyWith(
      repositoryUrl: null == repositoryUrl
          ? _self.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      triggerType: null == triggerType
          ? _self.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as GitHubTriggerType,
      baseBranch: null == baseBranch
          ? _self.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowModelGitHub implements WorkflowModelGitHub {
  const _WorkflowModelGitHub(
      {required this.repositoryUrl,
      required this.triggerType,
      required this.baseBranch});
  factory _WorkflowModelGitHub.fromJson(Map<String, dynamic> json) =>
      _$WorkflowModelGitHubFromJson(json);

  @override
  final String repositoryUrl;
  @override
  final GitHubTriggerType triggerType;
  @override
  final String baseBranch;

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowModelGitHubCopyWith<_WorkflowModelGitHub> get copyWith =>
      __$WorkflowModelGitHubCopyWithImpl<_WorkflowModelGitHub>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowModelGitHubToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowModelGitHub &&
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

  @override
  String toString() {
    return 'WorkflowModelGitHub(repositoryUrl: $repositoryUrl, triggerType: $triggerType, baseBranch: $baseBranch)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowModelGitHubCopyWith<$Res>
    implements $WorkflowModelGitHubCopyWith<$Res> {
  factory _$WorkflowModelGitHubCopyWith(_WorkflowModelGitHub value,
          $Res Function(_WorkflowModelGitHub) _then) =
      __$WorkflowModelGitHubCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String repositoryUrl, GitHubTriggerType triggerType, String baseBranch});
}

/// @nodoc
class __$WorkflowModelGitHubCopyWithImpl<$Res>
    implements _$WorkflowModelGitHubCopyWith<$Res> {
  __$WorkflowModelGitHubCopyWithImpl(this._self, this._then);

  final _WorkflowModelGitHub _self;
  final $Res Function(_WorkflowModelGitHub) _then;

  /// Create a copy of WorkflowModelGitHub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? repositoryUrl = null,
    Object? triggerType = null,
    Object? baseBranch = null,
  }) {
    return _then(_WorkflowModelGitHub(
      repositoryUrl: null == repositoryUrl
          ? _self.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String,
      triggerType: null == triggerType
          ? _self.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as GitHubTriggerType,
      baseBranch: null == baseBranch
          ? _self.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$WorkflowModelStep {
  String get name;
  String get command;

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowModelStepCopyWith<WorkflowModelStep> get copyWith =>
      _$WorkflowModelStepCopyWithImpl<WorkflowModelStep>(
          this as WorkflowModelStep, _$identity);

  /// Serializes this WorkflowModelStep to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowModelStep &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.command, command) || other.command == command));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, command);

  @override
  String toString() {
    return 'WorkflowModelStep(name: $name, command: $command)';
  }
}

/// @nodoc
abstract mixin class $WorkflowModelStepCopyWith<$Res> {
  factory $WorkflowModelStepCopyWith(
          WorkflowModelStep value, $Res Function(WorkflowModelStep) _then) =
      _$WorkflowModelStepCopyWithImpl;
  @useResult
  $Res call({String name, String command});
}

/// @nodoc
class _$WorkflowModelStepCopyWithImpl<$Res>
    implements $WorkflowModelStepCopyWith<$Res> {
  _$WorkflowModelStepCopyWithImpl(this._self, this._then);

  final WorkflowModelStep _self;
  final $Res Function(WorkflowModelStep) _then;

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? command = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowModelStep implements WorkflowModelStep {
  const _WorkflowModelStep({this.name = '', this.command = ''});
  factory _WorkflowModelStep.fromJson(Map<String, dynamic> json) =>
      _$WorkflowModelStepFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String command;

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowModelStepCopyWith<_WorkflowModelStep> get copyWith =>
      __$WorkflowModelStepCopyWithImpl<_WorkflowModelStep>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowModelStepToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowModelStep &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.command, command) || other.command == command));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, command);

  @override
  String toString() {
    return 'WorkflowModelStep(name: $name, command: $command)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowModelStepCopyWith<$Res>
    implements $WorkflowModelStepCopyWith<$Res> {
  factory _$WorkflowModelStepCopyWith(
          _WorkflowModelStep value, $Res Function(_WorkflowModelStep) _then) =
      __$WorkflowModelStepCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String command});
}

/// @nodoc
class __$WorkflowModelStepCopyWithImpl<$Res>
    implements _$WorkflowModelStepCopyWith<$Res> {
  __$WorkflowModelStepCopyWithImpl(this._self, this._then);

  final _WorkflowModelStep _self;
  final $Res Function(_WorkflowModelStep) _then;

  /// Create a copy of WorkflowModelStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? command = null,
  }) {
    return _then(_WorkflowModelStep(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      command: null == command
          ? _self.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
