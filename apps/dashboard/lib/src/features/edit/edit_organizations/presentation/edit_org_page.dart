import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class EditOrgPage extends HookConsumerWidget {
  const EditOrgPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();

    return Scaffold(
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('organizations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data?.docs[index];
                    return ListTile(
                      title: Text('${doc?.data()}'),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Enter organization name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final id = const Uuid().v4();
                    await FirebaseFirestore.instance
                        .collection('organizations')
                        .doc(id)
                        .set({
                      'documentId': id,
                      'organizationName': textEditingController.value.text,
                      'buildNumber': {
                        'ios': 0,
                        'android': 0,
                      }
                    });
                    textEditingController.clear();
                  },
                  child: const Text('add'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
