import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/build/presentation/build_page.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

final _index = signal(0);

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'OpenCI v0.2.0',
            style: TextStyle(
              fontSize: 16,
            ),
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
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            selectedIndex: _index.watch(context),
            onDestinationSelected: (value) {
              _index.value = value;
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.auto_graph),
                label: Text(
                  'Workflows',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build),
                label: Text(
                  'Builds',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
            child: _pages[_index.watch(context)],
          ),
        ],
      ),
    );
  }
}

final _pages = [
  const WorkflowPage(),
  const BuildPage(),
];
