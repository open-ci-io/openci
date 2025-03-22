import 'package:dart_firebase_admin/firestore.dart';
import 'package:openci_runner/src/firebase.dart';
import 'package:openci_runner/src/log.dart';
import 'package:openci_runner/src/main_loop.dart';
import 'package:openci_runner/src/sentry.dart';

Future<void> runApp({
  required String serviceAccountPath,
  required String pem,
  required String projectId,
  String? sentryDsn,
}) async {
  await initSentry(
    sentryDsn: sentryDsn ?? '',
    appRunner: () async {
      try {
        final admin = await initializeFirebaseAdminApp(
          projectId,
          serviceAccountPath,
        );
        final firestore = Firestore(admin);
        firestoreSignal.value = firestore;

        await mainLoop(firestore, pem);
      } catch (e) {
        openciLog('Failed to initialize Firebase Admin App: $e');
        throw Exception(e);
      }
    },
  );
}
