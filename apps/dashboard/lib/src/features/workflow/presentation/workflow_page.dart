import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkflowPage extends StatelessWidget {
  const WorkflowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
          horizontalMargin20,
        ],
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'Workflow Page',
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            onPressed: () async {},
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
