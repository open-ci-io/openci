import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_cli/src/certificate_type.dart';
import 'package:openci_cli/src/list_certificates.dart';

class ListCertificatesCommand extends Command<int> {
  ListCertificatesCommand() {
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
        'serial-number',
        help: 'Serial Number of the certificate',
      )
      ..addOption(
        'certificate-type',
        help: 'Certificate Type',
        allowed: CertificateType.values.map((e) => e.name).toList(),
      );
  }

  @override
  String get description => 'List Apple Developer Certificates';

  @override
  String get name => 'list-certificates';

  @override
  Future<int> run() async {
    final issuerId = argResults?['issuer-id'] as String?;
    final keyId = argResults?['key-id'] as String?;
    final pathToPrivateKey = argResults?['path-to-private-key'] as String?;
    final serialNumber = argResults?['serial-number'] as String?;
    final certificateType = argResults?['certificate-type'] as String?;
    if (issuerId == null || keyId == null || pathToPrivateKey == null) {
      return ExitCode.usage.code;
    }
    final privateKey = File(pathToPrivateKey).readAsStringSync();

    return listCertificates(
      issuerId: issuerId,
      keyId: keyId,
      privateKey: privateKey,
      serialNumber: serialNumber,
      certificateType: _parseCertificateType(certificateType),
    );
  }

  CertificateType? _parseCertificateType(String? value) {
    if (value == null) return null;
    return CertificateType.values.byName(value);
  }
}
