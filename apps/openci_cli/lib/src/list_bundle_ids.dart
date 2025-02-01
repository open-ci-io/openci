import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli2/src/app_store_connect.dart';

Future<int> listBundleIds({
  required String issuerId,
  required String keyId,
  required String privateKey,
  String? filterIdentifier,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    final response = await client.listBundleIds(
      filterIdentifier: filterIdentifier,
    );

    stdout.write(jsonEncode(response));
    return ExitCode.success.code;
  } catch (e) {
    stdout.write(e.toString());
    return 1;
  } finally {
    client.dispose();
  }
}
