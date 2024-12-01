import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openci_models/openci_models.dart';
import 'package:openci_runner/src/constants/prod_urls.dart';
import 'package:openci_runner/src/service/logger_service.dart';

Future<void> updateBuildStatus({
  required String jobId,
  OpenCIGitHubChecksStatus status = OpenCIGitHubChecksStatus.inProgress,
}) async {
  await _postUpdateBuildStatus(jobId: jobId, status: status.name);
}

Future<void> _postUpdateBuildStatus({
  required String jobId,
  required String status,
}) async {
  final url = Uri.parse('$baseUrl/update_checks');
  final logger = loggerSignal.value;

  final body = jsonEncode({
    'jobId': jobId,
    'checksStatus': status,
  });

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    logger.info('Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'API Error: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    logger.success('Build status updated: $status');
  } catch (error) {
    logger.err('Failed to update build status: $error');
  }
}
