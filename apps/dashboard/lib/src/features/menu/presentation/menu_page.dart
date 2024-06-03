import 'package:dashboard/src/features/edit/edit_organizations/presentation/edit_org_page.dart';
import 'package:dashboard/src/features/edit/edit_workflow/presentation/edit_workflow_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditOrgPage()),
                );
              },
              child: const Text('Edit org'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditWorkflowPage()),
                );
              },
              child: const Text('Edit workflow'),
            ),
          ],
        ),
      ),
    );
  }
}
