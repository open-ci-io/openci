import 'package:dashboard/src/features/login/presentation/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final controller = ref.watch(loginControllerProvider.notifier);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                cursorColor: Colors.black, // Set cursor color to black
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                cursorColor: Colors.black, // Set cursor color to black
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white, // Set button background color to white
                ),
                onPressed: () => controller.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                ),
                child: const Text(
                  'Login',
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
