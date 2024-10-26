// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_editor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workflowEditorControllerHash() =>
    r'2e59026e785012642a82a0bcbabfb74a6c1333af';

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
    extends BuildlessAutoDisposeNotifier<WorkflowModel?> {
  late final WorkflowModel? workflowModel;

  WorkflowModel? build(
    WorkflowModel? workflowModel,
  );
}

/// See also [WorkflowEditorController].
@ProviderFor(WorkflowEditorController)
const workflowEditorControllerProvider = WorkflowEditorControllerFamily();

/// See also [WorkflowEditorController].
class WorkflowEditorControllerFamily extends Family<WorkflowModel?> {
  /// See also [WorkflowEditorController].
  const WorkflowEditorControllerFamily();

  /// See also [WorkflowEditorController].
  WorkflowEditorControllerProvider call(
    WorkflowModel? workflowModel,
  ) {
    return WorkflowEditorControllerProvider(
      workflowModel,
    );
  }

  @override
  WorkflowEditorControllerProvider getProviderOverride(
    covariant WorkflowEditorControllerProvider provider,
  ) {
    return call(
      provider.workflowModel,
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
    WorkflowEditorController, WorkflowModel?> {
  /// See also [WorkflowEditorController].
  WorkflowEditorControllerProvider(
    WorkflowModel? workflowModel,
  ) : this._internal(
          () => WorkflowEditorController()..workflowModel = workflowModel,
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
        );

  WorkflowEditorControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workflowModel,
  }) : super.internal();

  final WorkflowModel? workflowModel;

  @override
  WorkflowModel? runNotifierBuild(
    covariant WorkflowEditorController notifier,
  ) {
    return notifier.build(
      workflowModel,
    );
  }

  @override
  Override overrideWith(WorkflowEditorController Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkflowEditorControllerProvider._internal(
        () => create()..workflowModel = workflowModel,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workflowModel: workflowModel,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WorkflowEditorController, WorkflowModel?>
      createElement() {
    return _WorkflowEditorControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkflowEditorControllerProvider &&
        other.workflowModel == workflowModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workflowModel.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WorkflowEditorControllerRef
    on AutoDisposeNotifierProviderRef<WorkflowModel?> {
  /// The parameter `workflowModel` of this provider.
  WorkflowModel? get workflowModel;
}

class _WorkflowEditorControllerProviderElement
    extends AutoDisposeNotifierProviderElement<WorkflowEditorController,
        WorkflowModel?> with WorkflowEditorControllerRef {
  _WorkflowEditorControllerProviderElement(super.provider);

  @override
  WorkflowModel? get workflowModel =>
      (origin as WorkflowEditorControllerProvider).workflowModel;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
