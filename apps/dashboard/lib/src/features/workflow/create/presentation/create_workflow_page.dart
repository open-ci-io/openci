import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/src/features/workflow/create/presentation/create_workflow_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart' as models;
import 'package:openci_models/openci_models.dart';

class CreateWorkflowPage extends HookConsumerWidget {
  const CreateWorkflowPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jksTextEditingController = useTextEditingController();
    final jksDirTextEditingController = useTextEditingController();
    final jksNameTextEditingController = useTextEditingController();
    final keyPropertiesTextEditingController = useTextEditingController();
    final controller = ref.watch(createWorkflowControllerProvider.notifier);

    final testerGroups = useTextEditingController();
    final testers = useTextEditingController();
    final appIdAndroid = useTextEditingController();
    final serviceAccountJson = useTextEditingController();
    final appName = useTextEditingController();
    final dartDefine = useTextEditingController();
    final entryPoint = useTextEditingController();
    final flavor = useTextEditingController();
    final version = useTextEditingController();
    final baseBranch = useTextEditingController();
    final repositoryUrl = useTextEditingController();
    final workflowName = useTextEditingController();

    print(FirebaseAuth.instance.currentUser!.uid);

    final future = FirebaseFirestore.instance
        .collection('organizations')
        .where('editors', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('For Android'),
                const Text('Your Project is'),
                FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final docs = snapshot.data?.docs.first;
                    return Text('${docs?.data()}');
                  },
                ),
                TextField(
                  controller: jksTextEditingController,
                  decoration: const InputDecoration(
                    hintText: 'jks',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final url = await controller.uploadFile();
                    if (url == null) {
                      return;
                    }
                    jksTextEditingController.value =
                        TextEditingValue(text: url);
                  },
                  child: const Text('Upload File'),
                ),
                TextField(
                  controller: jksDirTextEditingController,
                  decoration: const InputDecoration(
                    hintText: 'jksDirectory',
                  ),
                ),
                TextField(
                  controller: jksNameTextEditingController,
                  decoration: const InputDecoration(
                    hintText: 'jksName',
                  ),
                ),
                TextField(
                  controller: keyPropertiesTextEditingController,
                  decoration: const InputDecoration(
                    hintText: 'keyProperties',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final url = await controller.uploadFile();
                    if (url == null) {
                      return;
                    }
                    keyPropertiesTextEditingController.value =
                        TextEditingValue(text: url);
                  },
                  child: const Text('Upload Key Properties File'),
                ),
                // firebase
                TextField(
                  controller: testerGroups,
                  decoration: const InputDecoration(
                    hintText: 'testerGroups',
                  ),
                ),
                TextField(
                  controller: testers,
                  decoration: const InputDecoration(
                    hintText: 'testers',
                  ),
                ),
                TextField(
                  controller: appIdAndroid,
                  decoration: const InputDecoration(
                    hintText: 'appIdAndroid',
                  ),
                ),
                TextField(
                  controller: serviceAccountJson,
                  decoration: const InputDecoration(
                    hintText: 'serviceAccountJson',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final url = await controller.uploadFile();
                    if (url == null) {
                      return;
                    }
                    serviceAccountJson.value = TextEditingValue(text: url);
                  },
                  child: const Text('Service Account Json'),
                ),
                // flutter
                TextField(
                  controller: appName,
                  decoration: const InputDecoration(
                    hintText: 'appName',
                  ),
                ),
                TextField(
                  controller: dartDefine,
                  decoration: const InputDecoration(
                    hintText: 'dartDefine',
                  ),
                ),

                TextField(
                  controller: entryPoint,
                  decoration: const InputDecoration(
                    hintText: 'entryPoint',
                  ),
                ),
                TextField(
                  controller: flavor,
                  decoration: const InputDecoration(
                    hintText: 'flavor',
                  ),
                ),
                TextField(
                  controller: version,
                  decoration: const InputDecoration(
                    hintText: 'version',
                  ),
                ),
                // github
                TextField(
                  controller: baseBranch,
                  decoration: const InputDecoration(
                    hintText: 'baseBranch',
                  ),
                ),
                TextField(
                  controller: repositoryUrl,
                  decoration: const InputDecoration(
                    hintText: 'repositoryUrl',
                  ),
                ),
                TextField(
                  controller: workflowName,
                  decoration: const InputDecoration(
                    hintText: 'workflowName',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final qs = await future;
                    final organizationId = qs.docs.first.id;
                    //
                    final firebase = models.WorkflowFirebaseConfig(
                      appDistribution: models.AppDistributionConfig(
                        testerGroups: [testerGroups.value.text],
                      ),
                      appIdAndroid: appIdAndroid.value.text,
                      serviceAccountJson: serviceAccountJson.value.text,
                    );
                    final flutter = models.WorkflowFlutterConfig(
                      dartDefine: [dartDefine.value.text],
                      entryPoint: entryPoint.value.text,
                      flavor: flavor.value.text,
                      version: version.value.text,
                    );
                    const shorebird = models.WorkflowShorebirdConfig();
                    final android = models.WorkflowAndroidConfig(
                      jks: jksTextEditingController.value.text,
                      jksDirectory: jksDirTextEditingController.value.text,
                      jksName: jksNameTextEditingController.value.text,
                      keyProperties:
                          keyPropertiesTextEditingController.value.text,
                    );
                    final github = models.WorkflowGitHubConfig(
                        baseBranch: baseBranch.value.text,
                        repositoryUrl: repositoryUrl.value.text,
                        triggerType: 'pullRequest');
                    final data = models.WorkflowModel(
                      android: android,
                      firebase: firebase,
                      organizationId: organizationId,
                      flutter: flutter,
                      github: github,
                      shorebird: shorebird,
                      workflowName: workflowName.value.text,
                      platform: models.TargetPlatform.android,
                      distribution:
                          BuildDistributionChannel.firebaseAppDistribution,
                    );
                    await controller.save(data);
                  },
                  child: const Text('SAVE'),
                ),
                // triggerType = pullRequest
                // organizationId
                // platform = android
                // updatedAt
                // workflowName = android
              ],
            ),
          ),
        ),
      ),
    );
  }
}
