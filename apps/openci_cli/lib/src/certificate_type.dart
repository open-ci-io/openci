// ignore_for_file: constant_identifier_names

enum CertificateType {
  IOS_DEVELOPMENT,
  IOS_DISTRIBUTION,
  MAC_APP_DEVELOPMENT,
  MAC_APP_DISTRIBUTION,
  MAC_INSTALLER_DISTRIBUTION,
  DEVELOPER_ID_KEXT,
  DEVELOPER_ID_KEXT_G2,
  DEVELOPER_ID_APPLICATION,
  DEVELOPER_ID_APPLICATION_G2,
  DEVELOPMENT,
  DISTRIBUTION,
  PASS_TYPE_ID,
  PASS_TYPE_ID_WITH_NFC;
}

extension CertificateTypeExtension on CertificateType {
  CertificateType fromName(String name) {
    return CertificateType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => CertificateType.IOS_DEVELOPMENT,
    );
  }
}
