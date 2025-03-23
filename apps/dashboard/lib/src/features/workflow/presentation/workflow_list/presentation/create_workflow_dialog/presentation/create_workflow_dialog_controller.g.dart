// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workflow_dialog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveASCKeysHash() => r'57fba506ea19b5c7033a3c2caf9bb93d9f90e748';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [saveASCKeys].
@ProviderFor(saveASCKeys)
const saveASCKeysProvider = SaveASCKeysFamily();

/// See also [saveASCKeys].
class SaveASCKeysFamily extends Family<AsyncValue<void>> {
  /// See also [saveASCKeys].
  const SaveASCKeysFamily();

  /// See also [saveASCKeys].
  SaveASCKeysProvider call({
    required AppStoreConnectKey ascKey,
  }) {
    return SaveASCKeysProvider(
      ascKey: ascKey,
    );
  }

  @override
  SaveASCKeysProvider getProviderOverride(
    covariant SaveASCKeysProvider provider,
  ) {
    return call(
      ascKey: provider.ascKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saveASCKeysProvider';
}

/// See also [saveASCKeys].
class SaveASCKeysProvider extends AutoDisposeFutureProvider<void> {
  /// See also [saveASCKeys].
  SaveASCKeysProvider({
    required AppStoreConnectKey ascKey,
  }) : this._internal(
          (ref) => saveASCKeys(
            ref as SaveASCKeysRef,
            ascKey: ascKey,
          ),
          from: saveASCKeysProvider,
          name: r'saveASCKeysProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveASCKeysHash,
          dependencies: SaveASCKeysFamily._dependencies,
          allTransitiveDependencies:
              SaveASCKeysFamily._allTransitiveDependencies,
          ascKey: ascKey,
        );

  SaveASCKeysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ascKey,
  }) : super.internal();

  final AppStoreConnectKey ascKey;

  @override
  Override overrideWith(
    FutureOr<void> Function(SaveASCKeysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveASCKeysProvider._internal(
        (ref) => create(ref as SaveASCKeysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ascKey: ascKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveASCKeysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveASCKeysProvider && other.ascKey == ascKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ascKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaveASCKeysRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `ascKey` of this provider.
  AppStoreConnectKey get ascKey;
}

class _SaveASCKeysProviderElement extends AutoDisposeFutureProviderElement<void>
    with SaveASCKeysRef {
  _SaveASCKeysProviderElement(super.provider);

  @override
  AppStoreConnectKey get ascKey => (origin as SaveASCKeysProvider).ascKey;
}

String _$areAppStoreConnectKeysUploadedHash() =>
    r'048d7d88ebe0348b7e53475e343adba154d11f7e';

/// See also [areAppStoreConnectKeysUploaded].
@ProviderFor(areAppStoreConnectKeysUploaded)
final areAppStoreConnectKeysUploadedProvider =
    AutoDisposeFutureProvider<bool>.internal(
  areAppStoreConnectKeysUploaded,
  name: r'areAppStoreConnectKeysUploadedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$areAppStoreConnectKeysUploadedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AreAppStoreConnectKeysUploadedRef = AutoDisposeFutureProviderRef<bool>;
String _$createWorkflowHash() => r'e939ab30ffe09f9eead63fe1f6dfcb49b503b4f3';

/// See also [createWorkflow].
@ProviderFor(createWorkflow)
const createWorkflowProvider = CreateWorkflowFamily();

/// See also [createWorkflow].
class CreateWorkflowFamily extends Family<AsyncValue<WorkflowModel>> {
  /// See also [createWorkflow].
  const CreateWorkflowFamily();

  /// See also [createWorkflow].
  CreateWorkflowProvider call({
    required String selectedRepository,
  }) {
    return CreateWorkflowProvider(
      selectedRepository: selectedRepository,
    );
  }

  @override
  CreateWorkflowProvider getProviderOverride(
    covariant CreateWorkflowProvider provider,
  ) {
    return call(
      selectedRepository: provider.selectedRepository,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createWorkflowProvider';
}

/// See also [createWorkflow].
class CreateWorkflowProvider extends AutoDisposeFutureProvider<WorkflowModel> {
  /// See also [createWorkflow].
  CreateWorkflowProvider({
    required String selectedRepository,
  }) : this._internal(
          (ref) => createWorkflow(
            ref as CreateWorkflowRef,
            selectedRepository: selectedRepository,
          ),
          from: createWorkflowProvider,
          name: r'createWorkflowProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createWorkflowHash,
          dependencies: CreateWorkflowFamily._dependencies,
          allTransitiveDependencies:
              CreateWorkflowFamily._allTransitiveDependencies,
          selectedRepository: selectedRepository,
        );

  CreateWorkflowProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedRepository,
  }) : super.internal();

  final String selectedRepository;

  @override
  Override overrideWith(
    FutureOr<WorkflowModel> Function(CreateWorkflowRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateWorkflowProvider._internal(
        (ref) => create(ref as CreateWorkflowRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedRepository: selectedRepository,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WorkflowModel> createElement() {
    return _CreateWorkflowProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateWorkflowProvider &&
        other.selectedRepository == selectedRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateWorkflowRef on AutoDisposeFutureProviderRef<WorkflowModel> {
  /// The parameter `selectedRepository` of this provider.
  String get selectedRepository;
}

class _CreateWorkflowProviderElement
    extends AutoDisposeFutureProviderElement<WorkflowModel>
    with CreateWorkflowRef {
  _CreateWorkflowProviderElement(super.provider);

  @override
  String get selectedRepository =>
      (origin as CreateWorkflowProvider).selectedRepository;
}

String _$createWorkflowDialogControllerHash() =>
    r'6eba95260278e73d3f741e4cd8ebad21e47e2ba7';

abstract class _$CreateWorkflowDialogController
    extends BuildlessNotifier<CreateWorkflowDomain> {
  late final String selectedRepository;

  CreateWorkflowDomain build(
    String selectedRepository,
  );
}

/// See also [CreateWorkflowDialogController].
@ProviderFor(CreateWorkflowDialogController)
const createWorkflowDialogControllerProvider =
    CreateWorkflowDialogControllerFamily();

/// See also [CreateWorkflowDialogController].
class CreateWorkflowDialogControllerFamily
    extends Family<CreateWorkflowDomain> {
  /// See also [CreateWorkflowDialogController].
  const CreateWorkflowDialogControllerFamily();

  /// See also [CreateWorkflowDialogController].
  CreateWorkflowDialogControllerProvider call(
    String selectedRepository,
  ) {
    return CreateWorkflowDialogControllerProvider(
      selectedRepository,
    );
  }

  @override
  CreateWorkflowDialogControllerProvider getProviderOverride(
    covariant CreateWorkflowDialogControllerProvider provider,
  ) {
    return call(
      provider.selectedRepository,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createWorkflowDialogControllerProvider';
}

/// See also [CreateWorkflowDialogController].
class CreateWorkflowDialogControllerProvider extends NotifierProviderImpl<
    CreateWorkflowDialogController, CreateWorkflowDomain> {
  /// See also [CreateWorkflowDialogController].
  CreateWorkflowDialogControllerProvider(
    String selectedRepository,
  ) : this._internal(
          () => CreateWorkflowDialogController()
            ..selectedRepository = selectedRepository,
          from: createWorkflowDialogControllerProvider,
          name: r'createWorkflowDialogControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createWorkflowDialogControllerHash,
          dependencies: CreateWorkflowDialogControllerFamily._dependencies,
          allTransitiveDependencies:
              CreateWorkflowDialogControllerFamily._allTransitiveDependencies,
          selectedRepository: selectedRepository,
        );

  CreateWorkflowDialogControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedRepository,
  }) : super.internal();

  final String selectedRepository;

  @override
  CreateWorkflowDomain runNotifierBuild(
    covariant CreateWorkflowDialogController notifier,
  ) {
    return notifier.build(
      selectedRepository,
    );
  }

  @override
  Override overrideWith(CreateWorkflowDialogController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CreateWorkflowDialogControllerProvider._internal(
        () => create()..selectedRepository = selectedRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedRepository: selectedRepository,
      ),
    );
  }

  @override
  NotifierProviderElement<CreateWorkflowDialogController, CreateWorkflowDomain>
      createElement() {
    return _CreateWorkflowDialogControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateWorkflowDialogControllerProvider &&
        other.selectedRepository == selectedRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateWorkflowDialogControllerRef
    on NotifierProviderRef<CreateWorkflowDomain> {
  /// The parameter `selectedRepository` of this provider.
  String get selectedRepository;
}

class _CreateWorkflowDialogControllerProviderElement
    extends NotifierProviderElement<CreateWorkflowDialogController,
        CreateWorkflowDomain> with CreateWorkflowDialogControllerRef {
  _CreateWorkflowDialogControllerProviderElement(super.provider);

  @override
  String get selectedRepository =>
      (origin as CreateWorkflowDialogControllerProvider).selectedRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
