import 'dart:convert';

import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/secrets/presentation/secret_page.dart';
import 'package:dashboard/src/features/sign_up/presentation/sign_up_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.auto_graph),
        label: 'Workflows',
      ),
      NavigationDestination(
        icon: Icon(Icons.lock),
        label: 'Secrets',
      ),
      NavigationDestination(
        icon: Icon(Icons.exit_to_app),
        label: 'Logout',
      ),
    ];

    return AdaptiveScaffold(
      transitionDuration: Duration.zero,
      selectedIndex: index,
      onSelectedIndexChange: (value) async {
        const logoutIndex = 2;
        if (value == logoutIndex) {
          final prefs = await SharedPreferences.getInstance();
          final plist = prefs.getString('googleServiceInfoPlist');
          if (plist == null) {
            await FirebaseAuth.instance.signOut();
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (context) => const SignUpPage(),
              ),
              (route) => false,
            );

            return;
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
          await auth.signOut();
          await prefs.remove('googleServiceInfoPlist');
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (context) => const SignUpPage()),
            (route) => false,
          );
          return;
        }
        setState(() {
          index = value;
        });
      },
      destinations: destinations,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'OpenCI v0.2.0',
            style: TextStyle(fontSize: 16),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
          horizontalMargin20,
        ],
      ),
      body: (_) => _pages[index],
    );
  }
}

final _pages = [
  const WorkflowPage(),
  const SecretPage(),
];
