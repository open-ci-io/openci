import 'dart:convert';
import 'dart:io';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

const workflowCollectionName = 'workflows';

Future<QuerySnapshot<Map<String, Object?>>> getWorkflowQuerySnapshot({
  required Firestore firestore,
  required String githubRepositoryUrl,
  required String triggerType,
}) async {
  final workflowQuerySnapshot = await firestore
      .collection(workflowCollectionName)
      .where('github.repositoryUrl', WhereFilter.equal, githubRepositoryUrl)
      .where('github.triggerType', WhereFilter.equal, triggerType)
      .get();

  if (workflowQuerySnapshot.docs.isEmpty) {
    throw Exception('workflowQuerySnapshot is Empty');
  }
  return workflowQuerySnapshot;
}

FirebaseAdminApp initializeFirebaseAdminSDK(
  String base64SA,
  String firebaseProjectName,
) {
  final jsonSA = utf8.decode(base64Decode(base64SA));
  final file = File('./service_account_decoded.json');
  file.writeAsStringSync(jsonSA);
  return FirebaseAdminApp.initializeApp(
    firebaseProjectName,
    Credential.fromServiceAccount(
      File('./service_account_decoded.json'),
    ),
  );
}

Firestore getFirestore(FirebaseAdminApp admin) => Firestore(admin);
