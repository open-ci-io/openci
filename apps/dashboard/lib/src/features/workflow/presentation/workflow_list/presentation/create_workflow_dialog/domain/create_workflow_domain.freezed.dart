// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_workflow_domain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateWorkflowDomain {
  OpenCIWorkflowTemplate get template;
  bool? get isASCKeyUploaded;
  bool get isLoading;
  AppStoreConnectKey get ascKey;
  FlutterBuildIpaData get flutterBuildIpaData;
  OpenCIAppDistributionTarget get appDistributionTarget;
  String get selectedRepository;

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateWorkflowDomainCopyWith<CreateWorkflowDomain> get copyWith =>
      _$CreateWorkflowDomainCopyWithImpl<CreateWorkflowDomain>(
          this as CreateWorkflowDomain, _$identity);

  /// Serializes this CreateWorkflowDomain to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateWorkflowDomain &&
            (identical(other.template, template) ||
                other.template == template) &&
            (identical(other.isASCKeyUploaded, isASCKeyUploaded) ||
                other.isASCKeyUploaded == isASCKeyUploaded) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.ascKey, ascKey) || other.ascKey == ascKey) &&
            (identical(other.flutterBuildIpaData, flutterBuildIpaData) ||
                other.flutterBuildIpaData == flutterBuildIpaData) &&
            (identical(other.appDistributionTarget, appDistributionTarget) ||
                other.appDistributionTarget == appDistributionTarget) &&
            (identical(other.selectedRepository, selectedRepository) ||
                other.selectedRepository == selectedRepository));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      template,
      isASCKeyUploaded,
      isLoading,
      ascKey,
      flutterBuildIpaData,
      appDistributionTarget,
      selectedRepository);

  @override
  String toString() {
    return 'CreateWorkflowDomain(template: $template, isASCKeyUploaded: $isASCKeyUploaded, isLoading: $isLoading, ascKey: $ascKey, flutterBuildIpaData: $flutterBuildIpaData, appDistributionTarget: $appDistributionTarget, selectedRepository: $selectedRepository)';
  }
}

/// @nodoc
abstract mixin class $CreateWorkflowDomainCopyWith<$Res> {
  factory $CreateWorkflowDomainCopyWith(CreateWorkflowDomain value,
          $Res Function(CreateWorkflowDomain) _then) =
      _$CreateWorkflowDomainCopyWithImpl;
  @useResult
  $Res call(
      {OpenCIWorkflowTemplate template,
      bool? isASCKeyUploaded,
      bool isLoading,
      AppStoreConnectKey ascKey,
      FlutterBuildIpaData flutterBuildIpaData,
      OpenCIAppDistributionTarget appDistributionTarget,
      String selectedRepository});

  $AppStoreConnectKeyCopyWith<$Res> get ascKey;
  $FlutterBuildIpaDataCopyWith<$Res> get flutterBuildIpaData;
}

/// @nodoc
class _$CreateWorkflowDomainCopyWithImpl<$Res>
    implements $CreateWorkflowDomainCopyWith<$Res> {
  _$CreateWorkflowDomainCopyWithImpl(this._self, this._then);

  final CreateWorkflowDomain _self;
  final $Res Function(CreateWorkflowDomain) _then;

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? template = null,
    Object? isASCKeyUploaded = freezed,
    Object? isLoading = null,
    Object? ascKey = null,
    Object? flutterBuildIpaData = null,
    Object? appDistributionTarget = null,
    Object? selectedRepository = null,
  }) {
    return _then(_self.copyWith(
      template: null == template
          ? _self.template
          : template // ignore: cast_nullable_to_non_nullable
              as OpenCIWorkflowTemplate,
      isASCKeyUploaded: freezed == isASCKeyUploaded
          ? _self.isASCKeyUploaded
          : isASCKeyUploaded // ignore: cast_nullable_to_non_nullable
              as bool?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      ascKey: null == ascKey
          ? _self.ascKey
          : ascKey // ignore: cast_nullable_to_non_nullable
              as AppStoreConnectKey,
      flutterBuildIpaData: null == flutterBuildIpaData
          ? _self.flutterBuildIpaData
          : flutterBuildIpaData // ignore: cast_nullable_to_non_nullable
              as FlutterBuildIpaData,
      appDistributionTarget: null == appDistributionTarget
          ? _self.appDistributionTarget
          : appDistributionTarget // ignore: cast_nullable_to_non_nullable
              as OpenCIAppDistributionTarget,
      selectedRepository: null == selectedRepository
          ? _self.selectedRepository
          : selectedRepository // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppStoreConnectKeyCopyWith<$Res> get ascKey {
    return $AppStoreConnectKeyCopyWith<$Res>(_self.ascKey, (value) {
      return _then(_self.copyWith(ascKey: value));
    });
  }

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlutterBuildIpaDataCopyWith<$Res> get flutterBuildIpaData {
    return $FlutterBuildIpaDataCopyWith<$Res>(_self.flutterBuildIpaData,
        (value) {
      return _then(_self.copyWith(flutterBuildIpaData: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CreateWorkflowDomain implements CreateWorkflowDomain {
  const _CreateWorkflowDomain(
      {this.template = OpenCIWorkflowTemplate.ipa,
      this.isASCKeyUploaded = null,
      this.isLoading = false,
      this.ascKey = const AppStoreConnectKey(),
      this.flutterBuildIpaData = const FlutterBuildIpaData(),
      this.appDistributionTarget = OpenCIAppDistributionTarget.none,
      required this.selectedRepository});
  factory _CreateWorkflowDomain.fromJson(Map<String, dynamic> json) =>
      _$CreateWorkflowDomainFromJson(json);

  @override
  @JsonKey()
  final OpenCIWorkflowTemplate template;
  @override
  @JsonKey()
  final bool? isASCKeyUploaded;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final AppStoreConnectKey ascKey;
  @override
  @JsonKey()
  final FlutterBuildIpaData flutterBuildIpaData;
  @override
  @JsonKey()
  final OpenCIAppDistributionTarget appDistributionTarget;
  @override
  final String selectedRepository;

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateWorkflowDomainCopyWith<_CreateWorkflowDomain> get copyWith =>
      __$CreateWorkflowDomainCopyWithImpl<_CreateWorkflowDomain>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateWorkflowDomainToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateWorkflowDomain &&
            (identical(other.template, template) ||
                other.template == template) &&
            (identical(other.isASCKeyUploaded, isASCKeyUploaded) ||
                other.isASCKeyUploaded == isASCKeyUploaded) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.ascKey, ascKey) || other.ascKey == ascKey) &&
            (identical(other.flutterBuildIpaData, flutterBuildIpaData) ||
                other.flutterBuildIpaData == flutterBuildIpaData) &&
            (identical(other.appDistributionTarget, appDistributionTarget) ||
                other.appDistributionTarget == appDistributionTarget) &&
            (identical(other.selectedRepository, selectedRepository) ||
                other.selectedRepository == selectedRepository));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      template,
      isASCKeyUploaded,
      isLoading,
      ascKey,
      flutterBuildIpaData,
      appDistributionTarget,
      selectedRepository);

  @override
  String toString() {
    return 'CreateWorkflowDomain(template: $template, isASCKeyUploaded: $isASCKeyUploaded, isLoading: $isLoading, ascKey: $ascKey, flutterBuildIpaData: $flutterBuildIpaData, appDistributionTarget: $appDistributionTarget, selectedRepository: $selectedRepository)';
  }
}

/// @nodoc
abstract mixin class _$CreateWorkflowDomainCopyWith<$Res>
    implements $CreateWorkflowDomainCopyWith<$Res> {
  factory _$CreateWorkflowDomainCopyWith(_CreateWorkflowDomain value,
          $Res Function(_CreateWorkflowDomain) _then) =
      __$CreateWorkflowDomainCopyWithImpl;
  @override
  @useResult
  $Res call(
      {OpenCIWorkflowTemplate template,
      bool? isASCKeyUploaded,
      bool isLoading,
      AppStoreConnectKey ascKey,
      FlutterBuildIpaData flutterBuildIpaData,
      OpenCIAppDistributionTarget appDistributionTarget,
      String selectedRepository});

  @override
  $AppStoreConnectKeyCopyWith<$Res> get ascKey;
  @override
  $FlutterBuildIpaDataCopyWith<$Res> get flutterBuildIpaData;
}

/// @nodoc
class __$CreateWorkflowDomainCopyWithImpl<$Res>
    implements _$CreateWorkflowDomainCopyWith<$Res> {
  __$CreateWorkflowDomainCopyWithImpl(this._self, this._then);

  final _CreateWorkflowDomain _self;
  final $Res Function(_CreateWorkflowDomain) _then;

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? template = null,
    Object? isASCKeyUploaded = freezed,
    Object? isLoading = null,
    Object? ascKey = null,
    Object? flutterBuildIpaData = null,
    Object? appDistributionTarget = null,
    Object? selectedRepository = null,
  }) {
    return _then(_CreateWorkflowDomain(
      template: null == template
          ? _self.template
          : template // ignore: cast_nullable_to_non_nullable
              as OpenCIWorkflowTemplate,
      isASCKeyUploaded: freezed == isASCKeyUploaded
          ? _self.isASCKeyUploaded
          : isASCKeyUploaded // ignore: cast_nullable_to_non_nullable
              as bool?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      ascKey: null == ascKey
          ? _self.ascKey
          : ascKey // ignore: cast_nullable_to_non_nullable
              as AppStoreConnectKey,
      flutterBuildIpaData: null == flutterBuildIpaData
          ? _self.flutterBuildIpaData
          : flutterBuildIpaData // ignore: cast_nullable_to_non_nullable
              as FlutterBuildIpaData,
      appDistributionTarget: null == appDistributionTarget
          ? _self.appDistributionTarget
          : appDistributionTarget // ignore: cast_nullable_to_non_nullable
              as OpenCIAppDistributionTarget,
      selectedRepository: null == selectedRepository
          ? _self.selectedRepository
          : selectedRepository // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppStoreConnectKeyCopyWith<$Res> get ascKey {
    return $AppStoreConnectKeyCopyWith<$Res>(_self.ascKey, (value) {
      return _then(_self.copyWith(ascKey: value));
    });
  }

  /// Create a copy of CreateWorkflowDomain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlutterBuildIpaDataCopyWith<$Res> get flutterBuildIpaData {
    return $FlutterBuildIpaDataCopyWith<$Res>(_self.flutterBuildIpaData,
        (value) {
      return _then(_self.copyWith(flutterBuildIpaData: value));
    });
  }
}

/// @nodoc
mixin _$AppStoreConnectKey {
  String? get issuerId;
  String? get keyId;
  String? get keyFileBase64;

  /// Create a copy of AppStoreConnectKey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppStoreConnectKeyCopyWith<AppStoreConnectKey> get copyWith =>
      _$AppStoreConnectKeyCopyWithImpl<AppStoreConnectKey>(
          this as AppStoreConnectKey, _$identity);

  /// Serializes this AppStoreConnectKey to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppStoreConnectKey &&
            (identical(other.issuerId, issuerId) ||
                other.issuerId == issuerId) &&
            (identical(other.keyId, keyId) || other.keyId == keyId) &&
            (identical(other.keyFileBase64, keyFileBase64) ||
                other.keyFileBase64 == keyFileBase64));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, issuerId, keyId, keyFileBase64);

  @override
  String toString() {
    return 'AppStoreConnectKey(issuerId: $issuerId, keyId: $keyId, keyFileBase64: $keyFileBase64)';
  }
}

/// @nodoc
abstract mixin class $AppStoreConnectKeyCopyWith<$Res> {
  factory $AppStoreConnectKeyCopyWith(
          AppStoreConnectKey value, $Res Function(AppStoreConnectKey) _then) =
      _$AppStoreConnectKeyCopyWithImpl;
  @useResult
  $Res call({String? issuerId, String? keyId, String? keyFileBase64});
}

/// @nodoc
class _$AppStoreConnectKeyCopyWithImpl<$Res>
    implements $AppStoreConnectKeyCopyWith<$Res> {
  _$AppStoreConnectKeyCopyWithImpl(this._self, this._then);

  final AppStoreConnectKey _self;
  final $Res Function(AppStoreConnectKey) _then;

  /// Create a copy of AppStoreConnectKey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? issuerId = freezed,
    Object? keyId = freezed,
    Object? keyFileBase64 = freezed,
  }) {
    return _then(_self.copyWith(
      issuerId: freezed == issuerId
          ? _self.issuerId
          : issuerId // ignore: cast_nullable_to_non_nullable
              as String?,
      keyId: freezed == keyId
          ? _self.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
              as String?,
      keyFileBase64: freezed == keyFileBase64
          ? _self.keyFileBase64
          : keyFileBase64 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AppStoreConnectKey implements AppStoreConnectKey {
  const _AppStoreConnectKey(
      {this.issuerId = null, this.keyId = null, this.keyFileBase64 = null});
  factory _AppStoreConnectKey.fromJson(Map<String, dynamic> json) =>
      _$AppStoreConnectKeyFromJson(json);

  @override
  @JsonKey()
  final String? issuerId;
  @override
  @JsonKey()
  final String? keyId;
  @override
  @JsonKey()
  final String? keyFileBase64;

  /// Create a copy of AppStoreConnectKey
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppStoreConnectKeyCopyWith<_AppStoreConnectKey> get copyWith =>
      __$AppStoreConnectKeyCopyWithImpl<_AppStoreConnectKey>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppStoreConnectKeyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppStoreConnectKey &&
            (identical(other.issuerId, issuerId) ||
                other.issuerId == issuerId) &&
            (identical(other.keyId, keyId) || other.keyId == keyId) &&
            (identical(other.keyFileBase64, keyFileBase64) ||
                other.keyFileBase64 == keyFileBase64));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, issuerId, keyId, keyFileBase64);

  @override
  String toString() {
    return 'AppStoreConnectKey(issuerId: $issuerId, keyId: $keyId, keyFileBase64: $keyFileBase64)';
  }
}

/// @nodoc
abstract mixin class _$AppStoreConnectKeyCopyWith<$Res>
    implements $AppStoreConnectKeyCopyWith<$Res> {
  factory _$AppStoreConnectKeyCopyWith(
          _AppStoreConnectKey value, $Res Function(_AppStoreConnectKey) _then) =
      __$AppStoreConnectKeyCopyWithImpl;
  @override
  @useResult
  $Res call({String? issuerId, String? keyId, String? keyFileBase64});
}

/// @nodoc
class __$AppStoreConnectKeyCopyWithImpl<$Res>
    implements _$AppStoreConnectKeyCopyWith<$Res> {
  __$AppStoreConnectKeyCopyWithImpl(this._self, this._then);

  final _AppStoreConnectKey _self;
  final $Res Function(_AppStoreConnectKey) _then;

  /// Create a copy of AppStoreConnectKey
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? issuerId = freezed,
    Object? keyId = freezed,
    Object? keyFileBase64 = freezed,
  }) {
    return _then(_AppStoreConnectKey(
      issuerId: freezed == issuerId
          ? _self.issuerId
          : issuerId // ignore: cast_nullable_to_non_nullable
              as String?,
      keyId: freezed == keyId
          ? _self.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
              as String?,
      keyFileBase64: freezed == keyFileBase64
          ? _self.keyFileBase64
          : keyFileBase64 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$FlutterBuildIpaData {
  String get workflowName;
  String get flutterBuildCommand;
  String get cwd;
  String get baseBranch;
  GitHubTriggerType get triggerType;

  /// Create a copy of FlutterBuildIpaData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlutterBuildIpaDataCopyWith<FlutterBuildIpaData> get copyWith =>
      _$FlutterBuildIpaDataCopyWithImpl<FlutterBuildIpaData>(
          this as FlutterBuildIpaData, _$identity);

  /// Serializes this FlutterBuildIpaData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlutterBuildIpaData &&
            (identical(other.workflowName, workflowName) ||
                other.workflowName == workflowName) &&
            (identical(other.flutterBuildCommand, flutterBuildCommand) ||
                other.flutterBuildCommand == flutterBuildCommand) &&
            (identical(other.cwd, cwd) || other.cwd == cwd) &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch) &&
            (identical(other.triggerType, triggerType) ||
                other.triggerType == triggerType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workflowName,
      flutterBuildCommand, cwd, baseBranch, triggerType);

  @override
  String toString() {
    return 'FlutterBuildIpaData(workflowName: $workflowName, flutterBuildCommand: $flutterBuildCommand, cwd: $cwd, baseBranch: $baseBranch, triggerType: $triggerType)';
  }
}

/// @nodoc
abstract mixin class $FlutterBuildIpaDataCopyWith<$Res> {
  factory $FlutterBuildIpaDataCopyWith(
          FlutterBuildIpaData value, $Res Function(FlutterBuildIpaData) _then) =
      _$FlutterBuildIpaDataCopyWithImpl;
  @useResult
  $Res call(
      {String workflowName,
      String flutterBuildCommand,
      String cwd,
      String baseBranch,
      GitHubTriggerType triggerType});
}

/// @nodoc
class _$FlutterBuildIpaDataCopyWithImpl<$Res>
    implements $FlutterBuildIpaDataCopyWith<$Res> {
  _$FlutterBuildIpaDataCopyWithImpl(this._self, this._then);

  final FlutterBuildIpaData _self;
  final $Res Function(FlutterBuildIpaData) _then;

  /// Create a copy of FlutterBuildIpaData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workflowName = null,
    Object? flutterBuildCommand = null,
    Object? cwd = null,
    Object? baseBranch = null,
    Object? triggerType = null,
  }) {
    return _then(_self.copyWith(
      workflowName: null == workflowName
          ? _self.workflowName
          : workflowName // ignore: cast_nullable_to_non_nullable
              as String,
      flutterBuildCommand: null == flutterBuildCommand
          ? _self.flutterBuildCommand
          : flutterBuildCommand // ignore: cast_nullable_to_non_nullable
              as String,
      cwd: null == cwd
          ? _self.cwd
          : cwd // ignore: cast_nullable_to_non_nullable
              as String,
      baseBranch: null == baseBranch
          ? _self.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      triggerType: null == triggerType
          ? _self.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as GitHubTriggerType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _FlutterBuildIpaData implements FlutterBuildIpaData {
  const _FlutterBuildIpaData(
      {this.workflowName = 'Release iOS build',
      this.flutterBuildCommand = 'flutter build ipa',
      this.cwd = '',
      this.baseBranch = 'main',
      this.triggerType = GitHubTriggerType.push});
  factory _FlutterBuildIpaData.fromJson(Map<String, dynamic> json) =>
      _$FlutterBuildIpaDataFromJson(json);

  @override
  @JsonKey()
  final String workflowName;
  @override
  @JsonKey()
  final String flutterBuildCommand;
  @override
  @JsonKey()
  final String cwd;
  @override
  @JsonKey()
  final String baseBranch;
  @override
  @JsonKey()
  final GitHubTriggerType triggerType;

  /// Create a copy of FlutterBuildIpaData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FlutterBuildIpaDataCopyWith<_FlutterBuildIpaData> get copyWith =>
      __$FlutterBuildIpaDataCopyWithImpl<_FlutterBuildIpaData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FlutterBuildIpaDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FlutterBuildIpaData &&
            (identical(other.workflowName, workflowName) ||
                other.workflowName == workflowName) &&
            (identical(other.flutterBuildCommand, flutterBuildCommand) ||
                other.flutterBuildCommand == flutterBuildCommand) &&
            (identical(other.cwd, cwd) || other.cwd == cwd) &&
            (identical(other.baseBranch, baseBranch) ||
                other.baseBranch == baseBranch) &&
            (identical(other.triggerType, triggerType) ||
                other.triggerType == triggerType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workflowName,
      flutterBuildCommand, cwd, baseBranch, triggerType);

  @override
  String toString() {
    return 'FlutterBuildIpaData(workflowName: $workflowName, flutterBuildCommand: $flutterBuildCommand, cwd: $cwd, baseBranch: $baseBranch, triggerType: $triggerType)';
  }
}

/// @nodoc
abstract mixin class _$FlutterBuildIpaDataCopyWith<$Res>
    implements $FlutterBuildIpaDataCopyWith<$Res> {
  factory _$FlutterBuildIpaDataCopyWith(_FlutterBuildIpaData value,
          $Res Function(_FlutterBuildIpaData) _then) =
      __$FlutterBuildIpaDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String workflowName,
      String flutterBuildCommand,
      String cwd,
      String baseBranch,
      GitHubTriggerType triggerType});
}

/// @nodoc
class __$FlutterBuildIpaDataCopyWithImpl<$Res>
    implements _$FlutterBuildIpaDataCopyWith<$Res> {
  __$FlutterBuildIpaDataCopyWithImpl(this._self, this._then);

  final _FlutterBuildIpaData _self;
  final $Res Function(_FlutterBuildIpaData) _then;

  /// Create a copy of FlutterBuildIpaData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? workflowName = null,
    Object? flutterBuildCommand = null,
    Object? cwd = null,
    Object? baseBranch = null,
    Object? triggerType = null,
  }) {
    return _then(_FlutterBuildIpaData(
      workflowName: null == workflowName
          ? _self.workflowName
          : workflowName // ignore: cast_nullable_to_non_nullable
              as String,
      flutterBuildCommand: null == flutterBuildCommand
          ? _self.flutterBuildCommand
          : flutterBuildCommand // ignore: cast_nullable_to_non_nullable
              as String,
      cwd: null == cwd
          ? _self.cwd
          : cwd // ignore: cast_nullable_to_non_nullable
              as String,
      baseBranch: null == baseBranch
          ? _self.baseBranch
          : baseBranch // ignore: cast_nullable_to_non_nullable
              as String,
      triggerType: null == triggerType
          ? _self.triggerType
          : triggerType // ignore: cast_nullable_to_non_nullable
              as GitHubTriggerType,
    ));
  }
}

// dart format on
