// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_asc_keys.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveASCKeysHash() => r'aa27a3a9a9bd2a93f7eb1175bd8bc782840ce739';

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
class SaveASCKeysFamily extends Family<AsyncValue<bool>> {
  /// See also [saveASCKeys].
  const SaveASCKeysFamily();

  /// See also [saveASCKeys].
  SaveASCKeysProvider call({
    required String issuerId,
    required String keyId,
    required String keyBase64,
  }) {
    return SaveASCKeysProvider(
      issuerId: issuerId,
      keyId: keyId,
      keyBase64: keyBase64,
    );
  }

  @override
  SaveASCKeysProvider getProviderOverride(
    covariant SaveASCKeysProvider provider,
  ) {
    return call(
      issuerId: provider.issuerId,
      keyId: provider.keyId,
      keyBase64: provider.keyBase64,
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
class SaveASCKeysProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [saveASCKeys].
  SaveASCKeysProvider({
    required String issuerId,
    required String keyId,
    required String keyBase64,
  }) : this._internal(
          (ref) => saveASCKeys(
            ref as SaveASCKeysRef,
            issuerId: issuerId,
            keyId: keyId,
            keyBase64: keyBase64,
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
          issuerId: issuerId,
          keyId: keyId,
          keyBase64: keyBase64,
        );

  SaveASCKeysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.issuerId,
    required this.keyId,
    required this.keyBase64,
  }) : super.internal();

  final String issuerId;
  final String keyId;
  final String keyBase64;

  @override
  Override overrideWith(
    FutureOr<bool> Function(SaveASCKeysRef provider) create,
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
        issuerId: issuerId,
        keyId: keyId,
        keyBase64: keyBase64,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _SaveASCKeysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveASCKeysProvider &&
        other.issuerId == issuerId &&
        other.keyId == keyId &&
        other.keyBase64 == keyBase64;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, issuerId.hashCode);
    hash = _SystemHash.combine(hash, keyId.hashCode);
    hash = _SystemHash.combine(hash, keyBase64.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaveASCKeysRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `issuerId` of this provider.
  String get issuerId;

  /// The parameter `keyId` of this provider.
  String get keyId;

  /// The parameter `keyBase64` of this provider.
  String get keyBase64;
}

class _SaveASCKeysProviderElement extends AutoDisposeFutureProviderElement<bool>
    with SaveASCKeysRef {
  _SaveASCKeysProviderElement(super.provider);

  @override
  String get issuerId => (origin as SaveASCKeysProvider).issuerId;
  @override
  String get keyId => (origin as SaveASCKeysProvider).keyId;
  @override
  String get keyBase64 => (origin as SaveASCKeysProvider).keyBase64;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
