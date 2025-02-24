import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:uuid/uuid.dart';

part 'create_workflow_dialog.g.dart';

enum _Page {
  chooseTemplate,
  checkASCKeyUpload,
  uploadASCKeys,
  flutterBuildIpa,
  result,
}

@riverpod
Future<bool> ascKeysUploaded(Ref ref) async {
  final firestore = await getFirebaseFirestore();
  var qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: 'OPENCI_ASC_KEY_ID')
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: 'OPENCI_ASC_ISSUER_ID')
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  qs = await firestore
      .collection(secretsCollectionPath)
      .where('key', isEqualTo: 'OPENCI_ASC_KEY_BASE64')
      .get();
  if (qs.docs.isEmpty) {
    return false;
  }
  return true;
}

// TODO: CWDをDropDownから選択できるように
// TODO: basebranchも選択できるように
// TODO: また、CWDを更新できるように (Firestoreに保存しておくため)
// TODO:

@riverpod
Future<bool> saveWorkflow(
  Ref ref, {
  required String currentWorkingDirectory,
  required String workflowName,
  required GitHubTriggerType githubTriggerType,
  required String githubBaseBranch,
  required String flutterBuildIpaCommand,
}) async {
  final firestore = await getFirebaseFirestore();
  final firebaseAuth = await getFirebaseAuth();
  final currentUserId = firebaseAuth.currentUser!.uid;
  final userDocs =
      await firestore.collection(usersCollectionPath).doc(currentUserId).get();
  final user = OpenCIUser.fromJson(userDocs.data()!);

  final workflow = WorkflowModel(
    id: const Uuid().v4(),
    currentWorkingDirectory: currentWorkingDirectory,
    name: workflowName,
    flutter: const WorkflowModelFlutter(version: '3.27.1'),
    github: WorkflowModelGitHub(
      repositoryUrl: user.github.repositoryUrl,
      triggerType: githubTriggerType,
      baseBranch: githubBaseBranch,
    ),
    owners: [
      firebaseAuth.currentUser!.uid,
    ],
    steps: [
      WorkflowModelStep(
        name: 'Run Flutter Build IPA',
        command: flutterBuildIpaCommand,
      ),
    ],
  );
  await firestore.collection(workflowsCollectionPath).add(workflow.toJson());
  return true;
}

class CreateWorkflowDialog extends StatefulHookConsumerWidget {
  const CreateWorkflowDialog({super.key});

  @override
  ConsumerState<CreateWorkflowDialog> createState() => _DialogBodyState();
}

class _DialogBodyState extends ConsumerState<CreateWorkflowDialog>
    with SignalsMixin {
  late final _currentPage = createSignal(_Page.chooseTemplate);
  late final _workflowName = createSignal('New Workflow');
  late final _flutterBuildIpaCommand = createSignal('flutter build ipa');
  late final _cwd = createSignal('/');
  late final _baseBranch = createSignal('main');
  late final _githubTriggerType = createSignal(GitHubTriggerType.push);

  @override
  Widget build(BuildContext context) {
    return switch (_currentPage.value) {
      _Page.chooseTemplate => _ChooseTemplate(
          currentPage: _currentPage,
        ),
      _Page.checkASCKeyUpload => _CheckASCKeyUpload(
          currentPage: _currentPage,
        ),
      _Page.uploadASCKeys => _UploadASCKeys(
          currentPage: _currentPage,
        ),
      _Page.flutterBuildIpa => _FlutterBuildIpa(
          currentPage: _currentPage,
          workflowName: _workflowName,
          flutterBuildIpaCommand: _flutterBuildIpaCommand,
          cwd: _cwd,
          baseBranch: _baseBranch,
          githubTriggerType: _githubTriggerType,
        ),
      _Page.result => _Result(
          currentWorkingDirectory: _cwd.value,
          workflowName: _workflowName.value,
          githubTriggerType: _githubTriggerType.value,
          githubBaseBranch: _baseBranch.value,
          flutterBuildIpaCommand: _flutterBuildIpaCommand.value,
        ),
    };
  }
}

class _CheckASCKeyUpload extends ConsumerWidget {
  const _CheckASCKeyUpload({
    required this.currentPage,
  });

  final Signal<_Page> currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final future = ref.watch(ascKeysUploadedProvider);
    return OpenCIDialog(
      width: screenWidth * 0.4,
      title: Text(
        'Checking ASC keys',
        style: textTheme.titleMedium,
      ),
      children: [
        future.when(
          data: (data) {
            final result = data;
            if (result) {
              return Column(
                children: [
                  const Text('✅ You have already uploaded ASC keys'),
                  verticalMargin16,
                  TextButton(
                    onPressed: () {
                      currentPage.value = _Page.flutterBuildIpa;
                    },
                    child: const Text('Next'),
                  ),
                ],
              );
            }
            return Column(
              children: [
                const Text('❌ You have not uploaded ASC keys yet'),
                verticalMargin16,
                TextButton(
                  onPressed: () {
                    currentPage.value = _Page.uploadASCKeys;
                  },
                  child: const Text('Upload ASC keys'),
                ),
              ],
            );
          },
          error: (error, stack) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _FlutterBuildIpa extends HookWidget {
  const _FlutterBuildIpa({
    required this.currentPage,
    required this.workflowName,
    required this.flutterBuildIpaCommand,
    required this.cwd,
    required this.baseBranch,
    required this.githubTriggerType,
  });

  final Signal<_Page> currentPage;
  final Signal<String> workflowName;
  final Signal<String> flutterBuildIpaCommand;
  final Signal<String> cwd;
  final Signal<String> baseBranch;
  final Signal<GitHubTriggerType> githubTriggerType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const textFieldBorderWidth = 0.6;
    final colorScheme = Theme.of(context).colorScheme;
    final workflowNameEditingController =
        useTextEditingController(text: workflowName.value);
    final flutterBuildCommandEditingController =
        useTextEditingController(text: flutterBuildIpaCommand.value);
    final cwdEditingController = useTextEditingController(text: cwd.value);
    final baseBranchEditingController =
        useTextEditingController(text: baseBranch.value);
    return OpenCIDialog(
      title: Text(
        'Flutter Build .ipa',
        style: textTheme.titleLarge,
      ),
      children: [
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            labelText: 'Workflow Name',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.primary,
              ),
            ),
          ),
          controller: workflowNameEditingController,
        ),
        verticalMargin24,
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            labelText: 'flutter build command',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.primary,
              ),
            ),
          ),
          controller: flutterBuildCommandEditingController,
        ),
        verticalMargin24,
        TextField(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(18),
            labelText: 'current working directory',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.primary,
              ),
            ),
          ),
          controller: cwdEditingController,
        ),
        verticalMargin24,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<GitHubTriggerType>(
                value: GitHubTriggerType.push,
                style: const TextStyle(fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Trigger Type',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                items: GitHubTriggerType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) {
                  githubTriggerType.value = value ?? GitHubTriggerType.push;
                },
              ),
            ),
            horizontalMargin16,
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(18),
                  labelText: 'base branch',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                controller: baseBranchEditingController,
              ),
            ),
          ],
        ),
        verticalMargin16,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                currentPage.value = _Page.checkASCKeyUpload;
              },
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            horizontalMargin8,
            TextButton(
              onPressed: () async {
                currentPage.value = _Page.result;
                workflowName.value = workflowNameEditingController.text;
                flutterBuildIpaCommand.value =
                    flutterBuildCommandEditingController.text;
                cwd.value = cwdEditingController.text;
              },
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Result extends ConsumerWidget {
  const _Result({
    required this.currentWorkingDirectory,
    required this.workflowName,
    required this.githubTriggerType,
    required this.githubBaseBranch,
    required this.flutterBuildIpaCommand,
  });

  final String currentWorkingDirectory;
  final String workflowName;
  final GitHubTriggerType githubTriggerType;
  final String githubBaseBranch;
  final String flutterBuildIpaCommand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(
      saveWorkflowProvider(
        currentWorkingDirectory: currentWorkingDirectory,
        workflowName: workflowName,
        githubTriggerType: githubTriggerType,
        githubBaseBranch: githubBaseBranch,
        flutterBuildIpaCommand: flutterBuildIpaCommand,
      ),
    );
    final textTheme = Theme.of(context).textTheme;
    return OpenCIDialog(
      title: Text(
        'Result',
        style: textTheme.titleLarge,
      ),
      children: [
        future.when(
          data: (data) {
            if (data) {
              return const Text('✅ The workflow has been successfully saved');
            }
            return const Text('❌ The workflow has been failed to save');
          },
          error: (error, stack) {
            print(error);
            print(stack);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error.toString(),
                ),
                verticalMargin16,
                Text('stackTrace: $stack'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        verticalMargin16,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadASCKeys extends HookConsumerWidget {
  const _UploadASCKeys({
    required this.currentPage,
  });

  final Signal<_Page> currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const textFieldBorderWidth = 0.6;
    final colorScheme = Theme.of(context).colorScheme;
    final stepTitleEditingController = useTextEditingController();
    return OpenCIDialog(
      title: const Text(
        'Upload App Store Connect API Keys',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(18),
                  labelText: 'Issuer Id',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                controller: stepTitleEditingController,
              ),
            ),
            horizontalMargin16,
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(18),
                  labelText: 'Key Id',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: textFieldBorderWidth,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                controller: stepTitleEditingController,
              ),
            ),
          ],
        ),
        verticalMargin16,
        TextField(
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.folder_open),
            ),
            contentPadding: const EdgeInsets.all(18),
            labelText: '.p8 key file (select file)',
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.onSurface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: textFieldBorderWidth,
                color: colorScheme.primary,
              ),
            ),
          ),
          controller: stepTitleEditingController,
        ),
        verticalMargin24,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                currentPage.value = _Page.checkASCKeyUpload;
              },
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            horizontalMargin8,
            TextButton(
              onPressed: () {
                // save keys
                currentPage.value = _Page.flutterBuildIpa;
              },
              child: const Text(
                'Next',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChooseTemplate extends StatelessWidget {
  const _ChooseTemplate({
    required this.currentPage,
  });

  final Signal<_Page> currentPage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return OpenCIDialog(
      title: Text(
        'Choose a template',
        style: textTheme.titleLarge,
      ),
      children: [
        TextButton(
          onPressed: () {
            // check ASC keys

            currentPage.value = _Page.checkASCKeyUpload;
          },
          child: const ListTile(
            title: Text('Release .ipa'),
            leading: Icon(FontAwesomeIcons.apple),
          ),
        ),
        verticalMargin8,
        TextButton(
          onPressed: () {},
          child: const ListTile(
            title: Text('Release .apk'),
            leading: Icon(FontAwesomeIcons.android),
          ),
        ),
        verticalMargin8,
        TextButton(
          onPressed: () {},
          child: const ListTile(
            title: Text('From scratch'),
            leading: Icon(FontAwesomeIcons.pen),
          ),
        ),
        verticalMargin16,
      ],
    );
  }
}
