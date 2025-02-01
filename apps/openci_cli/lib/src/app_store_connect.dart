import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:openci_cli2/src/certificate_type.dart';
import 'package:openci_cli2/src/profile_type.dart';
import 'package:path/path.dart' as path;

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

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    return {
      'statusCode': response.statusCode,
      'body': responseBody,
    };
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

  /// 開発用の証明書を作成する
  Future<Map<String, dynamic>> createCertificate({
    required String csrContent,
    required String certificateType,
  }) async {
    return _request(
      path: '/certificates',
      method: 'POST',
      body: {
        'data': {
          'type': 'certificates',
          'attributes': {
            'certificateType': certificateType,
            'csrContent': csrContent,
          },
        },
      },
    );
  }

  /// プロビジョニングプロファイルを作成する
  Future<Map<String, dynamic>> createProfile({
    required String name,
    required ProfileType profileType,
    required String bundleId,
    required String certificateId,
  }) async {
    try {
      final response = await _request(
        path: '/profiles',
        method: 'POST',
        body: {
          'data': {
            'type': 'profiles',
            'attributes': {
              'name': name,
              'profileType': profileType.name,
            },
            'relationships': {
              'bundleId': {
                'data': {
                  'type': 'bundleIds',
                  'id': bundleId,
                },
              },
              'certificates': {
                'data': [
                  {
                    'type': 'certificates',
                    'id': certificateId,
                  }
                ],
              },
            },
          },
        },
      );
      return response;
    } catch (e) {
      throw AppStoreConnectError('Failed to create profile: $e');
    }
  }

  Future<Map<String, dynamic>> getProfile({
    required String profileId,
  }) async {
    final response = await _request(
      path: '/profiles/$profileId',
      method: 'GET',
    );
    return response;
  }

  /// プロビジョニングプロファイル一覧を取得する
  Future<Map<String, dynamic>> listProfiles({
    String? filterName,
    CertificateType? filterType,
    String? filterId,
  }) async {
    var path = '/profiles';
    final queryParams = <String>[];

    if (filterName != null) {
      queryParams.add('filter[name]=$filterName');
    }
    if (filterType != null) {
      queryParams.add('filter[profileType]=${filterType.name}');
    }
    if (filterId != null) {
      queryParams.add('filter[id]=$filterId');
    }

    if (queryParams.isNotEmpty) {
      path += '?${queryParams.join('&')}';
    }

    final response = await _request(
      path: path,
      method: 'GET',
    );
    return response;
  }

  Future<Map<String, dynamic>> readCertificate({
    required String certificateId,
  }) async {
    final response = await _request(
      path: '/certificates/$certificateId',
      method: 'GET',
    );
    return response;
  }

  /// 証明書一覧を取得する
  Future<Map<String, dynamic>> listCertificates({
    String? filterSerialNumber,
    String? filterType,
  }) async {
    var path = '/certificates';
    final queryParams = <String>[];

    if (filterSerialNumber != null) {
      queryParams.add('filter[serialNumber]=$filterSerialNumber');
    }
    if (filterType != null) {
      queryParams.add('filter[certificateType]=$filterType');
    }

    if (queryParams.isNotEmpty) {
      path += '?${queryParams.join('&')}';
    }

    final response = await _request(
      path: path,
      method: 'GET',
    );
    return response;
  }

  /// バンドルID一覧を取得する
  Future<Map<String, dynamic>> listBundleIds({
    String? filterIdentifier,
  }) async {
    var path = '/bundleIds';
    final queryParams = <String>[];

    if (filterIdentifier != null && filterIdentifier.isNotEmpty) {
      queryParams.add('filter[identifier]=$filterIdentifier');
    }

    if (queryParams.isNotEmpty) {
      path += '?${queryParams.join('&')}';
    }

    final response = await _request(
      path: path,
      method: 'GET',
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

  // 秘密鍵がPEM形式でない場合は、PEM形式に変換
  final pemKey = privateKey.contains('-----BEGIN PRIVATE KEY-----')
      ? privateKey
      : '''-----BEGIN PRIVATE KEY-----
$privateKey
-----END PRIVATE KEY-----''';

  return jwt.sign(
    ECPrivateKey(pemKey), // RSAPrivateKeyからECPrivateKeyに変更
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

/// CSRと秘密鍵を生成する
Future<({String csrContent, String privateKey})> generateCSR({
  required String commonName,
  required String countryName,
  required String organizationName,
  String? outputKeyPath,
}) async {
  final tempDir = await Directory.systemTemp.createTemp('csr_');
  final keyPath = path.join(tempDir.path, 'private.key');
  final csrPath = path.join(tempDir.path, 'request.csr');

  try {
    // 秘密鍵の生成
    final generateKeyResult = await Process.run('openssl', [
      'genpkey',
      '-algorithm',
      'RSA',
      '-out',
      keyPath,
      '-pkeyopt',
      'rsa_keygen_bits:2048',
    ]);

    if (generateKeyResult.exitCode != 0) {
      throw AppStoreConnectError(
        'Failed to generate private key: ${generateKeyResult.stderr}',
      );
    }

    // CSRの生成
    final generateCsrResult = await Process.run('openssl', [
      'req',
      '-new',
      '-key',
      keyPath,
      '-out',
      csrPath,
      '-subj',
      '/CN=$commonName/C=$countryName/O=$organizationName',
    ]);

    if (generateCsrResult.exitCode != 0) {
      throw AppStoreConnectError(
        'Failed to generate CSR: ${generateCsrResult.stderr}',
      );
    }

    // CSRの内容を読み込む
    final csrContent = await File(csrPath).readAsString();
    final privateKey = await File(keyPath).readAsString();

    return (
      csrContent: csrContent.trim(),
      privateKey: privateKey.trim(),
    );
  } finally {
    // 一時ファイルの削除
    await tempDir.delete(recursive: true);
  }
}
