import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/colors.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/welcome_page/presentation/welcome_page.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  await SentryFlutter.init(
    (options) {
      options
        ..debug = false
        ..dsn =
            'https://55f0d94b6b860cada9f108ff096fed75@o4507005123166208.ingest.us.sentry.io/4508619657510912';
    },
    appRunner: () => runApp(const ProviderScope(child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: OpenCIColors.primary,
          secondary: OpenCIColors.primary,
          surface: OpenCIColors.surface,
          error: OpenCIColors.error,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: OpenCIColors.onPrimary,
          displayColor: OpenCIColors.onPrimary,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: OpenCIColors.onPrimary),
          hintStyle: TextStyle(color: OpenCIColors.onPrimary),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: OpenCIColors.onPrimary),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: OpenCIColors.primary),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: OpenCIColors.primaryDark,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      navigatorKey: navigatorKey,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NavigationPage();
        }
        return const WelcomePage();
      },
    );
  }

  Future<User?> future() async {
    final auth = await getFirebaseAuth();
    return auth.currentUser;
  }
}
