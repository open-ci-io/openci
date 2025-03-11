enum AppStoreConnectAPIKey {
  keyId,
  issuerId,
  keyBase64;

  String get key {
    switch (this) {
      case AppStoreConnectAPIKey.keyId:
        return 'OPENCI_ASC_KEY_ID';
      case AppStoreConnectAPIKey.issuerId:
        return 'OPENCI_ASC_ISSUER_ID';
      case AppStoreConnectAPIKey.keyBase64:
        return 'OPENCI_ASC_KEY_BASE64';
    }
  }
}
