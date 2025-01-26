import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

const _baseUrl = 'https://api.appstoreconnect.apple.com/v1';

/// App Store Connect APIクライアント
class AppStoreConnectClient {
  AppStoreConnectClient({
    required String issuerId,
    required String keyId,
    required String privateKey,
    http.Client? httpClient,
  })  : _issuerId = issuerId,
        _keyId = keyId,
        _privateKey = privateKey,
        _client = httpClient ?? http.Client();

  final String _issuerId;
  final String _keyId;
  final String _privateKey;
  final http.Client _client;

  /// APIリクエストを実行する
  Future<Map<String, dynamic>> _request({
    required String path,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    final token = await getAppStoreConnectToken(
      issuerId: _issuerId,
      keyId: _keyId,
      privateKey: _privateKey,
    );

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$_baseUrl$path');
    late http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await _client.get(uri, headers: headers);
        case 'POST':
          response = await _client.post(
            uri,
            headers: headers,
            body: json.encode(body),
          );
        case 'PATCH':
          response = await _client.patch(
            uri,
            headers: headers,
            body: json.encode(body),
          );
        case 'DELETE':
          response = await _client.delete(uri, headers: headers);
        default:
          throw AppStoreConnectError('Unsupported HTTP method: $method');
      }

      if (response.statusCode >= 400) {
        throw AppStoreConnectError(
          'API request failed: ${response.statusCode} - ${response.body}',
        );
      }

      if (response.body.isEmpty) {
        return {};
      }

      return json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw AppStoreConnectError('Request failed: $e');
    }
  }

  /// アプリ情報を取得する
  Future<Map<String, dynamic>> getApp({required String bundleId}) async {
    final response = await _request(
      path: '/apps?filter[bundleId]=$bundleId',
      method: 'GET',
    );
    return response;
  }

  /// ビルドを取得する
  Future<Map<String, dynamic>> getBuild({required String buildId}) async {
    final response = await _request(
      path: '/builds/$buildId',
      method: 'GET',
    );
    return response;
  }

  /// TestFlightにビルドを提出する
  Future<Map<String, dynamic>> submitForBetaReview({
    required String buildId,
  }) async {
    final response = await _request(
      path: '/betaAppReviewSubmissions',
      method: 'POST',
      body: {
        'data': {
          'type': 'betaAppReviewSubmissions',
          'relationships': {
            'build': {
              'data': {
                'type': 'builds',
                'id': buildId,
              },
            },
          },
        },
      },
    );
    return response;
  }

  /// リソースを解放する
  void dispose() {
    _client.close();
  }
}

/// App Store Connect APIのインストールトークンを取得する
Future<String> getAppStoreConnectToken({
  required String issuerId,
  required String keyId,
  required String privateKey,
}) async {
  if (privateKey.isEmpty || issuerId.isEmpty || keyId.isEmpty) {
    throw ArgumentError('Required parameters are missing');
  }

  try {
    final jwt = _createJWT(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
    );

    return jwt;
  } catch (e) {
    throw AppStoreConnectError('Failed to create token: $e');
  }
}

/// JWTトークンを生成する
String _createJWT({
  required String issuerId,
  required String keyId,
  required String privateKey,
}) {
  final now = DateTime.now();
  final jwt = JWT(
    {
      'iss': issuerId,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp':
          now.add(const Duration(minutes: 20)).millisecondsSinceEpoch ~/ 1000,
      'aud': 'appstoreconnect-v1',
    },
    header: {
      'kid': keyId,
      'typ': 'JWT',
    },
  );

  return jwt.sign(
    RSAPrivateKey(privateKey),
    algorithm: JWTAlgorithm.ES256,
  );
}

/// App Store Connect APIのエラーを表現するクラス
class AppStoreConnectError implements Exception {
  AppStoreConnectError(this.message);
  final String message;

  @override
  String toString() => 'AppStoreConnectError: $message';
}
