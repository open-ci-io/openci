// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configure_action_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$configureActionControllerHash() =>
    r'cc3bbddf3f0adf5077db3451310b0aa16116ee04';

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
    extends BuildlessAutoDisposeNotifier<Map<String, dynamic>> {
  late final Map<String, dynamic> value;

  Map<String, dynamic> build(
    Map<String, dynamic> value,
  );
}

/// See also [ConfigureActionController].
@ProviderFor(ConfigureActionController)
const configureActionControllerProvider = ConfigureActionControllerFamily();

/// See also [ConfigureActionController].
class ConfigureActionControllerFamily extends Family<Map<String, dynamic>> {
  /// See also [ConfigureActionController].
  const ConfigureActionControllerFamily();

  /// See also [ConfigureActionController].
  ConfigureActionControllerProvider call(
    Map<String, dynamic> value,
  ) {
    return ConfigureActionControllerProvider(
      value,
    );
  }

  @override
  ConfigureActionControllerProvider getProviderOverride(
    covariant ConfigureActionControllerProvider provider,
  ) {
    return call(
      provider.value,
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
    ConfigureActionController, Map<String, dynamic>> {
  /// See also [ConfigureActionController].
  ConfigureActionControllerProvider(
    Map<String, dynamic> value,
  ) : this._internal(
          () => ConfigureActionController()..value = value,
          from: configureActionControllerProvider,
          name: r'configureActionControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$configureActionControllerHash,
          dependencies: ConfigureActionControllerFamily._dependencies,
          allTransitiveDependencies:
              ConfigureActionControllerFamily._allTransitiveDependencies,
          value: value,
        );

  ConfigureActionControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.value,
  }) : super.internal();

  final Map<String, dynamic> value;

  @override
  Map<String, dynamic> runNotifierBuild(
    covariant ConfigureActionController notifier,
  ) {
    return notifier.build(
      value,
    );
  }

  @override
  Override overrideWith(ConfigureActionController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConfigureActionControllerProvider._internal(
        () => create()..value = value,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        value: value,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ConfigureActionController,
      Map<String, dynamic>> createElement() {
    return _ConfigureActionControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConfigureActionControllerProvider && other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ConfigureActionControllerRef
    on AutoDisposeNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `value` of this provider.
  Map<String, dynamic> get value;
}

class _ConfigureActionControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ConfigureActionController,
        Map<String, dynamic>> with ConfigureActionControllerRef {
  _ConfigureActionControllerProviderElement(super.provider);

  @override
  Map<String, dynamic> get value =>
      (origin as ConfigureActionControllerProvider).value;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
