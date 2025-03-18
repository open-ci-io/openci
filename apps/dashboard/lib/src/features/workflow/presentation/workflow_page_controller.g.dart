// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workflowStreamHash() => r'59d6331bb493f28fa2a17743f5df6ca43015b70c';

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

/// See also [workflowStream].
@ProviderFor(workflowStream)
const workflowStreamProvider = WorkflowStreamFamily();

/// See also [workflowStream].
class WorkflowStreamFamily extends Family<AsyncValue<List<WorkflowModel>>> {
  /// See also [workflowStream].
  const WorkflowStreamFamily();

  /// See also [workflowStream].
  WorkflowStreamProvider call(
    OpenCIFirebaseSuite firebaseSuite,
  ) {
    return WorkflowStreamProvider(
      firebaseSuite,
    );
  }

  @override
  WorkflowStreamProvider getProviderOverride(
    covariant WorkflowStreamProvider provider,
  ) {
    return call(
      provider.firebaseSuite,
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
  String? get name => r'workflowStreamProvider';
}

/// See also [workflowStream].
class WorkflowStreamProvider
    extends AutoDisposeStreamProvider<List<WorkflowModel>> {
  /// See also [workflowStream].
  WorkflowStreamProvider(
    OpenCIFirebaseSuite firebaseSuite,
  ) : this._internal(
          (ref) => workflowStream(
            ref as WorkflowStreamRef,
            firebaseSuite,
          ),
          from: workflowStreamProvider,
          name: r'workflowStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workflowStreamHash,
          dependencies: WorkflowStreamFamily._dependencies,
          allTransitiveDependencies:
              WorkflowStreamFamily._allTransitiveDependencies,
          firebaseSuite: firebaseSuite,
        );

  WorkflowStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.firebaseSuite,
  }) : super.internal();

  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Override overrideWith(
    Stream<List<WorkflowModel>> Function(WorkflowStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkflowStreamProvider._internal(
        (ref) => create(ref as WorkflowStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        firebaseSuite: firebaseSuite,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<WorkflowModel>> createElement() {
    return _WorkflowStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkflowStreamProvider &&
        other.firebaseSuite == firebaseSuite;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, firebaseSuite.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkflowStreamRef on AutoDisposeStreamProviderRef<List<WorkflowModel>> {
  /// The parameter `firebaseSuite` of this provider.
  OpenCIFirebaseSuite get firebaseSuite;
}

class _WorkflowStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<WorkflowModel>>
    with WorkflowStreamRef {
  _WorkflowStreamProviderElement(super.provider);

  @override
  OpenCIFirebaseSuite get firebaseSuite =>
      (origin as WorkflowStreamProvider).firebaseSuite;
}

String _$isGitHubAppInstalledHash() =>
    r'3e468fce52deca7a1d5137f6983ad8a81630f8e4';

/// See also [isGitHubAppInstalled].
@ProviderFor(isGitHubAppInstalled)
const isGitHubAppInstalledProvider = IsGitHubAppInstalledFamily();

/// See also [isGitHubAppInstalled].
class IsGitHubAppInstalledFamily extends Family<AsyncValue<bool>> {
  /// See also [isGitHubAppInstalled].
  const IsGitHubAppInstalledFamily();

  /// See also [isGitHubAppInstalled].
  IsGitHubAppInstalledProvider call(
    OpenCIFirebaseSuite firebaseSuite,
  ) {
    return IsGitHubAppInstalledProvider(
      firebaseSuite,
    );
  }

  @override
  IsGitHubAppInstalledProvider getProviderOverride(
    covariant IsGitHubAppInstalledProvider provider,
  ) {
    return call(
      provider.firebaseSuite,
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
  String? get name => r'isGitHubAppInstalledProvider';
}

/// See also [isGitHubAppInstalled].
class IsGitHubAppInstalledProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [isGitHubAppInstalled].
  IsGitHubAppInstalledProvider(
    OpenCIFirebaseSuite firebaseSuite,
  ) : this._internal(
          (ref) => isGitHubAppInstalled(
            ref as IsGitHubAppInstalledRef,
            firebaseSuite,
          ),
          from: isGitHubAppInstalledProvider,
          name: r'isGitHubAppInstalledProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isGitHubAppInstalledHash,
          dependencies: IsGitHubAppInstalledFamily._dependencies,
          allTransitiveDependencies:
              IsGitHubAppInstalledFamily._allTransitiveDependencies,
          firebaseSuite: firebaseSuite,
        );

  IsGitHubAppInstalledProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.firebaseSuite,
  }) : super.internal();

  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Override overrideWith(
    Stream<bool> Function(IsGitHubAppInstalledRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsGitHubAppInstalledProvider._internal(
        (ref) => create(ref as IsGitHubAppInstalledRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        firebaseSuite: firebaseSuite,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _IsGitHubAppInstalledProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsGitHubAppInstalledProvider &&
        other.firebaseSuite == firebaseSuite;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, firebaseSuite.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsGitHubAppInstalledRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `firebaseSuite` of this provider.
  OpenCIFirebaseSuite get firebaseSuite;
}

class _IsGitHubAppInstalledProviderElement
    extends AutoDisposeStreamProviderElement<bool>
    with IsGitHubAppInstalledRef {
  _IsGitHubAppInstalledProviderElement(super.provider);

  @override
  OpenCIFirebaseSuite get firebaseSuite =>
      (origin as IsGitHubAppInstalledProvider).firebaseSuite;
}

String _$workflowPageControllerHash() =>
    r'd9ea6faf7837010045b8db0684ec45d1981c0e5f';

abstract class _$WorkflowPageController
    extends BuildlessAutoDisposeNotifier<void> {
  late final OpenCIFirebaseSuite firebaseSuite;

  void build(
    OpenCIFirebaseSuite firebaseSuite,
  );
}

/// See also [WorkflowPageController].
@ProviderFor(WorkflowPageController)
const workflowPageControllerProvider = WorkflowPageControllerFamily();

/// See also [WorkflowPageController].
class WorkflowPageControllerFamily extends Family<void> {
  /// See also [WorkflowPageController].
  const WorkflowPageControllerFamily();

  /// See also [WorkflowPageController].
  WorkflowPageControllerProvider call(
    OpenCIFirebaseSuite firebaseSuite,
  ) {
    return WorkflowPageControllerProvider(
      firebaseSuite,
    );
  }

  @override
  WorkflowPageControllerProvider getProviderOverride(
    covariant WorkflowPageControllerProvider provider,
  ) {
    return call(
      provider.firebaseSuite,
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
  String? get name => r'workflowPageControllerProvider';
}

/// See also [WorkflowPageController].
class WorkflowPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<WorkflowPageController, void> {
  /// See also [WorkflowPageController].
  WorkflowPageControllerProvider(
    OpenCIFirebaseSuite firebaseSuite,
  ) : this._internal(
          () => WorkflowPageController()..firebaseSuite = firebaseSuite,
          from: workflowPageControllerProvider,
          name: r'workflowPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workflowPageControllerHash,
          dependencies: WorkflowPageControllerFamily._dependencies,
          allTransitiveDependencies:
              WorkflowPageControllerFamily._allTransitiveDependencies,
          firebaseSuite: firebaseSuite,
        );

  WorkflowPageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.firebaseSuite,
  }) : super.internal();

  final OpenCIFirebaseSuite firebaseSuite;

  @override
  void runNotifierBuild(
    covariant WorkflowPageController notifier,
  ) {
    return notifier.build(
      firebaseSuite,
    );
  }

  @override
  Override overrideWith(WorkflowPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkflowPageControllerProvider._internal(
        () => create()..firebaseSuite = firebaseSuite,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        firebaseSuite: firebaseSuite,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WorkflowPageController, void>
      createElement() {
    return _WorkflowPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkflowPageControllerProvider &&
        other.firebaseSuite == firebaseSuite;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, firebaseSuite.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkflowPageControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `firebaseSuite` of this provider.
  OpenCIFirebaseSuite get firebaseSuite;
}

class _WorkflowPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<WorkflowPageController, void>
    with WorkflowPageControllerRef {
  _WorkflowPageControllerProviderElement(super.provider);

  @override
  OpenCIFirebaseSuite get firebaseSuite =>
      (origin as WorkflowPageControllerProvider).firebaseSuite;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
