// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configure_action_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configureActionControllerHash() =>
    r'b43fd2aa7fe8a8ae21fb119e9f0713b4a1d36b04';

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

abstract class _$ConfigureActionController
    extends BuildlessAutoDisposeNotifier<ActionModel> {
  late final ActionModel action;

  ActionModel build(
    ActionModel action,
  );
}

/// See also [ConfigureActionController].
@ProviderFor(ConfigureActionController)
const configureActionControllerProvider = ConfigureActionControllerFamily();

/// See also [ConfigureActionController].
class ConfigureActionControllerFamily extends Family<ActionModel> {
  /// See also [ConfigureActionController].
  const ConfigureActionControllerFamily();

  /// See also [ConfigureActionController].
  ConfigureActionControllerProvider call(
    ActionModel action,
  ) {
    return ConfigureActionControllerProvider(
      action,
    );
  }

  @override
  ConfigureActionControllerProvider getProviderOverride(
    covariant ConfigureActionControllerProvider provider,
  ) {
    return call(
      provider.action,
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
  String? get name => r'configureActionControllerProvider';
}

/// See also [ConfigureActionController].
class ConfigureActionControllerProvider extends AutoDisposeNotifierProviderImpl<
    ConfigureActionController, ActionModel> {
  /// See also [ConfigureActionController].
  ConfigureActionControllerProvider(
    ActionModel action,
  ) : this._internal(
          () => ConfigureActionController()..action = action,
          from: configureActionControllerProvider,
          name: r'configureActionControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$configureActionControllerHash,
          dependencies: ConfigureActionControllerFamily._dependencies,
          allTransitiveDependencies:
              ConfigureActionControllerFamily._allTransitiveDependencies,
          action: action,
        );

  ConfigureActionControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.action,
  }) : super.internal();

  final ActionModel action;

  @override
  ActionModel runNotifierBuild(
    covariant ConfigureActionController notifier,
  ) {
    return notifier.build(
      action,
    );
  }

  @override
  Override overrideWith(ConfigureActionController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConfigureActionControllerProvider._internal(
        () => create()..action = action,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        action: action,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ConfigureActionController, ActionModel>
      createElement() {
    return _ConfigureActionControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConfigureActionControllerProvider && other.action == action;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, action.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ConfigureActionControllerRef
    on AutoDisposeNotifierProviderRef<ActionModel> {
  /// The parameter `action` of this provider.
  ActionModel get action;
}

class _ConfigureActionControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ConfigureActionController,
        ActionModel> with ConfigureActionControllerRef {
  _ConfigureActionControllerProviderElement(super.provider);

  @override
  ActionModel get action =>
      (origin as ConfigureActionControllerProvider).action;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
