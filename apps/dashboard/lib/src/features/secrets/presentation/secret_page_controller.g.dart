// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secretStreamHash() => r'6487d6740e669573d6170ee2b1b861872b3b2c18';

/// See also [secretStream].
@ProviderFor(secretStream)
final secretStreamProvider = AutoDisposeStreamProvider<QuerySnapshot>.internal(
  secretStream,
  name: r'secretStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$secretStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecretStreamRef = AutoDisposeStreamProviderRef<QuerySnapshot>;
String _$secretPageControllerHash() =>
    r'844069c295c0b4e2edaa4e2fa0e69c4bc66b9a64';

/// See also [SecretPageController].
@ProviderFor(SecretPageController)
final secretPageControllerProvider =
    AutoDisposeNotifierProvider<SecretPageController, void>.internal(
  SecretPageController.new,
  name: r'secretPageControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secretPageControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SecretPageController = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
