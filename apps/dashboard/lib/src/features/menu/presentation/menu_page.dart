import 'package:dashboard/src/features/edit/edit_organizations/presentation/edit_org_page.dart';
import 'package:dashboard/src/features/edit/edit_workflow/presentation/edit_workflow_page.dart';
import 'package:dashboard/src/features/workflow/create/presentation/create_workflow_page.dart';
import 'package:dashboard/src/features/project/create/presentation/create_project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  Future<void> _launchUrl(String url) async {
    final url0 = Uri.parse(url);

    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  }

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
              onTap: () =>
                  _launchUrl('https://github.com/apps/open-ci-app-dev'),
              child: const Text('0. Install OpenCI'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateProject()),
                );
              },
              child: const Text('1. Create a project'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateWorkflowPage()),
                );
              },
              child: const Text('2. Create a workflow'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditOrgPage()),
                );
              },
              child: const Text('3. Edit a project'),
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
              child: const Text('4. Edit workflows'),
            ),
          ],
        ),
      ),
    );
  }
}
