// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_editor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workflowEditorControllerHash() =>
    r'8325c34a733454b733ad2c60329bcaa85e1f65c3';

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

abstract class _$WorkflowEditorController
    extends BuildlessAutoDisposeNotifier<WorkflowModel> {
  late final WorkflowModel workflowModel;
  late final OpenCIFirebaseSuite firebaseSuite;

  WorkflowModel build(
    WorkflowModel workflowModel,
    OpenCIFirebaseSuite firebaseSuite,
  );
}

/// See also [WorkflowEditorController].
@ProviderFor(WorkflowEditorController)
const workflowEditorControllerProvider = WorkflowEditorControllerFamily();

/// See also [WorkflowEditorController].
class WorkflowEditorControllerFamily extends Family<WorkflowModel> {
  /// See also [WorkflowEditorController].
  const WorkflowEditorControllerFamily();

  /// See also [WorkflowEditorController].
  WorkflowEditorControllerProvider call(
    WorkflowModel workflowModel,
    OpenCIFirebaseSuite firebaseSuite,
  ) {
    return WorkflowEditorControllerProvider(
      workflowModel,
      firebaseSuite,
    );
  }

  @override
  WorkflowEditorControllerProvider getProviderOverride(
    covariant WorkflowEditorControllerProvider provider,
  ) {
    return call(
      provider.workflowModel,
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
  String? get name => r'workflowEditorControllerProvider';
}

/// See also [WorkflowEditorController].
class WorkflowEditorControllerProvider extends AutoDisposeNotifierProviderImpl<
    WorkflowEditorController, WorkflowModel> {
  /// See also [WorkflowEditorController].
  WorkflowEditorControllerProvider(
    WorkflowModel workflowModel,
    OpenCIFirebaseSuite firebaseSuite,
  ) : this._internal(
          () => WorkflowEditorController()
            ..workflowModel = workflowModel
            ..firebaseSuite = firebaseSuite,
          from: workflowEditorControllerProvider,
          name: r'workflowEditorControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workflowEditorControllerHash,
          dependencies: WorkflowEditorControllerFamily._dependencies,
          allTransitiveDependencies:
              WorkflowEditorControllerFamily._allTransitiveDependencies,
          workflowModel: workflowModel,
          firebaseSuite: firebaseSuite,
        );

  WorkflowEditorControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workflowModel,
    required this.firebaseSuite,
  }) : super.internal();

  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;

  @override
  WorkflowModel runNotifierBuild(
    covariant WorkflowEditorController notifier,
  ) {
    return notifier.build(
      workflowModel,
      firebaseSuite,
    );
  }

  @override
  Override overrideWith(WorkflowEditorController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkflowEditorControllerProvider._internal(
        () => create()
          ..workflowModel = workflowModel
          ..firebaseSuite = firebaseSuite,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workflowModel: workflowModel,
        firebaseSuite: firebaseSuite,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WorkflowEditorController, WorkflowModel>
      createElement() {
    return _WorkflowEditorControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkflowEditorControllerProvider &&
        other.workflowModel == workflowModel &&
        other.firebaseSuite == firebaseSuite;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workflowModel.hashCode);
    hash = _SystemHash.combine(hash, firebaseSuite.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkflowEditorControllerRef
    on AutoDisposeNotifierProviderRef<WorkflowModel> {
  /// The parameter `workflowModel` of this provider.
  WorkflowModel get workflowModel;

  /// The parameter `firebaseSuite` of this provider.
  OpenCIFirebaseSuite get firebaseSuite;
}

class _WorkflowEditorControllerProviderElement
    extends AutoDisposeNotifierProviderElement<WorkflowEditorController,
        WorkflowModel> with WorkflowEditorControllerRef {
  _WorkflowEditorControllerProviderElement(super.provider);

  @override
  WorkflowModel get workflowModel =>
      (origin as WorkflowEditorControllerProvider).workflowModel;
  @override
  OpenCIFirebaseSuite get firebaseSuite =>
      (origin as WorkflowEditorControllerProvider).firebaseSuite;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
