import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/uuid.dart';

class CreateProject extends HookWidget {
  const CreateProject({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: 'Enter project name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final id = const Uuid().v4();
              final user = FirebaseAuth.instance.currentUser;
              await FirebaseFirestore.instance
                  .collection('organizations')
                  .doc(id)
                  .set({
                'documentId': id,
                'organizationName': textEditingController.value.text,
                'buildNumber': {
                  'ios': 1,
                  'android': 1,
                },
                'editors': [user!.uid]
              });
              textEditingController.clear();
            },
            child: const Text('add'),
          )
        ],
      ),
    );
  }
}
