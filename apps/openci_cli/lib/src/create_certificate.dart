import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/app_store_connect.dart';
import 'package:openci_models/openci_models.dart';

Future<int> createCertificate({
  required String issuerId,
  required String keyId,
  required String privateKey,
  String? certificateId,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    final csr = await generateCSR(
      commonName: 'OpenCI',
      countryName: 'JP',
      organizationName: 'OpenCI',
    );

    final response = await client.createCertificate(
      csrContent: csr.csrContent,
      certificateType: 'IOS_DEVELOPMENT',
    );

    final result = SessionResult(
      stdout: json.encode(response),
      stderr: '',
      exitCode: 0,
    );

    stdout.write(json.encode(result.toJson()));
  } catch (e) {
    final result = SessionResult(
      stdout: '',
      stderr: e.toString(),
      exitCode: 1,
    );
    stdout.write(json.encode(result.toJson()));
    return 1;
  } finally {
    client.dispose();
  }
  return ExitCode.success.code;
}
