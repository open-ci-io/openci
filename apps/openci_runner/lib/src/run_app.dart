import 'dart:async';

import 'package:dart_firebase_admin_plus/firestore.dart';
import 'package:openci_runner/src/commands/runner_command.dart';
import 'package:openci_runner/src/firebase/firebase_admin.dart';
import 'package:openci_runner/src/main_loop.dart';
import 'package:openci_runner/src/sentry.dart';

Future<void> runApp({
  required String serviceAccountPath,
  required String pem,
  String? sentryDsn,
}) async {
  await initSentry(
    sentryDsn: sentryDsn ?? '',
    appRunner: () async {
      final admin = await initializeFirebaseAdminApp(
        'open-ci-release',
        serviceAccountPath,
      );
      final firestore = Firestore(admin);
      firestoreSignal.value = firestore;

      await mainLoop(firestore, pem);
    },
  );
}
