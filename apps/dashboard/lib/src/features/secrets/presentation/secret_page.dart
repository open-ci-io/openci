import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/common_widgets/dialogs.dart';
import 'package:dashboard/src/features/secrets/presentation/secrets.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class SecretPage extends ConsumerWidget {
  const SecretPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) => const _DialogBody(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: secrets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Secrets found'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final secret = OpenCISecret.fromJson(
                  data[index].data()! as Map<String, dynamic>,
                );
                return Card(
                  elevation: 0,
                  child: ListTile(
                    title: Text(secret.key),
                    subtitle: Text(
                      secret.value.length > 16
                          ? secret.value
                              .substring(0, 16)
                              .replaceAll(RegExp(r'.'), '*')
                          : secret.value.replaceAll(RegExp(r'.'), '*'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) => _DialogBody(
                                secretKey: secret.key,
                                secretValue: secret.value,
                                documentId: data[index].id,
                                isEditing: true,
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            showDeleteDialog(
                              title: 'Delete Secret',
                              context: context,
                              onDelete: () {
                                FirebaseFirestore.instance
                                    .collection(secretsCollectionPath)
                                    .doc(data[index].id)
                                    .delete();
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _DialogBody extends HookConsumerWidget {
  const _DialogBody({
    this.secretKey,
    this.secretValue,
    this.isEditing = false,
    this.documentId,
  });

  final String? secretKey;
  final String? secretValue;
  final bool isEditing;
  final String? documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyController = useTextEditingController(text: secretKey ?? '');
    final valueController = useTextEditingController(text: secretValue ?? '');
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Edit Secret' : 'Add Secret',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result == null) {
                      return;
                    }
                    final file = result.files.first;
                    final bytes = await file.xFile.readAsBytes();
                    valueController.text = base64Encode(bytes);
                  },
                  child: const Text('Select File'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () async {
                    final firestore = await getFirebaseFirestore();
                    if (keyController.text.isEmpty ||
                        valueController.text.isEmpty) {
                      return;
                    }
                    if (isEditing) {
                      await firestore
                          .collection(secretsCollectionPath)
                          .doc(documentId)
                          .update({
                        'key': keyController.text,
                        'value': valueController.text,
                        'updatedAt': DateTime.now().millisecondsSinceEpoch,
                      });
                    } else {
                      final auth = await getFirebaseAuth();
                      final uid = auth.currentUser!.uid;
                      await firestore.collection(secretsCollectionPath).add({
                        'key': keyController.text,
                        'value': valueController.text,
                        'owners': [uid],
                        'createdAt': DateTime.now().millisecondsSinceEpoch,
                        'updatedAt': DateTime.now().millisecondsSinceEpoch,
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(isEditing ? 'Update' : 'Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
