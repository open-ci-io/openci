import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/app_store_connect.dart';

Future<int> runApp({
  required String issuerId,
  required String keyId,
  required String privateKey,
}) async {
  final client = AppStoreConnectClient(
    issuerId: issuerId,
    keyId: keyId,
    privateKey: privateKey,
  );

  try {
    // アプリ情報を取得
    // final appInfo = await client.getApp(bundleId: 'com.example.app');

    // // ビルド情報を取得
    // final buildInfo = await client.getBuild(buildId: 'build-id');

    // TestFlightに提出
    await client.submitForBetaReview(buildId: 'build-id');
  } catch (e) {
    return ExitCode.software.code;
  } finally {
    client.dispose();
  }
  return ExitCode.success.code;
}
