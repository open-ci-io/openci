// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workflow_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ascKeysUploadedHash() => r'0917bbc6df12566b11e64a4e9cc31122c672df77';

/// See also [ascKeysUploaded].
@ProviderFor(ascKeysUploaded)
final ascKeysUploadedProvider = AutoDisposeFutureProvider<bool>.internal(
  ascKeysUploaded,
  name: r'ascKeysUploadedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ascKeysUploadedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AscKeysUploadedRef = AutoDisposeFutureProviderRef<bool>;
String _$saveWorkflowHash() => r'38599b0d41253383baaacdf10bd59c3882a5270a';

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

/// See also [saveWorkflow].
@ProviderFor(saveWorkflow)
const saveWorkflowProvider = SaveWorkflowFamily();

/// See also [saveWorkflow].
class SaveWorkflowFamily extends Family<AsyncValue<bool>> {
  /// See also [saveWorkflow].
  const SaveWorkflowFamily();

  /// See also [saveWorkflow].
  SaveWorkflowProvider call({
    required String currentWorkingDirectory,
    required String workflowName,
    required GitHubTriggerType githubTriggerType,
    required String githubBaseBranch,
    required String flutterBuildIpaCommand,
  }) {
    return SaveWorkflowProvider(
      currentWorkingDirectory: currentWorkingDirectory,
      workflowName: workflowName,
      githubTriggerType: githubTriggerType,
      githubBaseBranch: githubBaseBranch,
      flutterBuildIpaCommand: flutterBuildIpaCommand,
    );
  }

  @override
  SaveWorkflowProvider getProviderOverride(
    covariant SaveWorkflowProvider provider,
  ) {
    return call(
      currentWorkingDirectory: provider.currentWorkingDirectory,
      workflowName: provider.workflowName,
      githubTriggerType: provider.githubTriggerType,
      githubBaseBranch: provider.githubBaseBranch,
      flutterBuildIpaCommand: provider.flutterBuildIpaCommand,
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
  String? get name => r'saveWorkflowProvider';
}

/// See also [saveWorkflow].
class SaveWorkflowProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [saveWorkflow].
  SaveWorkflowProvider({
    required String currentWorkingDirectory,
    required String workflowName,
    required GitHubTriggerType githubTriggerType,
    required String githubBaseBranch,
    required String flutterBuildIpaCommand,
  }) : this._internal(
          (ref) => saveWorkflow(
            ref as SaveWorkflowRef,
            currentWorkingDirectory: currentWorkingDirectory,
            workflowName: workflowName,
            githubTriggerType: githubTriggerType,
            githubBaseBranch: githubBaseBranch,
            flutterBuildIpaCommand: flutterBuildIpaCommand,
          ),
          from: saveWorkflowProvider,
          name: r'saveWorkflowProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$saveWorkflowHash,
          dependencies: SaveWorkflowFamily._dependencies,
          allTransitiveDependencies:
              SaveWorkflowFamily._allTransitiveDependencies,
          currentWorkingDirectory: currentWorkingDirectory,
          workflowName: workflowName,
          githubTriggerType: githubTriggerType,
          githubBaseBranch: githubBaseBranch,
          flutterBuildIpaCommand: flutterBuildIpaCommand,
        );

  SaveWorkflowProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentWorkingDirectory,
    required this.workflowName,
    required this.githubTriggerType,
    required this.githubBaseBranch,
    required this.flutterBuildIpaCommand,
  }) : super.internal();

  final String currentWorkingDirectory;
  final String workflowName;
  final GitHubTriggerType githubTriggerType;
  final String githubBaseBranch;
  final String flutterBuildIpaCommand;

  @override
  Override overrideWith(
    FutureOr<bool> Function(SaveWorkflowRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveWorkflowProvider._internal(
        (ref) => create(ref as SaveWorkflowRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentWorkingDirectory: currentWorkingDirectory,
        workflowName: workflowName,
        githubTriggerType: githubTriggerType,
        githubBaseBranch: githubBaseBranch,
        flutterBuildIpaCommand: flutterBuildIpaCommand,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _SaveWorkflowProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveWorkflowProvider &&
        other.currentWorkingDirectory == currentWorkingDirectory &&
        other.workflowName == workflowName &&
        other.githubTriggerType == githubTriggerType &&
        other.githubBaseBranch == githubBaseBranch &&
        other.flutterBuildIpaCommand == flutterBuildIpaCommand;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentWorkingDirectory.hashCode);
    hash = _SystemHash.combine(hash, workflowName.hashCode);
    hash = _SystemHash.combine(hash, githubTriggerType.hashCode);
    hash = _SystemHash.combine(hash, githubBaseBranch.hashCode);
    hash = _SystemHash.combine(hash, flutterBuildIpaCommand.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaveWorkflowRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `currentWorkingDirectory` of this provider.
  String get currentWorkingDirectory;

  /// The parameter `workflowName` of this provider.
  String get workflowName;

  /// The parameter `githubTriggerType` of this provider.
  GitHubTriggerType get githubTriggerType;

  /// The parameter `githubBaseBranch` of this provider.
  String get githubBaseBranch;

  /// The parameter `flutterBuildIpaCommand` of this provider.
  String get flutterBuildIpaCommand;
}

class _SaveWorkflowProviderElement
    extends AutoDisposeFutureProviderElement<bool> with SaveWorkflowRef {
  _SaveWorkflowProviderElement(super.provider);

  @override
  String get currentWorkingDirectory =>
      (origin as SaveWorkflowProvider).currentWorkingDirectory;
  @override
  String get workflowName => (origin as SaveWorkflowProvider).workflowName;
  @override
  GitHubTriggerType get githubTriggerType =>
      (origin as SaveWorkflowProvider).githubTriggerType;
  @override
  String get githubBaseBranch =>
      (origin as SaveWorkflowProvider).githubBaseBranch;
  @override
  String get flutterBuildIpaCommand =>
      (origin as SaveWorkflowProvider).flutterBuildIpaCommand;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
