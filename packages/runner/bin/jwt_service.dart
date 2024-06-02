import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

Future<String> accessToken(
  int installationId,
  String base64Pem,
  String githubAppId,
) async {
  try {
    print('installationId: $installationId');
    print('base64Pem: $base64Pem');
    print('githubAppId: $githubAppId');
    final pem = utf8.decode(base64Decode(base64Pem));
    final file = File('./github.pem');
    file.writeAsStringSync(pem);

    final privateKeyString = File('./github.pem').readAsStringSync();
    final privateKey = RSAPrivateKey(privateKeyString);

    final jwt = JWT(
      {
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000, // 発行時間
        'exp': DateTime.now()
                .add(const Duration(minutes: 10))
                .millisecondsSinceEpoch ~/
            1000, // 有効期限
        'iss': int.parse(githubAppId),
      },
    );

    final token = jwt.sign(privateKey, algorithm: JWTAlgorithm.RS256);

    final response = await http.post(
      Uri.parse(
        'https://api.github.com/app/installations/$installationId/access_tokens',
      ),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 201) {
      final accessToken = jsonDecode(response.body)['token'];
      print('Access token: $accessToken');
      return accessToken.toString();
    } else {
      print('Failed to retrieve access token: ${response.body}');
      throw Exception('Failed to retrieve access token: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error: $e');
  }
}
