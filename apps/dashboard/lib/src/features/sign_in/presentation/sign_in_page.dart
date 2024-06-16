import 'package:dashboard/src/features/menu/presentation/menu_page.dart';
import 'package:dashboard/src/features/sign_in/presentation/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(signInControllerProvider.notifier);
    final email = useTextEditingController();
    final password = useTextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white, // Set button background color to white
                ),
                onPressed: () async {
                  try {
                    await controller.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MenuPage()),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.black, // Set text color to black
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
