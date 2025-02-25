import 'package:dashboard/src/services/firebase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'are_app_store_connect_keys_uploaded.g.dart';

@riverpod
Future<bool> areAppStoreConnectKeysUploaded(Ref ref) async {
  final firestore = await getFirebaseFirestore();
  var qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: 'OPENCI_ASC_KEY_ID')
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: 'OPENCI_ASC_ISSUER_ID')
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: 'OPENCI_ASC_KEY_BASE64')
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  return true;
}
