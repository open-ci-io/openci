import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:openci_models/openci_models.dart';

Stream<List<DocumentSnapshot>> secrets(OpenCIFirebaseSuite firebaseSuite) {
  final firestore = firebaseSuite.firestore;
  final auth = firebaseSuite.auth;
  final uid = auth.currentUser!.uid;
  return firestore
      .collection(secretsCollectionPath)
      .where(
        'owners',
        arrayContains: uid,
      )
      .snapshots()
      .map((snapshot) => snapshot.docs);
}
