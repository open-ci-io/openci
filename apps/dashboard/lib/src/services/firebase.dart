import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/services/plist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:openci_models/openci_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<FirebaseOptions?> getFirebaseOptions({SharedPreferences? prefs}) async {
  final plist = await readPlist(prefs: prefs);
  if (plist == null) {
    return null;
  }
  final plistMap = jsonDecode(plist) as Map<String, dynamic>;
  final options = OpenCIFirebaseOptions.fromPlist(plistMap);

  return FirebaseOptions(
    apiKey: options.apiKey,
    appId: options.appId,
    messagingSenderId: options.messagingSenderId,
    projectId: options.projectId,
  );
}

Future<FirebaseAuth> getFirebaseAuth() async {
  final options = await getFirebaseOptions();
  if (options == null) {
    return FirebaseAuth.instance;
  }
  final apps = await Firebase.initializeApp(
    name: options.projectId,
    options: options,
  );

  return FirebaseAuth.instanceFor(app: apps);
}

Future<FirebaseFirestore> getFirebaseFirestore() async {
  final options = await getFirebaseOptions();
  if (options == null) {
    return FirebaseFirestore.instance;
  }
  final apps = await Firebase.initializeApp(
    name: options.projectId,
    options: options,
  );

  return FirebaseFirestore.instanceFor(app: apps);
}

String getDocumentId() => const Uuid().v4();
