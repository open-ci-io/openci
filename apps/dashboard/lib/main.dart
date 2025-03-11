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
    const inputDecorationBorderWidth = 0.6;
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: OpenCIColors.primary,
          secondary: OpenCIColors.primary,
          surface: OpenCIColors.surface,
          surfaceBright: OpenCIColors.surfaceBright,
          error: OpenCIColors.error,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          fontFamily: 'roboto',
          bodyColor: OpenCIColors.onPrimary,
          displayColor: OpenCIColors.onPrimary,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(18),
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 234, 233, 233),
            fontWeight: FontWeight.w200,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: inputDecorationBorderWidth,
              color: OpenCIColors.onPrimary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: inputDecorationBorderWidth,
              color: OpenCIColors.primary,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: inputDecorationBorderWidth,
              color: OpenCIColors.error,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: OpenCIColors.primaryDark,
            foregroundColor: Colors.black,
          ),
        ),
        expansionTileTheme: const ExpansionTileThemeData(
          shape: LinearBorder.none,
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
