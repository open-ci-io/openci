// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secrets_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secretsHash() => r'b679e4d1fbe584979de8595f7f23c6bf30af7ba4';

/// See also [secrets].
@ProviderFor(secrets)
final secretsProvider = AutoDisposeFutureProvider<List<String>>.internal(
  secrets,
  name: r'secretsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$secretsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecretsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$secretsStreamHash() => r'b9919f3a1d2d1ee6b9cf1e46917e1ac458cc264e';

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

/// See also [secretsStream].
@ProviderFor(secretsStream)
const secretsStreamProvider = SecretsStreamFamily();

/// See also [secretsStream].
class SecretsStreamFamily extends Family<AsyncValue<List<DocumentSnapshot>>> {
  /// See also [secretsStream].
  const SecretsStreamFamily();

  /// See also [secretsStream].
  SecretsStreamProvider call(
    OpenCIFirebaseSuite firebaseSuite,
  ) {
    return SecretsStreamProvider(
      firebaseSuite,
    );
  }

  @override
  SecretsStreamProvider getProviderOverride(
    covariant SecretsStreamProvider provider,
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
  String? get name => r'secretsStreamProvider';
}

/// See also [secretsStream].
class SecretsStreamProvider
    extends AutoDisposeStreamProvider<List<DocumentSnapshot>> {
  /// See also [secretsStream].
  SecretsStreamProvider(
    OpenCIFirebaseSuite firebaseSuite,
  ) : this._internal(
          (ref) => secretsStream(
            ref as SecretsStreamRef,
            firebaseSuite,
          ),
          from: secretsStreamProvider,
          name: r'secretsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$secretsStreamHash,
          dependencies: SecretsStreamFamily._dependencies,
          allTransitiveDependencies:
              SecretsStreamFamily._allTransitiveDependencies,
          firebaseSuite: firebaseSuite,
        );

  SecretsStreamProvider._internal(
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
    Stream<List<DocumentSnapshot>> Function(SecretsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SecretsStreamProvider._internal(
        (ref) => create(ref as SecretsStreamRef),
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
  AutoDisposeStreamProviderElement<List<DocumentSnapshot>> createElement() {
    return _SecretsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SecretsStreamProvider &&
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
mixin SecretsStreamRef on AutoDisposeStreamProviderRef<List<DocumentSnapshot>> {
  /// The parameter `firebaseSuite` of this provider.
  OpenCIFirebaseSuite get firebaseSuite;
}

class _SecretsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<DocumentSnapshot>>
    with SecretsStreamRef {
  _SecretsStreamProviderElement(super.provider);

  @override
  OpenCIFirebaseSuite get firebaseSuite =>
      (origin as SecretsStreamProvider).firebaseSuite;
}

String _$secretsRepositoryHash() => r'a0db0b7da54cc752ec0b1e56d1f142bf911aa68f';

/// See also [SecretsRepository].
@ProviderFor(SecretsRepository)
final secretsRepositoryProvider =
    AutoDisposeNotifierProvider<SecretsRepository, void>.internal(
  SecretsRepository.new,
  name: r'secretsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secretsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SecretsRepository = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
