import 'dart:typed_data';

import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> parseXmlPlist(Uint8List fileData) async {
  if (fileData.isEmpty) {
    throw PlistException('Uint8List data is empty.');
  }

  final plistString = String.fromCharCodes(fileData);
  final plist = PropertyListSerialization.propertyListWithString(plistString);

  if (plist is Map<String, dynamic>) {
    return plist;
  }
  throw PlistException('Parsed plist is not a Map<String, dynamic>.');
}

Future<String?> readPlist({SharedPreferences? prefs}) async {
  prefs ??= await SharedPreferences.getInstance();
  final result = prefs.getString('googleServiceInfoPlist');

  if (result != null) {
    return result;
  }
  return null;
}

Future<void> writePlist({
  SharedPreferences? prefs,
  required String key,
  required String value,
}) async {
  prefs ??= await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

class PlistException implements Exception {
  PlistException(this.message);

  final String message;
}
