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
