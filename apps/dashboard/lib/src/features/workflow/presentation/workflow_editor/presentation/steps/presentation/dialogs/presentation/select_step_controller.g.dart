// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_step_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectStepControllerHash() =>
    r'f920e77bf4fd6a6c2a1fab35ebddad9b3713827d';

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

abstract class _$SelectStepController
    extends BuildlessNotifier<SelectStepDomain> {
  late final String cwd;

  SelectStepDomain build(
    String cwd,
  );
}

/// See also [SelectStepController].
@ProviderFor(SelectStepController)
const selectStepControllerProvider = SelectStepControllerFamily();

/// See also [SelectStepController].
class SelectStepControllerFamily extends Family<SelectStepDomain> {
  /// See also [SelectStepController].
  const SelectStepControllerFamily();

  /// See also [SelectStepController].
  SelectStepControllerProvider call(
    String cwd,
  ) {
    return SelectStepControllerProvider(
      cwd,
    );
  }

  @override
  SelectStepControllerProvider getProviderOverride(
    covariant SelectStepControllerProvider provider,
  ) {
    return call(
      provider.cwd,
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
  String? get name => r'selectStepControllerProvider';
}

/// See also [SelectStepController].
class SelectStepControllerProvider
    extends NotifierProviderImpl<SelectStepController, SelectStepDomain> {
  /// See also [SelectStepController].
  SelectStepControllerProvider(
    String cwd,
  ) : this._internal(
          () => SelectStepController()..cwd = cwd,
          from: selectStepControllerProvider,
          name: r'selectStepControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectStepControllerHash,
          dependencies: SelectStepControllerFamily._dependencies,
          allTransitiveDependencies:
              SelectStepControllerFamily._allTransitiveDependencies,
          cwd: cwd,
        );

  SelectStepControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cwd,
  }) : super.internal();

  final String cwd;

  @override
  SelectStepDomain runNotifierBuild(
    covariant SelectStepController notifier,
  ) {
    return notifier.build(
      cwd,
    );
  }

  @override
  Override overrideWith(SelectStepController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SelectStepControllerProvider._internal(
        () => create()..cwd = cwd,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cwd: cwd,
      ),
    );
  }

  @override
  NotifierProviderElement<SelectStepController, SelectStepDomain>
      createElement() {
    return _SelectStepControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectStepControllerProvider && other.cwd == cwd;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cwd.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SelectStepControllerRef on NotifierProviderRef<SelectStepDomain> {
  /// The parameter `cwd` of this provider.
  String get cwd;
}

class _SelectStepControllerProviderElement
    extends NotifierProviderElement<SelectStepController, SelectStepDomain>
    with SelectStepControllerRef {
  _SelectStepControllerProviderElement(super.provider);

  @override
  String get cwd => (origin as SelectStepControllerProvider).cwd;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
