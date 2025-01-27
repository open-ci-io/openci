import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/app_store_connect.dart';
import 'package:openci_models/openci_models.dart';

Future<int> readCertificate({
  required String issuerId,
  required String keyId,
  required String privateKey,
  required String certificateId,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    final response = await client.readCertificate(
      certificateId: certificateId,
    );

    stdout.write(json.encode(response));
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
