import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/secrets/presentation/secret_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:signals/signals_flutter.dart';

final _index = signal(0);

class TopPage extends StatelessWidget {
  const TopPage({super.key});

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
    ];

    return AdaptiveScaffold(
      transitionDuration: Duration.zero,
      selectedIndex: _index.watch(context),
      onSelectedIndexChange: (value) => _index.value = value,
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
      body: (_) => _pages[_index.watch(context)],
    );
  }
}

final _pages = [
  const WorkflowPage(),
  const SecretPage(),
];
