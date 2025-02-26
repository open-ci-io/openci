import 'package:dashboard/src/services/firestore/secrets_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_asc_keys.g.dart';

@riverpod
Future<bool> saveASCKeys(
  Ref ref, {
  required String issuerId,
  required String keyId,
  required String keyBase64,
}) async {
  final secretsRepository = ref.read(secretsRepositoryProvider.notifier);
  return secretsRepository.saveASCKeys(
    issuerId,
    keyId,
    keyBase64,
  );
}
