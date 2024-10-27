import 'package:dashboard/src/features/sign_up/presentation/sign_up_page.dart';
import 'package:dashboard/src/features/top/presentation/top_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const TopPage();
        }
        return const SignUpPage();
      },
    );
  }
}
