import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/extensions/build_context_extension.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:dashboard/src/services/plist.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _defaultProjectId = 'openci-release(default)';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

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
                const _Title(
                  title: 'Welcome to Open CI',
                ),
                verticalMargin40,
                _EmailField(emailTextController: emailTextController),
                verticalMargin16,
                _PasswordField(passwordTextController: passwordTextController),
                verticalMargin24,
                Text('Project ID: ${projectId.value}'),
                verticalMargin24,
                Wrap(
                  runSpacing: 16,
                  children: [
                    RegisterButton(
                      formKey: formKey,
                      emailTextController: emailTextController,
                      passwordTextController: passwordTextController,
                    ),
                    horizontalMargin16,
                    _LoginButton(
                      formKey: formKey,
                      emailTextController: emailTextController,
                      passwordTextController: passwordTextController,
                      projectId: projectId.value,
                    ),
                    horizontalMargin16,
                    _SelectFirebaseProjectButton(
                      projectId: projectId,
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

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.formKey,
    required this.emailTextController,
    required this.passwordTextController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();

          final auth = await getFirebaseAuth();
          try {
            final user = await auth.createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text,
            );
            final userId = user.user!.uid;
            final firestore = await getFirebaseFirestore();
            await firestore.collection('users').doc(userId).set({
              'userId': userId,
              'createdAt': Timestamp.now().microsecondsSinceEpoch,
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
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.formKey,
    required this.emailTextController,
    required this.passwordTextController,
    required this.projectId,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: context.primaryColor,
        ),
      ),
      child: const Text('Login'),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (projectId == _defaultProjectId) {
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
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

          final auth = await getFirebaseAuth();
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
    );
  }
}

class _SelectFirebaseProjectButton extends StatelessWidget {
  const _SelectFirebaseProjectButton({
    required this.projectId,
  });

  final ValueNotifier<String> projectId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
                    final result = await FilePickerMacOS().pickFiles(
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
                    final fileData = await File(filePath).readAsBytes();
                    final parsedPlist = await parseXmlPlist(fileData);
                    final prefs = await SharedPreferences.getInstance();
                    await writePlist(
                      prefs: prefs,
                      key: 'googleServiceInfoPlist',
                      value: jsonEncode(parsedPlist),
                    );
                    projectId.value = '${parsedPlist['PROJECT_ID']}';
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
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.passwordTextController,
  });

  final TextEditingController passwordTextController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.emailTextController,
  });

  final TextEditingController emailTextController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailTextController,
      decoration: const InputDecoration(labelText: 'Email'),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your email';
        }
        return null;
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Welcome to Open CI',
      style: TextStyle(
        fontSize: 26,
        color: Colors.white,
      ),
    );
  }
}
