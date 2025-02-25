import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/create_workflow_dialog_controller.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/save_workflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:signals/signals_flutter.dart';

enum PageEnum {
  chooseTemplate,
  checkASCKeyUpload,
  uploadASCKeys,
  flutterBuildIpa,
  distribution,
  result,
}

class Distribution extends StatelessWidget {
  const Distribution({
    super.key,
    required this.appDistributionTarget,
    required this.currentPage,
  });

  final Signal<OpenCIAppDistributionTarget> appDistributionTarget;
  final Signal<PageEnum> currentPage;

  @override
  Widget build(BuildContext context) {
    return OpenCIDialog(
      title: const Text('Distribution'),
      children: [
        // TODO(maffreud): add firebase app distribution support
        // RadioListTile<OpenCIAppDistributionTarget>(
        //   title: const Text('Firebase App Distribution'),
        //   value: OpenCIAppDistributionTarget.firebaseAppDistribution,
        //   groupValue: appDistributionTarget.value,
        //   onChanged: (OpenCIAppDistributionTarget? value) {
        //     if (value != null) {
        //       appDistributionTarget.value = value;
        //     }
        //   },
        // ),
        RadioListTile<OpenCIAppDistributionTarget>(
          title: Text(OpenCIAppDistributionTarget.testflight.name),
          value: OpenCIAppDistributionTarget.testflight,
          groupValue: appDistributionTarget.value,
          onChanged: (OpenCIAppDistributionTarget? value) {
            if (value != null) {
              appDistributionTarget.value = value;
            }
          },
        ),
        RadioListTile<OpenCIAppDistributionTarget>(
          title: Text(OpenCIAppDistributionTarget.none.name),
          value: OpenCIAppDistributionTarget.none,
          groupValue: appDistributionTarget.value,
          onChanged: (OpenCIAppDistributionTarget? value) {
            if (value != null) {
              appDistributionTarget.value = value;
            }
          },
        ),
        verticalMargin16,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                currentPage.value = PageEnum.flutterBuildIpa;
              },
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            horizontalMargin8,
            TextButton(
              onPressed: () async {
                currentPage.value = PageEnum.result;
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

class CheckASCKeyUpload extends ConsumerWidget {
  const CheckASCKeyUpload({
    super.key,
    required this.currentPage,
  });

  final Signal<PageEnum> currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final future = ref.watch(areAppStoreConnectKeysUploadedProvider);
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
                      currentPage.value = PageEnum.flutterBuildIpa;
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
                    currentPage.value = PageEnum.uploadASCKeys;
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

class FlutterBuildIpa extends HookWidget {
  const FlutterBuildIpa({
    super.key,
    required this.currentPage,
    required this.workflowName,
    required this.flutterBuildIpaCommand,
    required this.cwd,
    required this.baseBranch,
    required this.githubTriggerType,
  });

  final Signal<PageEnum> currentPage;
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
                currentPage.value = PageEnum.checkASCKeyUpload;
              },
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            horizontalMargin8,
            TextButton(
              onPressed: () async {
                workflowName.value = workflowNameEditingController.text;
                flutterBuildIpaCommand.value =
                    flutterBuildCommandEditingController.text;
                cwd.value = cwdEditingController.text;
                baseBranch.value = baseBranchEditingController.text;
                currentPage.value = PageEnum.distribution;
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

class Result extends ConsumerWidget {
  const Result({
    super.key,
    required this.currentWorkingDirectory,
    required this.workflowName,
    required this.githubTriggerType,
    required this.githubBaseBranch,
    required this.flutterBuildIpaCommand,
    required this.appDistributionTarget,
  });

  final String currentWorkingDirectory;
  final String workflowName;
  final GitHubTriggerType githubTriggerType;
  final String githubBaseBranch;
  final String flutterBuildIpaCommand;
  final OpenCIAppDistributionTarget appDistributionTarget;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(
      saveWorkflowProvider(
        currentWorkingDirectory: currentWorkingDirectory,
        workflowName: workflowName,
        githubTriggerType: githubTriggerType,
        githubBaseBranch: githubBaseBranch,
        flutterBuildIpaCommand: flutterBuildIpaCommand,
        appDistributionTarget: appDistributionTarget,
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

class UploadASCKeys extends HookConsumerWidget {
  const UploadASCKeys({
    super.key,
    required this.currentPage,
  });

  final Signal<PageEnum> currentPage;

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
                currentPage.value = PageEnum.checkASCKeyUpload;
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
                currentPage.value = PageEnum.flutterBuildIpa;
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

class ChooseTemplate extends StatelessWidget {
  const ChooseTemplate({
    super.key,
    required this.currentPage,
  });

  final Signal<PageEnum> currentPage;

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

            currentPage.value = PageEnum.checkASCKeyUpload;
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
