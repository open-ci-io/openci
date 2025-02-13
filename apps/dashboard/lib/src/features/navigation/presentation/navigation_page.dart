import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/secrets/presentation/secret_page.dart';
import 'package:dashboard/src/features/welcome_page/presentation/welcome_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          final auth = await getFirebaseAuth();
          await auth.signOut();
          await prefs.remove('googleServiceInfoPlist');
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (context) => const WelcomePage()),
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
