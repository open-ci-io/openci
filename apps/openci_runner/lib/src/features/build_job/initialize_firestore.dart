import 'dart:io';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:runner/src/commands/runner_command.dart';
import 'package:runner/src/features/command_args/app_args.dart';

void initializeFirestore(AppArgs appArgs) {
  final admin = FirebaseAdminApp.initializeApp(
    appArgs.firebaseProjectName,
    Credential.fromServiceAccount(
      File(appArgs.firebaseServiceAccountFileRelativePath),
    ),
  );
  firestoreClientSignal.value = Firestore(admin);
}
