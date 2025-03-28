import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

/// GitHub Appのインストールトークンを取得する
Future<String> getGitHubInstallationToken({
  required int installationId,
  required int appId,
  required String privateKey,
  http.Client? client,
}) async {
  if (privateKey.isEmpty || installationId <= 0) {
    throw ArgumentError('Required parameters are missing');
  }

  final httpClient = client ?? http.Client();

  try {
    final jwt = createJWT(
      appId: appId,
      privateKey: privateKey,
    );

    final response = await httpClient.post(
      Uri.parse(
        'https://api.github.com/app/installations/$installationId/access_tokens',
      ),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['token'] as String;
    }

    throw GitHubError(response.statusCode, response.body);
  } catch (e) {
    throw GitHubError(-1, 'Failed to create installation token: $e');
  } finally {
    if (client == null) {
      httpClient.close();
    }
  }
}

String createJWT({
  required int appId,
  required String privateKey,
}) {
  final now = DateTime.now();
  final jwt = JWT(
    {
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': now.add(const Duration(minutes: 5)).millisecondsSinceEpoch ~/ 1000,
      'iss': appId,
    },
  );

  return jwt.sign(
    RSAPrivateKey(privateKey),
    algorithm: JWTAlgorithm.RS256,
  );
}

class GitHubError implements Exception {
  GitHubError(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'GitHubError: $statusCode - $message';
}
