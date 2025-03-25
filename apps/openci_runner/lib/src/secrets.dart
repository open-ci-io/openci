import 'package:dart_firebase_admin/firestore.dart';
import 'package:openci_models/openci_models.dart';

Future<Map<String, String>> fetchSecrets({
  required String workflowId,
  required Firestore firestore,
  required List<String> owners,
}) async {
  final secretsSnapshot = await firestore
      .collection(secretsCollectionPath)
      .where('owners', WhereFilter.arrayContainsAny, owners)
      .get();

  return Map.fromEntries(
    secretsSnapshot.docs.map(
      (doc) => MapEntry(
        doc.data()['key']! as String,
        doc.data()['value']! as String,
      ),
    ),
  );
}
