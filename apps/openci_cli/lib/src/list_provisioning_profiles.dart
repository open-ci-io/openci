import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/app_store_connect.dart';
import 'package:openci_cli2/src/certificate_type.dart';
import 'package:openci_models/openci_models.dart';

Future<int> listProvisioningProfiles({
  required String issuerId,
  required String keyId,
  required String privateKey,
  String? filterName,
  CertificateType? filterType,
  String? filterId,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    final response = await client.listProfiles(
      filterName: filterName,
      filterType: filterType,
      filterId: filterId,
    );

    final result = SessionResult(
      stdout: jsonEncode(response),
      stderr: '',
      exitCode: 0,
    );

    stdout.write(result.toJson());
    return ExitCode.success.code;
  } catch (e) {
    final result = SessionResult(
      stdout: '',
      stderr: e.toString(),
      exitCode: 1,
    );
    stdout.write(result.toJson());
    return 1;
  } finally {
    client.dispose();
  }
}
