import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  static const baseUrl = 'https://get-github-job-wvluvdjkzq-an.a.run.app';

  Future<String> getInstallationToken(
    int installationId,
  ) async {
    const url = '$baseUrl/installation_token';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'installationId': installationId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['installation_token'] as String;
    } else {
      throw Exception(
        'Failed to get installation token. Status code: ${response.statusCode}',
      );
    }
  }

  Future<void> updateChecksStatus(Map<String, dynamic> payload) async {
    const endpoint = '$baseUrl/update_checks';
    final url = Uri.parse(endpoint);
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(payload);

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
      } else {
        throw Exception(
          'Failed with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'Error: $e',
      );
    }
  }
}
