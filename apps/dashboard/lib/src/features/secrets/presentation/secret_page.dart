import 'package:dashboard/colors.dart';
import 'package:dashboard/src/common_widgets/divider.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:dashboard/src/services/firestore/file_picker.dart';
import 'package:dashboard/src/services/firestore/secrets_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class SecretPage extends ConsumerWidget {
  const SecretPage({super.key, required this.firebaseSuite});

  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secrets = ref.watch(secretsStreamProvider(firebaseSuite));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) => _DialogBody(
              firebaseSuite: firebaseSuite,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: secrets.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text('No secrets found'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final secret = OpenCISecret.fromJson(
                  (data[index].data() as Map<String, dynamic>?) ?? {},
                );
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => _DialogBody(
                        firebaseSuite: firebaseSuite,
                        isEditing: true,
                        secretName: secret.name,
                        documentId: data[index].id,
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(
                      Icons.lock_outline,
                      color: OpenCIColors.primaryGreen,
                      size: 20,
                    ),
                    title: Text(
                      secret.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: OpenCIColors.onPrimary,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const OpenCIDivider(),
            ),
          );
        },
        error: (error, stack) => Text('Error: $error'),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class _DialogBody extends HookConsumerWidget {
  const _DialogBody({
    this.secretName,
    this.isEditing = false,
    this.documentId,
    required this.firebaseSuite,
  });

  final String? secretName;
  final bool isEditing;
  final String? documentId;
  final OpenCIFirebaseSuite firebaseSuite;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyController = useTextEditingController(text: secretName ?? '');
    final valueController = useTextEditingController(text: '');
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isEditing ? 'Edit Secret' : 'Add Secret'),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: OpenCIColors.onPrimary),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: screenWidth / 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(keyController.text),
                ),
              if (!isEditing)
                TextField(
                  controller: keyController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              const SizedBox(height: 24),
              TextField(
                minLines: 4,
                maxLines: null,
                controller: valueController,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {},
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: OpenCIColors.error,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final result = await pickFileAsBase64();
                      if (result == null) {
                        return;
                      }
                      valueController.text = result;
                    },
                    child: const Text(
                      'Select File',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (keyController.text.isEmpty ||
                          valueController.text.isEmpty) {
                        return;
                      }
                      if (isEditing) {
                        await firebaseSuite.firestore
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
                        await firebaseSuite.firestore
                            .collection(secretsCollectionPath)
                            .add({
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
      ),
    );
  }
}
