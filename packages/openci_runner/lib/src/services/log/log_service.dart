import 'package:dart_firebase_admin/firestore.dart';
import 'package:runner/src/services/firebase/firestore/firestore_path.dart';
import 'package:runner/src/services/ssh/domain/session_result.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';

class LogService {
  LogService(this.firestore);

  final Firestore firestore;

  Future<void> saveCommandLog({
    required String jobDocumentId,
    required String command,
    required SessionResult sessionResult,
  }) async {
    final logDocumentId = UuidService.generateV4();
    await firestore
        .collection(FirestorePath.jobsDomain)
        .doc(jobDocumentId)
        .collection('logs')
        .doc(logDocumentId)
        .set({
      'command': command,
      'stdout': sessionResult.sessionStdout,
      'stderr': sessionResult.sessionStderr,
      'exitCode': sessionResult.sessionExitCode,
      'createdAt': FieldValue.serverTimestamp,
    });
  }
}
