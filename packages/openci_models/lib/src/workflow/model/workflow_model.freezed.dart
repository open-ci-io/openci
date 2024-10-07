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
  WorkflowAndroidConfig? get android => throw _privateConstructorUsedError;
  WorkflowFirebaseConfig get firebase => throw _privateConstructorUsedError;
  WorkflowIosConfig? get ios => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  WorkflowFlutterConfig get flutter => throw _privateConstructorUsedError;
  WorkflowGitHubConfig? get github => throw _privateConstructorUsedError;
  WorkflowShorebirdConfig get shorebird => throw _privateConstructorUsedError;
  String get workflowName => throw _privateConstructorUsedError;
  OpenCITargetPlatform get platform => throw _privateConstructorUsedError;
  BuildDistributionChannel? get distribution =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      {WorkflowAndroidConfig? android,
      WorkflowFirebaseConfig firebase,
      WorkflowIosConfig? ios,
      String organizationId,
      WorkflowFlutterConfig flutter,
      WorkflowGitHubConfig? github,
      WorkflowShorebirdConfig shorebird,
      String workflowName,
      OpenCITargetPlatform platform,
      BuildDistributionChannel? distribution});

  $WorkflowAndroidConfigCopyWith<$Res>? get android;
  $WorkflowFirebaseConfigCopyWith<$Res> get firebase;
  $WorkflowIosConfigCopyWith<$Res>? get ios;
  $WorkflowFlutterConfigCopyWith<$Res> get flutter;
  $WorkflowGitHubConfigCopyWith<$Res>? get github;
  $WorkflowShorebirdConfigCopyWith<$Res> get shorebird;
}

/// @nodoc
class _$WorkflowModelCopyWithImpl<$Res, $Val extends WorkflowModel>
    implements $WorkflowModelCopyWith<$Res> {
  _$WorkflowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? android = freezed,
    Object? firebase = null,
    Object? ios = freezed,
    Object? organizationId = null,
    Object? flutter = null,
    Object? github = freezed,
    Object? shorebird = null,
    Object? workflowName = null,
    Object? platform = null,
    Object? distribution = freezed,
  }) {
    return _then(_value.copyWith(
      android: freezed == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as WorkflowAndroidConfig?,
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as WorkflowFirebaseConfig,
      ios: freezed == ios
          ? _value.ios
          : ios // ignore: cast_nullable_to_non_nullable
              as WorkflowIosConfig?,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      flutter: null == flutter
          ? _value.flutter
          : flutter // ignore: cast_nullable_to_non_nullable
              as WorkflowFlutterConfig,
      github: freezed == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as WorkflowGitHubConfig?,
      shorebird: null == shorebird
          ? _value.shorebird
          : shorebird // ignore: cast_nullable_to_non_nullable
              as WorkflowShorebirdConfig,
      workflowName: null == workflowName
          ? _value.workflowName
          : workflowName // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as OpenCITargetPlatform,
      distribution: freezed == distribution
          ? _value.distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as BuildDistributionChannel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowAndroidConfigCopyWith<$Res>? get android {
    if (_value.android == null) {
      return null;
    }

    return $WorkflowAndroidConfigCopyWith<$Res>(_value.android!, (value) {
      return _then(_value.copyWith(android: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowFirebaseConfigCopyWith<$Res> get firebase {
    return $WorkflowFirebaseConfigCopyWith<$Res>(_value.firebase, (value) {
      return _then(_value.copyWith(firebase: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowIosConfigCopyWith<$Res>? get ios {
    if (_value.ios == null) {
      return null;
    }

    return $WorkflowIosConfigCopyWith<$Res>(_value.ios!, (value) {
      return _then(_value.copyWith(ios: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowFlutterConfigCopyWith<$Res> get flutter {
    return $WorkflowFlutterConfigCopyWith<$Res>(_value.flutter, (value) {
      return _then(_value.copyWith(flutter: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowGitHubConfigCopyWith<$Res>? get github {
    if (_value.github == null) {
      return null;
    }

    return $WorkflowGitHubConfigCopyWith<$Res>(_value.github!, (value) {
      return _then(_value.copyWith(github: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowShorebirdConfigCopyWith<$Res> get shorebird {
    return $WorkflowShorebirdConfigCopyWith<$Res>(_value.shorebird, (value) {
      return _then(_value.copyWith(shorebird: value) as $Val);
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
      {WorkflowAndroidConfig? android,
      WorkflowFirebaseConfig firebase,
      WorkflowIosConfig? ios,
      String organizationId,
      WorkflowFlutterConfig flutter,
      WorkflowGitHubConfig? github,
      WorkflowShorebirdConfig shorebird,
      String workflowName,
      OpenCITargetPlatform platform,
      BuildDistributionChannel? distribution});

  @override
  $WorkflowAndroidConfigCopyWith<$Res>? get android;
  @override
  $WorkflowFirebaseConfigCopyWith<$Res> get firebase;
  @override
  $WorkflowIosConfigCopyWith<$Res>? get ios;
  @override
  $WorkflowFlutterConfigCopyWith<$Res> get flutter;
  @override
  $WorkflowGitHubConfigCopyWith<$Res>? get github;
  @override
  $WorkflowShorebirdConfigCopyWith<$Res> get shorebird;
}

/// @nodoc
class __$$WorkflowModelImplCopyWithImpl<$Res>
    extends _$WorkflowModelCopyWithImpl<$Res, _$WorkflowModelImpl>
    implements _$$WorkflowModelImplCopyWith<$Res> {
  __$$WorkflowModelImplCopyWithImpl(
      _$WorkflowModelImpl _value, $Res Function(_$WorkflowModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? android = freezed,
    Object? firebase = null,
    Object? ios = freezed,
    Object? organizationId = null,
    Object? flutter = null,
    Object? github = freezed,
    Object? shorebird = null,
    Object? workflowName = null,
    Object? platform = null,
    Object? distribution = freezed,
  }) {
    return _then(_$WorkflowModelImpl(
      android: freezed == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as WorkflowAndroidConfig?,
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as WorkflowFirebaseConfig,
      ios: freezed == ios
          ? _value.ios
          : ios // ignore: cast_nullable_to_non_nullable
              as WorkflowIosConfig?,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      flutter: null == flutter
          ? _value.flutter
          : flutter // ignore: cast_nullable_to_non_nullable
              as WorkflowFlutterConfig,
      github: freezed == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as WorkflowGitHubConfig?,
      shorebird: null == shorebird
          ? _value.shorebird
          : shorebird // ignore: cast_nullable_to_non_nullable
              as WorkflowShorebirdConfig,
      workflowName: null == workflowName
          ? _value.workflowName
          : workflowName // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as OpenCITargetPlatform,
      distribution: freezed == distribution
          ? _value.distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as BuildDistributionChannel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowModelImpl implements _WorkflowModel {
  const _$WorkflowModelImpl(
      {this.android,
      required this.firebase,
      this.ios,
      required this.organizationId,
      required this.flutter,
      this.github,
      required this.shorebird,
      required this.workflowName,
      required this.platform,
      this.distribution = null});

  factory _$WorkflowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowModelImplFromJson(json);

  @override
  final WorkflowAndroidConfig? android;
  @override
  final WorkflowFirebaseConfig firebase;
  @override
  final WorkflowIosConfig? ios;
  @override
  final String organizationId;
  @override
  final WorkflowFlutterConfig flutter;
  @override
  final WorkflowGitHubConfig? github;
  @override
  final WorkflowShorebirdConfig shorebird;
  @override
  final String workflowName;
  @override
  final OpenCITargetPlatform platform;
  @override
  @JsonKey()
  final BuildDistributionChannel? distribution;

  @override
  String toString() {
    return 'WorkflowModel(android: $android, firebase: $firebase, ios: $ios, organizationId: $organizationId, flutter: $flutter, github: $github, shorebird: $shorebird, workflowName: $workflowName, platform: $platform, distribution: $distribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowModelImpl &&
            (identical(other.android, android) || other.android == android) &&
            (identical(other.firebase, firebase) ||
                other.firebase == firebase) &&
            (identical(other.ios, ios) || other.ios == ios) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.flutter, flutter) || other.flutter == flutter) &&
            (identical(other.github, github) || other.github == github) &&
            (identical(other.shorebird, shorebird) ||
                other.shorebird == shorebird) &&
            (identical(other.workflowName, workflowName) ||
                other.workflowName == workflowName) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.distribution, distribution) ||
                other.distribution == distribution));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      android,
      firebase,
      ios,
      organizationId,
      flutter,
      github,
      shorebird,
      workflowName,
      platform,
      distribution);

  @JsonKey(ignore: true)
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
      {final WorkflowAndroidConfig? android,
      required final WorkflowFirebaseConfig firebase,
      final WorkflowIosConfig? ios,
      required final String organizationId,
      required final WorkflowFlutterConfig flutter,
      final WorkflowGitHubConfig? github,
      required final WorkflowShorebirdConfig shorebird,
      required final String workflowName,
      required final OpenCITargetPlatform platform,
      final BuildDistributionChannel? distribution}) = _$WorkflowModelImpl;

  factory _WorkflowModel.fromJson(Map<String, dynamic> json) =
      _$WorkflowModelImpl.fromJson;

  @override
  WorkflowAndroidConfig? get android;
  @override
  WorkflowFirebaseConfig get firebase;
  @override
  WorkflowIosConfig? get ios;
  @override
  String get organizationId;
  @override
  WorkflowFlutterConfig get flutter;
  @override
  WorkflowGitHubConfig? get github;
  @override
  WorkflowShorebirdConfig get shorebird;
  @override
  String get workflowName;
  @override
  OpenCITargetPlatform get platform;
  @override
  BuildDistributionChannel? get distribution;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowModelImplCopyWith<_$WorkflowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowGitHubConfig _$WorkflowGitHubConfigFromJson(Map<String, dynamic> json) {
  return _WorkflowGitHubConfig.fromJson(json);
}

/// @nodoc
mixin _$WorkflowGitHubConfig {
  String? get baseBranch => throw _privateConstructorUsedError;
  String? get repositoryUrl => throw _privateConstructorUsedError;
  String? get triggerType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowGitHubConfigCopyWith<WorkflowGitHubConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowGitHubConfigCopyWith<$Res> {
  factory $WorkflowGitHubConfigCopyWith(WorkflowGitHubConfig value,
          $Res Function(WorkflowGitHubConfig) then) =
      _$WorkflowGitHubConfigCopyWithImpl<$Res, WorkflowGitHubConfig>;
  @useResult
  $Res call({String? baseBranch, String? repositoryUrl, String? triggerType});
}

/// @nodoc
class _$WorkflowGitHubConfigCopyWithImpl<$Res,
        $Val extends WorkflowGitHubConfig>
    implements $WorkflowGitHubConfigCopyWith<$Res> {
  _$WorkflowGitHubConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseBranch = freezed,
    Object? repositoryUrl = freezed,
    Object? triggerType = freezed,
  }) {
    return _then(_value.copyWith(
      baseBranch: freezed == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      repositoryUrl: freezed == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      triggerType: freezed == triggerType
          ? _value.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowGitHubConfigImplCopyWith<$Res>
    implements $WorkflowGitHubConfigCopyWith<$Res> {
  factory _$$WorkflowGitHubConfigImplCopyWith(_$WorkflowGitHubConfigImpl value,
          $Res Function(_$WorkflowGitHubConfigImpl) then) =
      __$$WorkflowGitHubConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? baseBranch, String? repositoryUrl, String? triggerType});
}

/// @nodoc
class __$$WorkflowGitHubConfigImplCopyWithImpl<$Res>
    extends _$WorkflowGitHubConfigCopyWithImpl<$Res, _$WorkflowGitHubConfigImpl>
    implements _$$WorkflowGitHubConfigImplCopyWith<$Res> {
  __$$WorkflowGitHubConfigImplCopyWithImpl(_$WorkflowGitHubConfigImpl _value,
      $Res Function(_$WorkflowGitHubConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseBranch = freezed,
    Object? repositoryUrl = freezed,
    Object? triggerType = freezed,
  }) {
    return _then(_$WorkflowGitHubConfigImpl(
      baseBranch: freezed == baseBranch
          ? _value.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      repositoryUrl: freezed == repositoryUrl
          ? _value.repositoryUrl
          : repositoryUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      triggerType: freezed == triggerType
          ? _value.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowGitHubConfigImpl implements _WorkflowGitHubConfig {
  const _$WorkflowGitHubConfigImpl(
      {this.baseBranch = null,
      this.repositoryUrl = null,
      this.triggerType = null});

  factory _$WorkflowGitHubConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowGitHubConfigImplFromJson(json);

  @override
  @JsonKey()
  final String? baseBranch;
  @override
  @JsonKey()
  final String? repositoryUrl;
  @override
  @JsonKey()
  final String? triggerType;

  @override
  String toString() {
    return 'WorkflowGitHubConfig(baseBranch: $baseBranch, repositoryUrl: $repositoryUrl, triggerType: $triggerType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowGitHubConfigImpl &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.triggerType, triggerType) ||
                other.triggerType == triggerType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, baseBranch, repositoryUrl, triggerType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowGitHubConfigImplCopyWith<_$WorkflowGitHubConfigImpl>
      get copyWith =>
          __$$WorkflowGitHubConfigImplCopyWithImpl<_$WorkflowGitHubConfigImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowGitHubConfigImplToJson(
      this,
    );
  }
}

abstract class _WorkflowGitHubConfig implements WorkflowGitHubConfig {
  const factory _WorkflowGitHubConfig(
      {final String? baseBranch,
      final String? repositoryUrl,
      final String? triggerType}) = _$WorkflowGitHubConfigImpl;

  factory _WorkflowGitHubConfig.fromJson(Map<String, dynamic> json) =
      _$WorkflowGitHubConfigImpl.fromJson;

  @override
  String? get baseBranch;
  @override
  String? get repositoryUrl;
  @override
  String? get triggerType;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowGitHubConfigImplCopyWith<_$WorkflowGitHubConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkflowAndroidConfig _$WorkflowAndroidConfigFromJson(
    Map<String, dynamic> json) {
  return _WorkflowAndroidConfig.fromJson(json);
}

/// @nodoc
mixin _$WorkflowAndroidConfig {
  String? get jks => throw _privateConstructorUsedError;
  String? get jksName => throw _privateConstructorUsedError;
  String? get keyProperties => throw _privateConstructorUsedError;
  String? get jksDirectory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowAndroidConfigCopyWith<WorkflowAndroidConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowAndroidConfigCopyWith<$Res> {
  factory $WorkflowAndroidConfigCopyWith(WorkflowAndroidConfig value,
          $Res Function(WorkflowAndroidConfig) then) =
      _$WorkflowAndroidConfigCopyWithImpl<$Res, WorkflowAndroidConfig>;
  @useResult
  $Res call(
      {String? jks,
      String? jksName,
      String? keyProperties,
      String? jksDirectory});
}

/// @nodoc
class _$WorkflowAndroidConfigCopyWithImpl<$Res,
        $Val extends WorkflowAndroidConfig>
    implements $WorkflowAndroidConfigCopyWith<$Res> {
  _$WorkflowAndroidConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jks = freezed,
    Object? jksName = freezed,
    Object? keyProperties = freezed,
    Object? jksDirectory = freezed,
  }) {
    return _then(_value.copyWith(
      jks: freezed == jks
          ? _value.jks
          : jks // ignore: cast_nullable_to_non_nullable
              as String?,
      jksName: freezed == jksName
          ? _value.jksName
          : jksName // ignore: cast_nullable_to_non_nullable
              as String?,
      keyProperties: freezed == keyProperties
          ? _value.keyProperties
          : keyProperties // ignore: cast_nullable_to_non_nullable
              as String?,
      jksDirectory: freezed == jksDirectory
          ? _value.jksDirectory
          : jksDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowAndroidConfigImplCopyWith<$Res>
    implements $WorkflowAndroidConfigCopyWith<$Res> {
  factory _$$WorkflowAndroidConfigImplCopyWith(
          _$WorkflowAndroidConfigImpl value,
          $Res Function(_$WorkflowAndroidConfigImpl) then) =
      __$$WorkflowAndroidConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? jks,
      String? jksName,
      String? keyProperties,
      String? jksDirectory});
}

/// @nodoc
class __$$WorkflowAndroidConfigImplCopyWithImpl<$Res>
    extends _$WorkflowAndroidConfigCopyWithImpl<$Res,
        _$WorkflowAndroidConfigImpl>
    implements _$$WorkflowAndroidConfigImplCopyWith<$Res> {
  __$$WorkflowAndroidConfigImplCopyWithImpl(_$WorkflowAndroidConfigImpl _value,
      $Res Function(_$WorkflowAndroidConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jks = freezed,
    Object? jksName = freezed,
    Object? keyProperties = freezed,
    Object? jksDirectory = freezed,
  }) {
    return _then(_$WorkflowAndroidConfigImpl(
      jks: freezed == jks
          ? _value.jks
          : jks // ignore: cast_nullable_to_non_nullable
              as String?,
      jksName: freezed == jksName
          ? _value.jksName
          : jksName // ignore: cast_nullable_to_non_nullable
              as String?,
      keyProperties: freezed == keyProperties
          ? _value.keyProperties
          : keyProperties // ignore: cast_nullable_to_non_nullable
              as String?,
      jksDirectory: freezed == jksDirectory
          ? _value.jksDirectory
          : jksDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowAndroidConfigImpl implements _WorkflowAndroidConfig {
  const _$WorkflowAndroidConfigImpl(
      {this.jks = null,
      this.jksName = null,
      this.keyProperties = null,
      this.jksDirectory});

  factory _$WorkflowAndroidConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowAndroidConfigImplFromJson(json);

  @override
  @JsonKey()
  final String? jks;
  @override
  @JsonKey()
  final String? jksName;
  @override
  @JsonKey()
  final String? keyProperties;
  @override
  final String? jksDirectory;

  @override
  String toString() {
    return 'WorkflowAndroidConfig(jks: $jks, jksName: $jksName, keyProperties: $keyProperties, jksDirectory: $jksDirectory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowAndroidConfigImpl &&
            (identical(other.jks, jks) || other.jks == jks) &&
            (identical(other.jksName, jksName) || other.jksName == jksName) &&
            (identical(other.keyProperties, keyProperties) ||
                other.keyProperties == keyProperties) &&
            (identical(other.jksDirectory, jksDirectory) ||
                other.jksDirectory == jksDirectory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, jks, jksName, keyProperties, jksDirectory);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowAndroidConfigImplCopyWith<_$WorkflowAndroidConfigImpl>
      get copyWith => __$$WorkflowAndroidConfigImplCopyWithImpl<
          _$WorkflowAndroidConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowAndroidConfigImplToJson(
      this,
    );
  }
}

abstract class _WorkflowAndroidConfig implements WorkflowAndroidConfig {
  const factory _WorkflowAndroidConfig(
      {final String? jks,
      final String? jksName,
      final String? keyProperties,
      final String? jksDirectory}) = _$WorkflowAndroidConfigImpl;

  factory _WorkflowAndroidConfig.fromJson(Map<String, dynamic> json) =
      _$WorkflowAndroidConfigImpl.fromJson;

  @override
  String? get jks;
  @override
  String? get jksName;
  @override
  String? get keyProperties;
  @override
  String? get jksDirectory;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowAndroidConfigImplCopyWith<_$WorkflowAndroidConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkflowShorebirdConfig _$WorkflowShorebirdConfigFromJson(
    Map<String, dynamic> json) {
  return _WorkflowShorebirdConfig.fromJson(json);
}

/// @nodoc
mixin _$WorkflowShorebirdConfig {
  String? get token => throw _privateConstructorUsedError;
  String? get yamlDownloadUrl => throw _privateConstructorUsedError;
  bool? get useShorebird => throw _privateConstructorUsedError;
  bool? get patch => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowShorebirdConfigCopyWith<WorkflowShorebirdConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowShorebirdConfigCopyWith<$Res> {
  factory $WorkflowShorebirdConfigCopyWith(WorkflowShorebirdConfig value,
          $Res Function(WorkflowShorebirdConfig) then) =
      _$WorkflowShorebirdConfigCopyWithImpl<$Res, WorkflowShorebirdConfig>;
  @useResult
  $Res call(
      {String? token,
      String? yamlDownloadUrl,
      bool? useShorebird,
      bool? patch});
}

/// @nodoc
class _$WorkflowShorebirdConfigCopyWithImpl<$Res,
        $Val extends WorkflowShorebirdConfig>
    implements $WorkflowShorebirdConfigCopyWith<$Res> {
  _$WorkflowShorebirdConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? yamlDownloadUrl = freezed,
    Object? useShorebird = freezed,
    Object? patch = freezed,
  }) {
    return _then(_value.copyWith(
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      yamlDownloadUrl: freezed == yamlDownloadUrl
          ? _value.yamlDownloadUrl
          : yamlDownloadUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      useShorebird: freezed == useShorebird
          ? _value.useShorebird
          : useShorebird // ignore: cast_nullable_to_non_nullable
              as bool?,
      patch: freezed == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowShorebirdConfigImplCopyWith<$Res>
    implements $WorkflowShorebirdConfigCopyWith<$Res> {
  factory _$$WorkflowShorebirdConfigImplCopyWith(
          _$WorkflowShorebirdConfigImpl value,
          $Res Function(_$WorkflowShorebirdConfigImpl) then) =
      __$$WorkflowShorebirdConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? token,
      String? yamlDownloadUrl,
      bool? useShorebird,
      bool? patch});
}

/// @nodoc
class __$$WorkflowShorebirdConfigImplCopyWithImpl<$Res>
    extends _$WorkflowShorebirdConfigCopyWithImpl<$Res,
        _$WorkflowShorebirdConfigImpl>
    implements _$$WorkflowShorebirdConfigImplCopyWith<$Res> {
  __$$WorkflowShorebirdConfigImplCopyWithImpl(
      _$WorkflowShorebirdConfigImpl _value,
      $Res Function(_$WorkflowShorebirdConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? yamlDownloadUrl = freezed,
    Object? useShorebird = freezed,
    Object? patch = freezed,
  }) {
    return _then(_$WorkflowShorebirdConfigImpl(
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      yamlDownloadUrl: freezed == yamlDownloadUrl
          ? _value.yamlDownloadUrl
          : yamlDownloadUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      useShorebird: freezed == useShorebird
          ? _value.useShorebird
          : useShorebird // ignore: cast_nullable_to_non_nullable
              as bool?,
      patch: freezed == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowShorebirdConfigImpl implements _WorkflowShorebirdConfig {
  const _$WorkflowShorebirdConfigImpl(
      {this.token = null,
      this.yamlDownloadUrl = null,
      this.useShorebird = null,
      this.patch = null});

  factory _$WorkflowShorebirdConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowShorebirdConfigImplFromJson(json);

  @override
  @JsonKey()
  final String? token;
  @override
  @JsonKey()
  final String? yamlDownloadUrl;
  @override
  @JsonKey()
  final bool? useShorebird;
  @override
  @JsonKey()
  final bool? patch;

  @override
  String toString() {
    return 'WorkflowShorebirdConfig(token: $token, yamlDownloadUrl: $yamlDownloadUrl, useShorebird: $useShorebird, patch: $patch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowShorebirdConfigImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.yamlDownloadUrl, yamlDownloadUrl) ||
                other.yamlDownloadUrl == yamlDownloadUrl) &&
            (identical(other.useShorebird, useShorebird) ||
                other.useShorebird == useShorebird) &&
            (identical(other.patch, patch) || other.patch == patch));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, token, yamlDownloadUrl, useShorebird, patch);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowShorebirdConfigImplCopyWith<_$WorkflowShorebirdConfigImpl>
      get copyWith => __$$WorkflowShorebirdConfigImplCopyWithImpl<
          _$WorkflowShorebirdConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowShorebirdConfigImplToJson(
      this,
    );
  }
}

abstract class _WorkflowShorebirdConfig implements WorkflowShorebirdConfig {
  const factory _WorkflowShorebirdConfig(
      {final String? token,
      final String? yamlDownloadUrl,
      final bool? useShorebird,
      final bool? patch}) = _$WorkflowShorebirdConfigImpl;

  factory _WorkflowShorebirdConfig.fromJson(Map<String, dynamic> json) =
      _$WorkflowShorebirdConfigImpl.fromJson;

  @override
  String? get token;
  @override
  String? get yamlDownloadUrl;
  @override
  bool? get useShorebird;
  @override
  bool? get patch;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowShorebirdConfigImplCopyWith<_$WorkflowShorebirdConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkflowFirebaseConfig _$WorkflowFirebaseConfigFromJson(
    Map<String, dynamic> json) {
  return _WorkflowFirebaseConfig.fromJson(json);
}

/// @nodoc
mixin _$WorkflowFirebaseConfig {
  AppDistributionConfig get appDistribution =>
      throw _privateConstructorUsedError;
  String? get appIdIos => throw _privateConstructorUsedError;
  String? get appIdAndroid => throw _privateConstructorUsedError;
  String? get serviceAccountJson => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowFirebaseConfigCopyWith<WorkflowFirebaseConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowFirebaseConfigCopyWith<$Res> {
  factory $WorkflowFirebaseConfigCopyWith(WorkflowFirebaseConfig value,
          $Res Function(WorkflowFirebaseConfig) then) =
      _$WorkflowFirebaseConfigCopyWithImpl<$Res, WorkflowFirebaseConfig>;
  @useResult
  $Res call(
      {AppDistributionConfig appDistribution,
      String? appIdIos,
      String? appIdAndroid,
      String? serviceAccountJson});

  $AppDistributionConfigCopyWith<$Res> get appDistribution;
}

/// @nodoc
class _$WorkflowFirebaseConfigCopyWithImpl<$Res,
        $Val extends WorkflowFirebaseConfig>
    implements $WorkflowFirebaseConfigCopyWith<$Res> {
  _$WorkflowFirebaseConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appDistribution = null,
    Object? appIdIos = freezed,
    Object? appIdAndroid = freezed,
    Object? serviceAccountJson = freezed,
  }) {
    return _then(_value.copyWith(
      appDistribution: null == appDistribution
          ? _value.appDistribution
          : appDistribution // ignore: cast_nullable_to_non_nullable
              as AppDistributionConfig,
      appIdIos: freezed == appIdIos
          ? _value.appIdIos
          : appIdIos // ignore: cast_nullable_to_non_nullable
              as String?,
      appIdAndroid: freezed == appIdAndroid
          ? _value.appIdAndroid
          : appIdAndroid // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceAccountJson: freezed == serviceAccountJson
          ? _value.serviceAccountJson
          : serviceAccountJson // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppDistributionConfigCopyWith<$Res> get appDistribution {
    return $AppDistributionConfigCopyWith<$Res>(_value.appDistribution,
        (value) {
      return _then(_value.copyWith(appDistribution: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkflowFirebaseConfigImplCopyWith<$Res>
    implements $WorkflowFirebaseConfigCopyWith<$Res> {
  factory _$$WorkflowFirebaseConfigImplCopyWith(
          _$WorkflowFirebaseConfigImpl value,
          $Res Function(_$WorkflowFirebaseConfigImpl) then) =
      __$$WorkflowFirebaseConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AppDistributionConfig appDistribution,
      String? appIdIos,
      String? appIdAndroid,
      String? serviceAccountJson});

  @override
  $AppDistributionConfigCopyWith<$Res> get appDistribution;
}

/// @nodoc
class __$$WorkflowFirebaseConfigImplCopyWithImpl<$Res>
    extends _$WorkflowFirebaseConfigCopyWithImpl<$Res,
        _$WorkflowFirebaseConfigImpl>
    implements _$$WorkflowFirebaseConfigImplCopyWith<$Res> {
  __$$WorkflowFirebaseConfigImplCopyWithImpl(
      _$WorkflowFirebaseConfigImpl _value,
      $Res Function(_$WorkflowFirebaseConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appDistribution = null,
    Object? appIdIos = freezed,
    Object? appIdAndroid = freezed,
    Object? serviceAccountJson = freezed,
  }) {
    return _then(_$WorkflowFirebaseConfigImpl(
      appDistribution: null == appDistribution
          ? _value.appDistribution
          : appDistribution // ignore: cast_nullable_to_non_nullable
              as AppDistributionConfig,
      appIdIos: freezed == appIdIos
          ? _value.appIdIos
          : appIdIos // ignore: cast_nullable_to_non_nullable
              as String?,
      appIdAndroid: freezed == appIdAndroid
          ? _value.appIdAndroid
          : appIdAndroid // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceAccountJson: freezed == serviceAccountJson
          ? _value.serviceAccountJson
          : serviceAccountJson // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowFirebaseConfigImpl implements _WorkflowFirebaseConfig {
  const _$WorkflowFirebaseConfigImpl(
      {required this.appDistribution,
      this.appIdIos = null,
      this.appIdAndroid = null,
      this.serviceAccountJson = null});

  factory _$WorkflowFirebaseConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowFirebaseConfigImplFromJson(json);

  @override
  final AppDistributionConfig appDistribution;
  @override
  @JsonKey()
  final String? appIdIos;
  @override
  @JsonKey()
  final String? appIdAndroid;
  @override
  @JsonKey()
  final String? serviceAccountJson;

  @override
  String toString() {
    return 'WorkflowFirebaseConfig(appDistribution: $appDistribution, appIdIos: $appIdIos, appIdAndroid: $appIdAndroid, serviceAccountJson: $serviceAccountJson)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowFirebaseConfigImpl &&
            (identical(other.appDistribution, appDistribution) ||
                other.appDistribution == appDistribution) &&
            (identical(other.appIdIos, appIdIos) ||
                other.appIdIos == appIdIos) &&
            (identical(other.appIdAndroid, appIdAndroid) ||
                other.appIdAndroid == appIdAndroid) &&
            (identical(other.serviceAccountJson, serviceAccountJson) ||
                other.serviceAccountJson == serviceAccountJson));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, appDistribution, appIdIos, appIdAndroid, serviceAccountJson);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowFirebaseConfigImplCopyWith<_$WorkflowFirebaseConfigImpl>
      get copyWith => __$$WorkflowFirebaseConfigImplCopyWithImpl<
          _$WorkflowFirebaseConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowFirebaseConfigImplToJson(
      this,
    );
  }
}

abstract class _WorkflowFirebaseConfig implements WorkflowFirebaseConfig {
  const factory _WorkflowFirebaseConfig(
      {required final AppDistributionConfig appDistribution,
      final String? appIdIos,
      final String? appIdAndroid,
      final String? serviceAccountJson}) = _$WorkflowFirebaseConfigImpl;

  factory _WorkflowFirebaseConfig.fromJson(Map<String, dynamic> json) =
      _$WorkflowFirebaseConfigImpl.fromJson;

  @override
  AppDistributionConfig get appDistribution;
  @override
  String? get appIdIos;
  @override
  String? get appIdAndroid;
  @override
  String? get serviceAccountJson;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowFirebaseConfigImplCopyWith<_$WorkflowFirebaseConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkflowIosConfig _$WorkflowIosConfigFromJson(Map<String, dynamic> json) {
  return _WorkflowIosConfig.fromJson(json);
}

/// @nodoc
mixin _$WorkflowIosConfig {
  String? get exportOptions => throw _privateConstructorUsedError;
  String? get p12 => throw _privateConstructorUsedError;
  WorkflowProvisioningProfileConfig? get provisioningProfile =>
      throw _privateConstructorUsedError;
  WorkflowAppStoreConnectAPI? get appStoreConnectAPI =>
      throw _privateConstructorUsedError;
  String? get teamId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowIosConfigCopyWith<WorkflowIosConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowIosConfigCopyWith<$Res> {
  factory $WorkflowIosConfigCopyWith(
          WorkflowIosConfig value, $Res Function(WorkflowIosConfig) then) =
      _$WorkflowIosConfigCopyWithImpl<$Res, WorkflowIosConfig>;
  @useResult
  $Res call(
      {String? exportOptions,
      String? p12,
      WorkflowProvisioningProfileConfig? provisioningProfile,
      WorkflowAppStoreConnectAPI? appStoreConnectAPI,
      String? teamId});

  $WorkflowProvisioningProfileConfigCopyWith<$Res>? get provisioningProfile;
  $WorkflowAppStoreConnectAPICopyWith<$Res>? get appStoreConnectAPI;
}

/// @nodoc
class _$WorkflowIosConfigCopyWithImpl<$Res, $Val extends WorkflowIosConfig>
    implements $WorkflowIosConfigCopyWith<$Res> {
  _$WorkflowIosConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exportOptions = freezed,
    Object? p12 = freezed,
    Object? provisioningProfile = freezed,
    Object? appStoreConnectAPI = freezed,
    Object? teamId = freezed,
  }) {
    return _then(_value.copyWith(
      exportOptions: freezed == exportOptions
          ? _value.exportOptions
          : exportOptions // ignore: cast_nullable_to_non_nullable
              as String?,
      p12: freezed == p12
          ? _value.p12
          : p12 // ignore: cast_nullable_to_non_nullable
              as String?,
      provisioningProfile: freezed == provisioningProfile
          ? _value.provisioningProfile
          : provisioningProfile // ignore: cast_nullable_to_non_nullable
              as WorkflowProvisioningProfileConfig?,
      appStoreConnectAPI: freezed == appStoreConnectAPI
          ? _value.appStoreConnectAPI
          : appStoreConnectAPI // ignore: cast_nullable_to_non_nullable
              as WorkflowAppStoreConnectAPI?,
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowProvisioningProfileConfigCopyWith<$Res>? get provisioningProfile {
    if (_value.provisioningProfile == null) {
      return null;
    }

    return $WorkflowProvisioningProfileConfigCopyWith<$Res>(
        _value.provisioningProfile!, (value) {
      return _then(_value.copyWith(provisioningProfile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WorkflowAppStoreConnectAPICopyWith<$Res>? get appStoreConnectAPI {
    if (_value.appStoreConnectAPI == null) {
      return null;
    }

    return $WorkflowAppStoreConnectAPICopyWith<$Res>(_value.appStoreConnectAPI!,
        (value) {
      return _then(_value.copyWith(appStoreConnectAPI: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkflowIosConfigImplCopyWith<$Res>
    implements $WorkflowIosConfigCopyWith<$Res> {
  factory _$$WorkflowIosConfigImplCopyWith(_$WorkflowIosConfigImpl value,
          $Res Function(_$WorkflowIosConfigImpl) then) =
      __$$WorkflowIosConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? exportOptions,
      String? p12,
      WorkflowProvisioningProfileConfig? provisioningProfile,
      WorkflowAppStoreConnectAPI? appStoreConnectAPI,
      String? teamId});

  @override
  $WorkflowProvisioningProfileConfigCopyWith<$Res>? get provisioningProfile;
  @override
  $WorkflowAppStoreConnectAPICopyWith<$Res>? get appStoreConnectAPI;
}

/// @nodoc
class __$$WorkflowIosConfigImplCopyWithImpl<$Res>
    extends _$WorkflowIosConfigCopyWithImpl<$Res, _$WorkflowIosConfigImpl>
    implements _$$WorkflowIosConfigImplCopyWith<$Res> {
  __$$WorkflowIosConfigImplCopyWithImpl(_$WorkflowIosConfigImpl _value,
      $Res Function(_$WorkflowIosConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exportOptions = freezed,
    Object? p12 = freezed,
    Object? provisioningProfile = freezed,
    Object? appStoreConnectAPI = freezed,
    Object? teamId = freezed,
  }) {
    return _then(_$WorkflowIosConfigImpl(
      exportOptions: freezed == exportOptions
          ? _value.exportOptions
          : exportOptions // ignore: cast_nullable_to_non_nullable
              as String?,
      p12: freezed == p12
          ? _value.p12
          : p12 // ignore: cast_nullable_to_non_nullable
              as String?,
      provisioningProfile: freezed == provisioningProfile
          ? _value.provisioningProfile
          : provisioningProfile // ignore: cast_nullable_to_non_nullable
              as WorkflowProvisioningProfileConfig?,
      appStoreConnectAPI: freezed == appStoreConnectAPI
          ? _value.appStoreConnectAPI
          : appStoreConnectAPI // ignore: cast_nullable_to_non_nullable
              as WorkflowAppStoreConnectAPI?,
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowIosConfigImpl implements _WorkflowIosConfig {
  const _$WorkflowIosConfigImpl(
      {this.exportOptions = null,
      this.p12 = null,
      this.provisioningProfile = null,
      this.appStoreConnectAPI = null,
      this.teamId = null});

  factory _$WorkflowIosConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowIosConfigImplFromJson(json);

  @override
  @JsonKey()
  final String? exportOptions;
  @override
  @JsonKey()
  final String? p12;
  @override
  @JsonKey()
  final WorkflowProvisioningProfileConfig? provisioningProfile;
  @override
  @JsonKey()
  final WorkflowAppStoreConnectAPI? appStoreConnectAPI;
  @override
  @JsonKey()
  final String? teamId;

  @override
  String toString() {
    return 'WorkflowIosConfig(exportOptions: $exportOptions, p12: $p12, provisioningProfile: $provisioningProfile, appStoreConnectAPI: $appStoreConnectAPI, teamId: $teamId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowIosConfigImpl &&
            (identical(other.exportOptions, exportOptions) ||
                other.exportOptions == exportOptions) &&
            (identical(other.p12, p12) || other.p12 == p12) &&
            (identical(other.provisioningProfile, provisioningProfile) ||
                other.provisioningProfile == provisioningProfile) &&
            (identical(other.appStoreConnectAPI, appStoreConnectAPI) ||
                other.appStoreConnectAPI == appStoreConnectAPI) &&
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, exportOptions, p12,
      provisioningProfile, appStoreConnectAPI, teamId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowIosConfigImplCopyWith<_$WorkflowIosConfigImpl> get copyWith =>
      __$$WorkflowIosConfigImplCopyWithImpl<_$WorkflowIosConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowIosConfigImplToJson(
      this,
    );
  }
}

abstract class _WorkflowIosConfig implements WorkflowIosConfig {
  const factory _WorkflowIosConfig(
      {final String? exportOptions,
      final String? p12,
      final WorkflowProvisioningProfileConfig? provisioningProfile,
      final WorkflowAppStoreConnectAPI? appStoreConnectAPI,
      final String? teamId}) = _$WorkflowIosConfigImpl;

  factory _WorkflowIosConfig.fromJson(Map<String, dynamic> json) =
      _$WorkflowIosConfigImpl.fromJson;

  @override
  String? get exportOptions;
  @override
  String? get p12;
  @override
  WorkflowProvisioningProfileConfig? get provisioningProfile;
  @override
  WorkflowAppStoreConnectAPI? get appStoreConnectAPI;
  @override
  String? get teamId;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowIosConfigImplCopyWith<_$WorkflowIosConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkflowAppStoreConnectAPI _$WorkflowAppStoreConnectAPIFromJson(
    Map<String, dynamic> json) {
  return _WorkflowAppStoreConnectAPI.fromJson(json);
}

/// @nodoc
mixin _$WorkflowAppStoreConnectAPI {
  String? get p8 => throw _privateConstructorUsedError;
  String? get keyId => throw _privateConstructorUsedError;
  String? get issuerId => throw _privateConstructorUsedError;
  String? get appId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowAppStoreConnectAPICopyWith<WorkflowAppStoreConnectAPI>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowAppStoreConnectAPICopyWith<$Res> {
  factory $WorkflowAppStoreConnectAPICopyWith(WorkflowAppStoreConnectAPI value,
          $Res Function(WorkflowAppStoreConnectAPI) then) =
      _$WorkflowAppStoreConnectAPICopyWithImpl<$Res,
          WorkflowAppStoreConnectAPI>;
  @useResult
  $Res call({String? p8, String? keyId, String? issuerId, String? appId});
}

/// @nodoc
class _$WorkflowAppStoreConnectAPICopyWithImpl<$Res,
        $Val extends WorkflowAppStoreConnectAPI>
    implements $WorkflowAppStoreConnectAPICopyWith<$Res> {
  _$WorkflowAppStoreConnectAPICopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? p8 = freezed,
    Object? keyId = freezed,
    Object? issuerId = freezed,
    Object? appId = freezed,
  }) {
    return _then(_value.copyWith(
      p8: freezed == p8
          ? _value.p8
          : p8 // ignore: cast_nullable_to_non_nullable
              as String?,
      keyId: freezed == keyId
          ? _value.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
              as String?,
      issuerId: freezed == issuerId
          ? _value.issuerId
          : issuerId // ignore: cast_nullable_to_non_nullable
              as String?,
      appId: freezed == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowAppStoreConnectAPIImplCopyWith<$Res>
    implements $WorkflowAppStoreConnectAPICopyWith<$Res> {
  factory _$$WorkflowAppStoreConnectAPIImplCopyWith(
          _$WorkflowAppStoreConnectAPIImpl value,
          $Res Function(_$WorkflowAppStoreConnectAPIImpl) then) =
      __$$WorkflowAppStoreConnectAPIImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? p8, String? keyId, String? issuerId, String? appId});
}

/// @nodoc
class __$$WorkflowAppStoreConnectAPIImplCopyWithImpl<$Res>
    extends _$WorkflowAppStoreConnectAPICopyWithImpl<$Res,
        _$WorkflowAppStoreConnectAPIImpl>
    implements _$$WorkflowAppStoreConnectAPIImplCopyWith<$Res> {
  __$$WorkflowAppStoreConnectAPIImplCopyWithImpl(
      _$WorkflowAppStoreConnectAPIImpl _value,
      $Res Function(_$WorkflowAppStoreConnectAPIImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? p8 = freezed,
    Object? keyId = freezed,
    Object? issuerId = freezed,
    Object? appId = freezed,
  }) {
    return _then(_$WorkflowAppStoreConnectAPIImpl(
      p8: freezed == p8
          ? _value.p8
          : p8 // ignore: cast_nullable_to_non_nullable
              as String?,
      keyId: freezed == keyId
          ? _value.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
              as String?,
      issuerId: freezed == issuerId
          ? _value.issuerId
          : issuerId // ignore: cast_nullable_to_non_nullable
              as String?,
      appId: freezed == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowAppStoreConnectAPIImpl implements _WorkflowAppStoreConnectAPI {
  const _$WorkflowAppStoreConnectAPIImpl(
      {this.p8 = null,
      this.keyId = null,
      this.issuerId = null,
      this.appId = null});

  factory _$WorkflowAppStoreConnectAPIImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WorkflowAppStoreConnectAPIImplFromJson(json);

  @override
  @JsonKey()
  final String? p8;
  @override
  @JsonKey()
  final String? keyId;
  @override
  @JsonKey()
  final String? issuerId;
  @override
  @JsonKey()
  final String? appId;

  @override
  String toString() {
    return 'WorkflowAppStoreConnectAPI(p8: $p8, keyId: $keyId, issuerId: $issuerId, appId: $appId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowAppStoreConnectAPIImpl &&
            (identical(other.p8, p8) || other.p8 == p8) &&
            (identical(other.keyId, keyId) || other.keyId == keyId) &&
            (identical(other.issuerId, issuerId) ||
                other.issuerId == issuerId) &&
            (identical(other.appId, appId) || other.appId == appId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, p8, keyId, issuerId, appId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowAppStoreConnectAPIImplCopyWith<_$WorkflowAppStoreConnectAPIImpl>
      get copyWith => __$$WorkflowAppStoreConnectAPIImplCopyWithImpl<
          _$WorkflowAppStoreConnectAPIImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowAppStoreConnectAPIImplToJson(
      this,
    );
  }
}

abstract class _WorkflowAppStoreConnectAPI
    implements WorkflowAppStoreConnectAPI {
  const factory _WorkflowAppStoreConnectAPI(
      {final String? p8,
      final String? keyId,
      final String? issuerId,
      final String? appId}) = _$WorkflowAppStoreConnectAPIImpl;

  factory _WorkflowAppStoreConnectAPI.fromJson(Map<String, dynamic> json) =
      _$WorkflowAppStoreConnectAPIImpl.fromJson;

  @override
  String? get p8;
  @override
  String? get keyId;
  @override
  String? get issuerId;
  @override
  String? get appId;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowAppStoreConnectAPIImplCopyWith<_$WorkflowAppStoreConnectAPIImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkflowProvisioningProfileConfig _$WorkflowProvisioningProfileConfigFromJson(
    Map<String, dynamic> json) {
  return _WorkflowProvisioningProfileConfig.fromJson(json);
}

/// @nodoc
mixin _$WorkflowProvisioningProfileConfig {
  String? get url => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowProvisioningProfileConfigCopyWith<WorkflowProvisioningProfileConfig>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowProvisioningProfileConfigCopyWith<$Res> {
  factory $WorkflowProvisioningProfileConfigCopyWith(
          WorkflowProvisioningProfileConfig value,
          $Res Function(WorkflowProvisioningProfileConfig) then) =
      _$WorkflowProvisioningProfileConfigCopyWithImpl<$Res,
          WorkflowProvisioningProfileConfig>;
  @useResult
  $Res call({String? url, String? name});
}

/// @nodoc
class _$WorkflowProvisioningProfileConfigCopyWithImpl<$Res,
        $Val extends WorkflowProvisioningProfileConfig>
    implements $WorkflowProvisioningProfileConfigCopyWith<$Res> {
  _$WorkflowProvisioningProfileConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowProvisioningProfileConfigImplCopyWith<$Res>
    implements $WorkflowProvisioningProfileConfigCopyWith<$Res> {
  factory _$$WorkflowProvisioningProfileConfigImplCopyWith(
          _$WorkflowProvisioningProfileConfigImpl value,
          $Res Function(_$WorkflowProvisioningProfileConfigImpl) then) =
      __$$WorkflowProvisioningProfileConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, String? name});
}

/// @nodoc
class __$$WorkflowProvisioningProfileConfigImplCopyWithImpl<$Res>
    extends _$WorkflowProvisioningProfileConfigCopyWithImpl<$Res,
        _$WorkflowProvisioningProfileConfigImpl>
    implements _$$WorkflowProvisioningProfileConfigImplCopyWith<$Res> {
  __$$WorkflowProvisioningProfileConfigImplCopyWithImpl(
      _$WorkflowProvisioningProfileConfigImpl _value,
      $Res Function(_$WorkflowProvisioningProfileConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? name = freezed,
  }) {
    return _then(_$WorkflowProvisioningProfileConfigImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowProvisioningProfileConfigImpl
    implements _WorkflowProvisioningProfileConfig {
  const _$WorkflowProvisioningProfileConfigImpl(
      {this.url = null, this.name = null});

  factory _$WorkflowProvisioningProfileConfigImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WorkflowProvisioningProfileConfigImplFromJson(json);

  @override
  @JsonKey()
  final String? url;
  @override
  @JsonKey()
  final String? name;

  @override
  String toString() {
    return 'WorkflowProvisioningProfileConfig(url: $url, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowProvisioningProfileConfigImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, url, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowProvisioningProfileConfigImplCopyWith<
          _$WorkflowProvisioningProfileConfigImpl>
      get copyWith => __$$WorkflowProvisioningProfileConfigImplCopyWithImpl<
          _$WorkflowProvisioningProfileConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowProvisioningProfileConfigImplToJson(
      this,
    );
  }
}

abstract class _WorkflowProvisioningProfileConfig
    implements WorkflowProvisioningProfileConfig {
  const factory _WorkflowProvisioningProfileConfig(
      {final String? url,
      final String? name}) = _$WorkflowProvisioningProfileConfigImpl;

  factory _WorkflowProvisioningProfileConfig.fromJson(
          Map<String, dynamic> json) =
      _$WorkflowProvisioningProfileConfigImpl.fromJson;

  @override
  String? get url;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowProvisioningProfileConfigImplCopyWith<
          _$WorkflowProvisioningProfileConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkflowFlutterConfig _$WorkflowFlutterConfigFromJson(
    Map<String, dynamic> json) {
  return _WorkflowFlutterConfig.fromJson(json);
}

/// @nodoc
mixin _$WorkflowFlutterConfig {
  String get flavor => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String? get entryPoint => throw _privateConstructorUsedError;
  List<String>? get dartDefine => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkflowFlutterConfigCopyWith<WorkflowFlutterConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkflowFlutterConfigCopyWith<$Res> {
  factory $WorkflowFlutterConfigCopyWith(WorkflowFlutterConfig value,
          $Res Function(WorkflowFlutterConfig) then) =
      _$WorkflowFlutterConfigCopyWithImpl<$Res, WorkflowFlutterConfig>;
  @useResult
  $Res call(
      {String flavor,
      String version,
      String? entryPoint,
      List<String>? dartDefine});
}

/// @nodoc
class _$WorkflowFlutterConfigCopyWithImpl<$Res,
        $Val extends WorkflowFlutterConfig>
    implements $WorkflowFlutterConfigCopyWith<$Res> {
  _$WorkflowFlutterConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flavor = null,
    Object? version = null,
    Object? entryPoint = freezed,
    Object? dartDefine = freezed,
  }) {
    return _then(_value.copyWith(
      flavor: null == flavor
          ? _value.flavor
          : flavor // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      entryPoint: freezed == entryPoint
          ? _value.entryPoint
          : entryPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      dartDefine: freezed == dartDefine
          ? _value.dartDefine
          : dartDefine // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkflowFlutterConfigImplCopyWith<$Res>
    implements $WorkflowFlutterConfigCopyWith<$Res> {
  factory _$$WorkflowFlutterConfigImplCopyWith(
          _$WorkflowFlutterConfigImpl value,
          $Res Function(_$WorkflowFlutterConfigImpl) then) =
      __$$WorkflowFlutterConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String flavor,
      String version,
      String? entryPoint,
      List<String>? dartDefine});
}

/// @nodoc
class __$$WorkflowFlutterConfigImplCopyWithImpl<$Res>
    extends _$WorkflowFlutterConfigCopyWithImpl<$Res,
        _$WorkflowFlutterConfigImpl>
    implements _$$WorkflowFlutterConfigImplCopyWith<$Res> {
  __$$WorkflowFlutterConfigImplCopyWithImpl(_$WorkflowFlutterConfigImpl _value,
      $Res Function(_$WorkflowFlutterConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flavor = null,
    Object? version = null,
    Object? entryPoint = freezed,
    Object? dartDefine = freezed,
  }) {
    return _then(_$WorkflowFlutterConfigImpl(
      flavor: null == flavor
          ? _value.flavor
          : flavor // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      entryPoint: freezed == entryPoint
          ? _value.entryPoint
          : entryPoint // ignore: cast_nullable_to_non_nullable
              as String?,
      dartDefine: freezed == dartDefine
          ? _value._dartDefine
          : dartDefine // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkflowFlutterConfigImpl implements _WorkflowFlutterConfig {
  const _$WorkflowFlutterConfigImpl(
      {required this.flavor,
      required this.version,
      this.entryPoint,
      final List<String>? dartDefine = null})
      : _dartDefine = dartDefine;

  factory _$WorkflowFlutterConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkflowFlutterConfigImplFromJson(json);

  @override
  final String flavor;
  @override
  final String version;
  @override
  final String? entryPoint;
  final List<String>? _dartDefine;
  @override
  @JsonKey()
  List<String>? get dartDefine {
    final value = _dartDefine;
    if (value == null) return null;
    if (_dartDefine is EqualUnmodifiableListView) return _dartDefine;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WorkflowFlutterConfig(flavor: $flavor, version: $version, entryPoint: $entryPoint, dartDefine: $dartDefine)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkflowFlutterConfigImpl &&
            (identical(other.flavor, flavor) || other.flavor == flavor) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.entryPoint, entryPoint) ||
                other.entryPoint == entryPoint) &&
            const DeepCollectionEquality()
                .equals(other._dartDefine, _dartDefine));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, flavor, version, entryPoint,
      const DeepCollectionEquality().hash(_dartDefine));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkflowFlutterConfigImplCopyWith<_$WorkflowFlutterConfigImpl>
      get copyWith => __$$WorkflowFlutterConfigImplCopyWithImpl<
          _$WorkflowFlutterConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkflowFlutterConfigImplToJson(
      this,
    );
  }
}

abstract class _WorkflowFlutterConfig implements WorkflowFlutterConfig {
  const factory _WorkflowFlutterConfig(
      {required final String flavor,
      required final String version,
      final String? entryPoint,
      final List<String>? dartDefine}) = _$WorkflowFlutterConfigImpl;

  factory _WorkflowFlutterConfig.fromJson(Map<String, dynamic> json) =
      _$WorkflowFlutterConfigImpl.fromJson;

  @override
  String get flavor;
  @override
  String get version;
  @override
  String? get entryPoint;
  @override
  List<String>? get dartDefine;
  @override
  @JsonKey(ignore: true)
  _$$WorkflowFlutterConfigImplCopyWith<_$WorkflowFlutterConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AppDistributionConfig _$AppDistributionConfigFromJson(
    Map<String, dynamic> json) {
  return _AppDistributionConfig.fromJson(json);
}

/// @nodoc
mixin _$AppDistributionConfig {
  List<String>? get testerGroups => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppDistributionConfigCopyWith<AppDistributionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDistributionConfigCopyWith<$Res> {
  factory $AppDistributionConfigCopyWith(AppDistributionConfig value,
          $Res Function(AppDistributionConfig) then) =
      _$AppDistributionConfigCopyWithImpl<$Res, AppDistributionConfig>;
  @useResult
  $Res call({List<String>? testerGroups});
}

/// @nodoc
class _$AppDistributionConfigCopyWithImpl<$Res,
        $Val extends AppDistributionConfig>
    implements $AppDistributionConfigCopyWith<$Res> {
  _$AppDistributionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testerGroups = freezed,
  }) {
    return _then(_value.copyWith(
      testerGroups: freezed == testerGroups
          ? _value.testerGroups
          : testerGroups // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppDistributionConfigImplCopyWith<$Res>
    implements $AppDistributionConfigCopyWith<$Res> {
  factory _$$AppDistributionConfigImplCopyWith(
          _$AppDistributionConfigImpl value,
          $Res Function(_$AppDistributionConfigImpl) then) =
      __$$AppDistributionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String>? testerGroups});
}

/// @nodoc
class __$$AppDistributionConfigImplCopyWithImpl<$Res>
    extends _$AppDistributionConfigCopyWithImpl<$Res,
        _$AppDistributionConfigImpl>
    implements _$$AppDistributionConfigImplCopyWith<$Res> {
  __$$AppDistributionConfigImplCopyWithImpl(_$AppDistributionConfigImpl _value,
      $Res Function(_$AppDistributionConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testerGroups = freezed,
  }) {
    return _then(_$AppDistributionConfigImpl(
      testerGroups: freezed == testerGroups
          ? _value._testerGroups
          : testerGroups // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppDistributionConfigImpl implements _AppDistributionConfig {
  const _$AppDistributionConfigImpl({final List<String>? testerGroups = null})
      : _testerGroups = testerGroups;

  factory _$AppDistributionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppDistributionConfigImplFromJson(json);

  final List<String>? _testerGroups;
  @override
  @JsonKey()
  List<String>? get testerGroups {
    final value = _testerGroups;
    if (value == null) return null;
    if (_testerGroups is EqualUnmodifiableListView) return _testerGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AppDistributionConfig(testerGroups: $testerGroups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDistributionConfigImpl &&
            const DeepCollectionEquality()
                .equals(other._testerGroups, _testerGroups));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_testerGroups));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDistributionConfigImplCopyWith<_$AppDistributionConfigImpl>
      get copyWith => __$$AppDistributionConfigImplCopyWithImpl<
          _$AppDistributionConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppDistributionConfigImplToJson(
      this,
    );
  }
}

abstract class _AppDistributionConfig implements AppDistributionConfig {
  const factory _AppDistributionConfig({final List<String>? testerGroups}) =
      _$AppDistributionConfigImpl;

  factory _AppDistributionConfig.fromJson(Map<String, dynamic> json) =
      _$AppDistributionConfigImpl.fromJson;

  @override
  List<String>? get testerGroups;
  @override
  @JsonKey(ignore: true)
  _$$AppDistributionConfigImplCopyWith<_$AppDistributionConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}
