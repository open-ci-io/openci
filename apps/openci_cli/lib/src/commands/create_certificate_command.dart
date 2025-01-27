import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/certificate_type.dart';
import 'package:openci_cli/src/create_certificate.dart';

class CreateCertificateCommand extends Command<int> {
  CreateCertificateCommand() {
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
        'certificate-type',
        help: 'Certificate Type',
        allowed: CertificateType.values.map((e) => e.name).toList(),
      );
  }

  @override
  String get description => 'Create a Apple Developer Certificate';

  @override
  String get name => 'create-certificate';

  @override
  Future<int> run() async {
    final issuerId = argResults?['issuer-id'] as String?;
    final keyId = argResults?['key-id'] as String?;
    final pathToPrivateKey = argResults?['path-to-private-key'] as String?;
    final certificateType = argResults?['certificate-type'] as String?;

    if (issuerId == null ||
        keyId == null ||
        pathToPrivateKey == null ||
        certificateType == null) {
      return ExitCode.usage.code;
    }
    final privateKey = File(pathToPrivateKey).readAsStringSync();

    return createCertificate(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
      certificateType: certificateType,
    );
  }
}
