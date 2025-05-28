import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/dialogs/alert_dialog.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/action.dart';
import 'package:dashboard/src/features/intent.dart';
import 'package:dashboard/src/features/secrets/presentation/secret_page.dart';
import 'package:dashboard/src/features/welcome_page/presentation/welcome_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/workflow_list_page.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
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

    final future = ref.watch(openciFirebaseSuiteProvider);

    return future.when(
      data: (data) {
        return Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.digit1, meta: true):
                ChangeIndexIntent(0),
            SingleActivator(LogicalKeyboardKey.digit2, meta: true):
                ChangeIndexIntent(1),
            SingleActivator(LogicalKeyboardKey.digit3, meta: true):
                LogoutIntent(),
          },
          child: Actions(
            actions: {
              ChangeIndexIntent: ChangeIndexAction(
                onIndexChanged: (index) {
                  setState(() => this.index = index);
                },
              ),
              LogoutIntent: LogoutAction(
                onLogout: () => _showLogoutDialog(context, data),
              ),
            },
            child: Focus(
              autofocus: true,
              child: Builder(
                builder: (builderContext) {
                  return AdaptiveScaffold(
                    transitionDuration: Duration.zero,
                    selectedIndex: index,
                    onSelectedIndexChange: (value) async {
                      const logoutIndex = 2;
                      if (value == logoutIndex) {
                        Actions.invoke(
                          builderContext,
                          const LogoutIntent(),
                        );
                        return;
                      }
                      setState(() => index = value);
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
                            Actions.invoke(
                              builderContext,
                              const LogoutIntent(),
                            );
                          },
                          icon: const Icon(Icons.logout),
                        ),
                        horizontalMargin20,
                      ],
                    ),
                    body: (_) => _pages(data)[index],
                  );
                },
              ),
            ),
          ),
        );
      },
      error: (error, stack) => const Scaffold(
        body: Center(
          child: Text('An error occurred'),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
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

class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.title,
    required this.onConfirm,
  });

  final String title;
  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): PopIntent(),
      },
      child: Actions(
        actions: {
          PopIntent: PopAction(
            onPop: () => Navigator.of(context).maybePop(),
          ),
        },
        child: Focus(
          autofocus: true,
          child: OpenCIAlertDialog(
            title: title,
            body: 'Are you sure you want to logout?',
            confirmButtonText: 'Logout',
            onConfirm: onConfirm,
          ),
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context, OpenCIFirebaseSuite data) {
  showAdaptiveDialog<void>(
    context: context,
    builder: (context) => _Dialog(
      title: 'Logout',
      onConfirm: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('googleServiceInfoPlist');
        await data.auth.signOut();
        await pushAndRemoveUntil(
          context,
          const WelcomePage(),
        );
      },
    ),
  );
}
