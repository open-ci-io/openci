import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/extensions/build_context_extension.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _defaultProjectId = 'openci-release(default)';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final projectId = useState(_defaultProjectId);
    final screenWidth = context.screenWidth;
    final formKey = useMemoized(GlobalKey<FormState>.new);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Open CI',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                verticalMargin40,
                TextFormField(
                  controller: emailTextController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
                verticalMargin16,
                TextFormField(
                  controller: passwordTextController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                verticalMargin24,
                Text('Project ID: ${projectId.value}'),
                verticalMargin24,
                Wrap(
                  runSpacing: 16,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          final prefs = await SharedPreferences.getInstance();
                          final plist =
                              prefs.getString('googleServiceInfoPlist');
                          if (plist == null) {
                            return;
                          }
                          final plistMap =
                              jsonDecode(plist) as Map<String, dynamic>;

                          final apps = await Firebase.initializeApp(
                            name: plistMap['PROJECT_ID'] as String,
                            options: FirebaseOptions(
                              apiKey: plistMap['API_KEY'] as String,
                              appId: plistMap['GOOGLE_APP_ID'] as String,
                              messagingSenderId:
                                  plistMap['GCM_SENDER_ID'] as String,
                              projectId: plistMap['PROJECT_ID'] as String,
                            ),
                          );
                          final auth = FirebaseAuth.instanceFor(
                            app: apps,
                          );
                          try {
                            final user =
                                await auth.createUserWithEmailAndPassword(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                            );
                            final userId = user.user!.uid;
                            final firestore =
                                FirebaseFirestore.instanceFor(app: apps);
                            await firestore
                                .collection('users')
                                .doc(userId)
                                .set({
                              'userId': userId,
                              'createdAt':
                                  Timestamp.now().microsecondsSinceEpoch,
                            });
                          } on FirebaseAuthException catch (e) {
                            await showErrorDialog(
                              context,
                              e.message ?? 'An error occurred',
                            );
                          } on Exception catch (e) {
                            await showErrorDialog(context, e.toString());
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                    horizontalMargin16,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: context.primaryColor,
                        ),
                      ),
                      child: const Text('Login'),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (projectId.value == _defaultProjectId) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: emailTextController.text,
                                password: passwordTextController.text,
                              );
                              await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute<void>(
                                  builder: (context) => const NavigationPage(),
                                ),
                                (route) => false,
                              );
                            } on FirebaseAuthException catch (e) {
                              await showErrorDialog(
                                context,
                                e.message ?? 'An error occurred',
                              );
                            } on Exception catch (e) {
                              await showErrorDialog(context, e.toString());
                            }
                            return;
                          }
                          final options = await getFirebaseOptions();

                          final apps = await Firebase.initializeApp(
                            name: options.projectId,
                            options: options,
                          );
                          final auth = FirebaseAuth.instanceFor(
                            app: apps,
                          );
                          try {
                            await auth.signInWithEmailAndPassword(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                            );
                            await Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute<void>(
                                builder: (context) => const NavigationPage(),
                              ),
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            await showErrorDialog(
                              context,
                              e.message ?? 'An error occurred',
                            );
                          } on Exception catch (e) {
                            await showErrorDialog(context, e.toString());
                          }
                        }
                      },
                    ),
                    horizontalMargin16,
                    ElevatedButton(
                      onPressed: () async {
                        await showAdaptiveDialog<void>(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  child: Text(
                                    'Please select your GoogleService-Info.plist \n\nOpenCI will use this to authenticate your account but will not see it.',
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final result =
                                        await FilePickerMacOS().pickFiles(
                                      allowedExtensions: ['plist'],
                                      type: FileType.custom,
                                    );
                                    if (result == null) {
                                      return;
                                    }
                                    final file = result.files.first;
                                    final filePath = file.path;
                                    if (filePath == null) {
                                      return;
                                    }
                                    final fileData =
                                        await File(filePath).readAsBytes();
                                    final parsedPlist =
                                        await parseXmlPlist(fileData);
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                      'googleServiceInfoPlist',
                                      jsonEncode(parsedPlist),
                                    );
                                    projectId.value =
                                        '${parsedPlist['PROJECT_ID']}';
                                    Navigator.pop(context);
                                  },
                                  child: const Text('SELECT'),
                                ),
                                verticalMargin8,
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: context.primaryColor,
                        ),
                      ),
                      child: const Text('Use My Firebase Project'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> _readPlist() async {
  final prefs = await SharedPreferences.getInstance();
  final result = prefs.getString('googleServiceInfoPlist');
  if (result == null) {
    throw Exception('No plist found');
  }
  return result;
}

Future<FirebaseOptions> getFirebaseOptions() async {
  final plist = await _readPlist();
  final plistMap = jsonDecode(plist) as Map<String, dynamic>;
  final options = OpenCIFirebaseOptions.fromPlist(plistMap);
  return FirebaseOptions(
    apiKey: options.apiKey,
    appId: options.appId,
    messagingSenderId: options.messagingSenderId,
    projectId: options.projectId,
  );
}

/// Firebase data for creating a new Firebase app
class OpenCIFirebaseOptions {
  OpenCIFirebaseOptions({
    required this.projectId,
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
  });

  factory OpenCIFirebaseOptions.fromPlist(Map<String, dynamic> plist) {
    return OpenCIFirebaseOptions(
      projectId: plist['PROJECT_ID'] as String,
      apiKey: plist['API_KEY'] as String,
      appId: plist['GOOGLE_APP_ID'] as String,
      messagingSenderId: plist['GCM_SENDER_ID'] as String,
    );
  }

  final String projectId;
  final String apiKey;
  final String appId;
  final String messagingSenderId;
}

Future<Map<String, dynamic>> parseXmlPlist(Uint8List fileData) async {
  if (fileData.isEmpty) {
    throw Exception('File data is empty.');
  }

  final plistString = String.fromCharCodes(fileData);
  final dynamic plist =
      PropertyListSerialization.propertyListWithString(plistString);

  if (plist is Map<String, dynamic>) {
    return plist;
  }
  throw Exception('Parsed plist is not a Map<String, dynamic>.');
}
