import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:dashboard/src/common_widgets/openci_dialog.dart';
import 'package:dashboard/src/features/workflow/presentation/workflow_list/presentation/create_workflow/presentation/save_workflow.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';

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
