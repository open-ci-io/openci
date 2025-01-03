import 'dart:io';

import 'package:dart_firebase_admin_plus/dart_firebase_admin.dart';

Future<FirebaseAdminApp> initializeFirebaseAdminApp(
  String projectId,
  String pathToServiceAccountJson,
) async {
  return FirebaseAdminApp.initializeApp(
    projectId,
    Credential.fromServiceAccount(File(pathToServiceAccountJson)),
  );
}
