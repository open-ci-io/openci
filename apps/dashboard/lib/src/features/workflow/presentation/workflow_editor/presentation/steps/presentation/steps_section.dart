import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/main.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/secrets/presentation/secret_page_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class StepsSection extends ConsumerWidget {
  const StepsSection(this.workflowModel, {super.key});

  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowEditorControllerProvider(workflowModel).notifier);
    final state = ref.watch(workflowEditorControllerProvider(workflowModel));
    final steps = state.steps;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => controller.addStepByIndex(steps.length),
                ),
              ],
            ),
            verticalMargin16,
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              onReorder: controller.reorderStep,
              itemBuilder: (_, index) {
                return _StepItem(
                  key: UniqueKey(),
                  step: steps[index],
                  index: index,
                  workflowModel: workflowModel,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends HookConsumerWidget {
  const _StepItem({
    super.key,
    required this.step,
    required this.index,
    required this.workflowModel,
  });

  final WorkflowModelStep step;
  final int index;
  final WorkflowModel workflowModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(workflowEditorControllerProvider(workflowModel).notifier);
    final stepNameTextEditingController =
        useTextEditingController(text: step.name);
    final commandTextEditingController =
        useTextEditingController(text: step.command);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: stepNameTextEditingController,
              decoration: const InputDecoration(
                labelText: 'Step Name',
                border: OutlineInputBorder(),
              ),
            ),
            verticalMargin16,
            _Command(
              commandTextEditingController,
            ),
            verticalMargin8,
            TextButton(
              onPressed: () async {
                await showAdaptiveDialog<void>(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => Consumer(
                    builder: (context, ref, child) {
                      final stream = ref.watch(secretStreamProvider);
                      return Dialog(
                        child: stream.when(
                          data: (data) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                verticalMargin8,
                                const Text(
                                  'Secrets',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                verticalMargin8,
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.docs.length,
                                  itemBuilder: (context, index) {
                                    final secret = data.docs[index].data()!
                                        as Map<String, dynamic>;
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          secret['key'].toString(),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                              ClipboardData(
                                                text: '\$${secret['key']}',
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Secret copied to clipboard',
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.copy),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                          error: (error, stackTrace) {
                            return const Text('Error');
                          },
                          loading: () {
                            return const Text('Loading');
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              child: const Text('Show Secrets'),
            ),
            verticalMargin8,
            TextButton(
              onPressed: () async {
                controller
                  ..updateStepName(
                    index,
                    stepNameTextEditingController.text,
                  )
                  ..updateCommand(
                    index,
                    commandTextEditingController.text,
                  );

                final state = navigatorKey.currentState;

                if (commandTextEditingController.text
                    .contains('flutter build ipa')) {
                  final isAppStoreConnectApiKeyUploaded =
                      await _isAppStoreConnectApiKeyUploaded();
                  if (state == null) {
                    return;
                  }
                  if (isAppStoreConnectApiKeyUploaded) {
                    return;
                  }

                  final issuerIdController = TextEditingController();
                  final keyIdController = TextEditingController();
                  final keyFileController = TextEditingController();

                  await showAdaptiveDialog<void>(
                    context: state.context,
                    builder: (context) => AlertDialog(
                      title: const Text('AppStore Connect API Key'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'To run flutter build ipa, you need to upload AppStore Connect API Key',
                          ),
                          verticalMargin8,
                          TextFormField(
                            controller: issuerIdController,
                            decoration: const InputDecoration(
                              labelText: 'issuer-id',
                            ),
                          ),
                          TextFormField(
                            controller: keyIdController,
                            decoration: const InputDecoration(
                              labelText: 'key-id',
                            ),
                          ),
                          TextFormField(
                            controller: keyFileController,
                            decoration: InputDecoration(
                              labelText: '.p8 key file, base64 encoded',
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final keyFile =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['p8'],
                                  );
                                  if (keyFile == null) {
                                    return;
                                  }

                                  final path = keyFile.files.first.path;
                                  if (path == null) {
                                    return;
                                  }

                                  final bytes = await File(path).readAsBytes();
                                  final keyFileContentBase64 =
                                      base64Encode(bytes);
                                  keyFileController.text = keyFileContentBase64;
                                },
                                icon: const Icon(Icons.folder),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(secretsCollectionPath)
                                  .add({
                                'key': 'OPENCI_ASC_ISSUER_ID',
                                'value': issuerIdController.text,
                                'owners': [
                                  FirebaseAuth.instance.currentUser!.uid,
                                ],
                                'createdAt':
                                    DateTime.now().millisecondsSinceEpoch,
                                'updatedAt':
                                    DateTime.now().millisecondsSinceEpoch,
                              });

                              await FirebaseFirestore.instance
                                  .collection(secretsCollectionPath)
                                  .add({
                                'key': 'OPENCI_ASC_KEY_ID',
                                'value': keyIdController.text,
                                'owners': [
                                  FirebaseAuth.instance.currentUser!.uid,
                                ],
                                'createdAt':
                                    DateTime.now().millisecondsSinceEpoch,
                                'updatedAt':
                                    DateTime.now().millisecondsSinceEpoch,
                              });

                              await FirebaseFirestore.instance
                                  .collection(secretsCollectionPath)
                                  .add({
                                'key': 'OPENCI_ASC_KEY_BASE64',
                                'value': keyFileController.text,
                                'owners': [
                                  FirebaseAuth.instance.currentUser!.uid,
                                ],
                                'createdAt':
                                    DateTime.now().millisecondsSinceEpoch,
                                'updatedAt':
                                    DateTime.now().millisecondsSinceEpoch,
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'AppStore Connect API Key uploaded',
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          },
                          child: const Text('Upload'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Save Step'),
            ),
            verticalMargin8,
            TextButton(
              onPressed: () => controller.addStepByIndex(index + 1),
              child: const Text('Add Step'),
            ),
            verticalMargin8,
            TextButton(
              onPressed: () => controller.removeStep(index),
              child: const Text(
                'Remove Step',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _isAppStoreConnectApiKeyUploaded() async {
    final secrets = await FirebaseFirestore.instance
        .collection(secretsCollectionPath)
        .where('key', isEqualTo: 'OPENCI_ASC_ISSUER_ID')
        .get();
    return secrets.docs.isNotEmpty;
  }
}

class _Command extends ConsumerWidget {
  const _Command(
    this.commandTextEditingController,
  );

  final TextEditingController commandTextEditingController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: commandTextEditingController,
      decoration: const InputDecoration(
        labelText: 'Command',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 1,
    );
  }
}
