/// Extracts the key ID from the ASC .p8 file name.
///
/// The key ID is the last 10 characters of the second part of the filename.
///
/// Example:
/// - AuthKey_1234567890.p8 -> 1234567890
/// - AuthKey_1234567890(1).p8 -> 1234567890
String? getASCKeyId(String fileName) {
  final split = fileName.split('_');
  if (split.length < 2) {
    return null;
  }
  const keyIdLength = 10;
  final keyId = split[1].substring(0, keyIdLength);
  return keyId;
}
