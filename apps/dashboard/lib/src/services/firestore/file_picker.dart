import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

/// Picks a file and returns the base64 encoded string.
Future<String?> pickFileAsBase64() async {
  final result = await pickFile();
  if (result == null) {
    return null;
  }
  return xFileToBase64(result);
}

Future<XFile?> pickFile() async {
  final result = await FilePicker.platform.pickFiles();
  if (result == null) {
    return null;
  }
  return result.files.first.xFile;
}

Future<String> xFileToBase64(XFile xFile) async {
  final bytes = await xFile.readAsBytes();
  return base64Encode(bytes);
}
