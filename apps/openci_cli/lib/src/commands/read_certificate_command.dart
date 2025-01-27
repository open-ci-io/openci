import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/read_certificate.dart';

class ReadCertificateCommand extends Command<int> {
  ReadCertificateCommand() {
    argParser
      ..addOption(
        'issuer-id',
        help: 'App Store Connect Issuer ID',
      )
      ..addOption(
        'key-id',
        help: 'App Store Connect Key ID',
      )
      ..addOption(
        'path-to-private-key',
        help: 'Path to App Store Connect Private Key, p8 file',
      )
      ..addOption(
        'certificate-id',
        help: 'Certificate ID',
      );
  }

  @override
  String get description => 'Read a Apple Developer Certificate';

  @override
  String get name => 'read-certificate';

  @override
  Future<int> run() async {
    final issuerId = argResults?['issuer-id'] as String?;
    final keyId = argResults?['key-id'] as String?;
    final pathToPrivateKey = argResults?['path-to-private-key'] as String?;
    final certificateId = argResults?['certificate-id'] as String?;
    if (issuerId == null ||
        keyId == null ||
        pathToPrivateKey == null ||
        certificateId == null) {
      return ExitCode.usage.code;
    }
    final privateKey = File(pathToPrivateKey).readAsStringSync();

    return readCertificate(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
      certificateId: certificateId,
    );
  }
}
