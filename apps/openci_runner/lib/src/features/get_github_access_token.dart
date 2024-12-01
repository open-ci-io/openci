import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openci_runner/src/constants/prod_urls.dart';

Future<String> getGithubAccessToken(
  int installationId,
) async {
  final url = Uri.parse('$baseUrl/installation_token');
  final body = jsonEncode({
    'installationId': installationId,
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  if (response.statusCode != 200) {
    throw Exception('API Error: ${response.body}');
  }

  final responseBody = jsonDecode(response.body);
  return responseBody['installation_token'].toString();
}
