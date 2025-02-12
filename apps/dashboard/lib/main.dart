import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/welcome_page/presentation/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

const Color primaryColor = Color(0xff03dac6);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
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
    final prefs = await SharedPreferences.getInstance();
    final plist = prefs.getString('googleServiceInfoPlist');

    if (plist == null) {
      return FirebaseAuth.instance.currentUser;
    }
    final plistMap = jsonDecode(plist) as Map<String, dynamic>;

    final apps = await Firebase.initializeApp(
      name: plistMap['PROJECT_ID'] as String,
      options: FirebaseOptions(
        apiKey: plistMap['API_KEY'] as String,
        appId: plistMap['GOOGLE_APP_ID'] as String,
        messagingSenderId: plistMap['GCM_SENDER_ID'] as String,
        projectId: plistMap['PROJECT_ID'] as String,
      ),
    );
    final auth = FirebaseAuth.instanceFor(
      app: apps,
    );
    final user = auth.currentUser;
    return user;
  }
}
