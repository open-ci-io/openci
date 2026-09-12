import 'package:meta/meta.dart';
import 'package:openci_shared/openci_shared.dart';

Future<void> sendStepLogChunk({
  required OpenCiApiService api,
  required String jobId,
  required String runId,
  required String stepId,
  required List<String> lines,
}) async {
  if (lines.isEmpty) return;

  final bool isSuccessful;
  final int statusCode;
  try {
    final response = await api.appendStepLog(
      jobId,
      runId,
      stepId,
      buildStepLogPayload(lines),
    );
    isSuccessful = response.isSuccessful;
    statusCode = response.statusCode;
  } catch (error, stackTrace) {
    Error.throwWithStackTrace(
      StateError('Failed to send step log chunk: ${error.runtimeType}.'),
      stackTrace,
    );
  }

  if (!isSuccessful) {
    throw StateError('Failed to send step log chunk: HTTP $statusCode.');
  }
}

@visibleForTesting
Map<String, dynamic> buildStepLogPayload(List<String> lines) => {
  'logs': [
    for (final line in lines) {'message': line},
  ],
};
