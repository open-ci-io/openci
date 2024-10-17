import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Open CI'),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailTextController,
                  decoration: const InputDecoration(labelText: 'Email'),
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
                  decoration: const InputDecoration(labelText: 'Password'),
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
                      child: const Text('Register'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          print(
                              'Email: ${emailTextController.text}, Password: ${passwordTextController.text}');
                        }
                      },
                    ),
                    horizontalMargin16,
                    ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          print(
                              'Email: ${emailTextController.text}, Password: ${passwordTextController.text}');
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
