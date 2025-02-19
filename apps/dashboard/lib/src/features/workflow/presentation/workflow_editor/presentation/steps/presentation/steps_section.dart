import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/main.dart';
import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:dashboard/src/features/secrets/presentation/secrets.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_editor/presentation/workflow_editor_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

class StepsSection extends ConsumerWidget {
  const StepsSection(this.workflowModel, this.firebaseSuite, {super.key});

  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite).notifier,
    );
    final state = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite),
    );
    final steps = state.steps;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final cards = <Card>[
      for (int index = 0; index < steps.length; index += 1)
        Card(
          color: colorScheme.surfaceBright,
          key: Key('$index'),
          child: SizedBox(
            height: 80,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    steps[index].name,
                    style: textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalMargin8,
                  Text(
                    steps[index].command,
                    style: textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w100,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
    ];

    Widget proxyDecorator(
      Widget child,
      int index,
      Animation<double> animation,
    ) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final animValue = Curves.easeInOut.transform(animation.value);
          final elevation = lerpDouble(1, 6, animValue)!;
          final scale = lerpDouble(1, 1.02, animValue)!;
          return Transform.scale(
            scale: scale,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  width: 0.6,
                  color: colorScheme.primary,
                ),
              ),
              elevation: elevation,
              color: cards[index].color,
              child: cards[index].child,
            ),
          );
        },
        child: child,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            'Steps',
            style: textTheme.titleMedium,
          ),
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              height: 500,
              child: ReorderableListView(
                shrinkWrap: true,
                proxyDecorator: proxyDecorator,
                onReorder: (int oldIndex, int newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  controller.reorderStep(oldIndex, newIndex);
                },
                children: cards,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepItem extends HookConsumerWidget {
  const _StepItem({
    super.key,
    required this.step,
    required this.index,
    required this.workflowModel,
    required this.firebaseSuite,
  });

  final WorkflowModelStep step;
  final int index;
  final WorkflowModel workflowModel;
  final OpenCIFirebaseSuite firebaseSuite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      workflowEditorControllerProvider(workflowModel, firebaseSuite).notifier,
    );
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
                      return Dialog(
                        child: StreamBuilder(
                          stream: secrets(firebaseSuite),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
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
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final secret = data[index].data()!
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
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
