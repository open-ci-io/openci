// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workflowPageControllerHash() =>
    r'bec1d9ead49bb64a5ff8249f5d5d2cb1c6367f95';

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
