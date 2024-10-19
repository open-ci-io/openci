import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/extensions/build_context_extension.dart';
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
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
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
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailTextController.text,
                              password: passwordTextController.text,
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
