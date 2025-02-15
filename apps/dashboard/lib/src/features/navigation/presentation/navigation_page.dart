import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/secrets/presentation/secret_page.dart';
import 'package:dashboard/src/features/welcome_page/presentation/welcome_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list_page.dart';
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

    return FutureBuilder(
      future: getOpenCIFirebaseSuite(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error occurred'),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const Scaffold(
            body: Center(
              child: Text('No data found'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return AdaptiveScaffold(
          transitionDuration: Duration.zero,
          selectedIndex: index,
          onSelectedIndexChange: (value) async {
            const logoutIndex = 2;
            if (value == logoutIndex) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('googleServiceInfoPlist');
              await data.auth.signOut();
              await pushAndRemoveUntil(context, const WelcomePage());
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
                onPressed: () async {
                  await data.auth.signOut();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('googleServiceInfoPlist');
                  await pushAndRemoveUntil(context, const WelcomePage());
                },
                icon: const Icon(Icons.logout),
              ),
              horizontalMargin20,
            ],
          ),
          body: (_) => _pages(data)[index],
        );
      },
    );
  }
}

List<Widget> _pages(OpenCIFirebaseSuite firebaseSuite) {
  return [
    WorkflowListPage(firebaseSuite: firebaseSuite),
    SecretPage(firebaseSuite: firebaseSuite),
  ];
}

Future<OpenCIFirebaseSuite> getOpenCIFirebaseSuite() async {
  final auth = await getFirebaseAuth();
  final firestore = await getFirebaseFirestore();
  return OpenCIFirebaseSuite(auth: auth, firestore: firestore);
}

class OpenCIFirebaseSuite {
  OpenCIFirebaseSuite({
    required this.auth,
    required this.firestore,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
}
