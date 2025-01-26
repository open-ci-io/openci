import 'dart:io';

import 'package:dart_firebase_admin_plus/dart_firebase_admin.dart';
import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:signals_core/signals_core.dart';

final firestoreSignal = signal<Firestore?>(null);

Future<FirebaseAdminApp> initializeFirebaseAdminApp(
  String projectId,
  String pathToServiceAccountJson,
) async {
  return FirebaseAdminApp.initializeApp(
    projectId,
    Credential.fromServiceAccount(File(pathToServiceAccountJson)),
  );
}
