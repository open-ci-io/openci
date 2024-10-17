import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          try {
                            final user = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                            );
                            final userId = user.user!.uid;
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .set({
                              'userId': userId,
                              'createdAt': Timestamp.now(),
                            });
                          } catch (e) {
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
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      child: const Text('Login'),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                            );
                          } catch (e) {
                            await showErrorDialog(context, e.toString());
                          }
                        }
                      },
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

Future<void> showErrorDialog(BuildContext context, String errorMessage) {
  return showAdaptiveDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Error',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      content: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
  );
}
