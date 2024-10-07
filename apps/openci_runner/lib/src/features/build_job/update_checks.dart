import 'dart:convert';

import 'package:http/http.dart';
import 'package:openci_models/openci_models.dart';

const _baseUrl = 'http://localhost:8080';

Future<Response> updateChecks({
  required String jobId,
  required OpenCIGitHubChecksStatus status,
}) async {
  final url = Uri.parse('$_baseUrl/update_checks');
  final body = jsonEncode({
    'jobId': jobId,
    'checksStatus': status.name,
  });

  final response = await post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode != 200) {
    throw Exception('APIエラー: ${response.body}');
  }

  return response;
}
