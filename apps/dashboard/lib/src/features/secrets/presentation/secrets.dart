import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:openci_models/openci_models.dart';

Future<List<DocumentSnapshot>> secrets() async {
  final firestore = await getFirebaseFirestore();
  final auth = await getFirebaseAuth();
  final uid = auth.currentUser!.uid;
  final doc = await firestore
      .collection(secretsCollectionPath)
      .where(
        'owners',
        arrayContains: uid,
      )
      .get();
  return doc.docs;
}
