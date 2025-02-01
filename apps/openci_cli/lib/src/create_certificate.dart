import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/app_store_connect.dart';

Future<int> createCertificate({
  required String issuerId,
  required String keyId,
  required String privateKey,
  required String certificateType,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  Map<String, dynamic> response;

  try {
    final csr = await generateCSR(
      commonName: 'OpenCI',
      countryName: 'JP',
      organizationName: 'OpenCI',
    );

    response = await client.createCertificate(
      csrContent: csr.csrContent,
      certificateType: certificateType,
    );

    if (response['statusCode'] == 201 || response['statusCode'] == 200) {
      final base64Key = base64Encode(utf8.encode(csr.privateKey));
      response = {
        ...response,
        'key': base64Key,
      };
    }

    stdout.write(jsonEncode(response));
    return ExitCode.success.code;
  } catch (e) {
    final result = {
      'stderr': e.toString(),
      'exitCode': 1,
    };
    stdout.write(jsonEncode(result));
    return 1;
  } finally {
    client.dispose();
  }
}
