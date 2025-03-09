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
    r'b3081560c46028716ffa32629c3cba52fe1f2890';

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
String _$createWorkflowHash() => r'435392c640770651952717133b8424ef909aa1aa';

/// See also [createWorkflow].
@ProviderFor(createWorkflow)
final createWorkflowProvider =
    AutoDisposeFutureProvider<WorkflowModel>.internal(
  createWorkflow,
  name: r'createWorkflowProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createWorkflowHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateWorkflowRef = AutoDisposeFutureProviderRef<WorkflowModel>;
String _$createWorkflowDialogControllerHash() =>
    r'80a4adb7a2378ccc95929649999cb50ca04af417';

/// See also [CreateWorkflowDialogController].
@ProviderFor(CreateWorkflowDialogController)
final createWorkflowDialogControllerProvider = NotifierProvider<
    CreateWorkflowDialogController, CreateWorkflowDomain>.internal(
  CreateWorkflowDialogController.new,
  name: r'createWorkflowDialogControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createWorkflowDialogControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateWorkflowDialogController = Notifier<CreateWorkflowDomain>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
