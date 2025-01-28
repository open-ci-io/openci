import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/app_store_connect.dart';
import 'package:openci_cli2/src/certificate_type.dart';
import 'package:openci_models/openci_models.dart';

Future<int> listCertificates({
  required String issuerId,
  required String keyId,
  required String privateKey,
  String? serialNumber,
  CertificateType? certificateType,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    final response = await client.listCertificates(
      filterSerialNumber: serialNumber,
      filterType: certificateType?.name,
    );

    final result = SessionResult(
      stdout: json.encode(response),
      stderr: '',
      exitCode: 0,
    );

    stdout.write(json.encode(result.toJson()));
    return ExitCode.success.code;
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
}
