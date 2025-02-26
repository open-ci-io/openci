import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:dashboard/src/services/predefined_secret_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'secrets_repository.g.dart';

@riverpod
class SecretsRepository extends _$SecretsRepository {
  @override
  void build() {
    return;
  }

  Future<OpenCIFirebaseSuite> getOpenCIFirebaseSuite() async {
    final suite = await getOpenCIFirebaseSuite();
    return suite;
  }

  Future<FirebaseFirestore> getFirestore() async {
    final suite = await getOpenCIFirebaseSuite();
    return suite.firestore;
  }

  Future<FirebaseAuth> getAuth() async {
    final suite = await getOpenCIFirebaseSuite();
    return suite.auth;
  }

  Future<String> getCurrentUserId() async {
    final auth = await getAuth();
    final user = auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found',
      );
    }
    return user.uid;
  }

  Future<void> createSecret(
    String key,
    String value,
  ) async {
    final documentId = getDocumentId();
    final now = DateTime.now().millisecondsSinceEpoch;
    final currentUserId = await getCurrentUserId();
    final firestore = await getFirestore();
    await firestore.collection(secretsCollectionPath).doc(documentId).set({
      'key': key,
      'value': value,
      'owners': [currentUserId],
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<bool> saveASCKeys(
    String issuerId,
    String keyId,
    String keyBase64,
  ) async {
    try {
      await createSecret(
        OpenCIPredefinedSecretKeys.ascIssuerId,
        issuerId,
      );
      await createSecret(
        OpenCIPredefinedSecretKeys.ascKeyId,
        keyId,
      );
      await createSecret(
        OpenCIPredefinedSecretKeys.ascKeyBase64,
        keyBase64,
      );
      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    } on Exception catch (_) {
      return false;
    }
  }
}
