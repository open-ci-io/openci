import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/check_asc_key_upload.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/choose_template.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/distribution.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/enum.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/flutter_build_ipa.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/result.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/select_asc_keys.dart';
import 'package:dashboard/src/features/workflow/presentation/create_workflow/presentation/pages/upload_asc_keys.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:signals/signals_flutter.dart';

class CreateWorkflowDialog extends StatefulHookConsumerWidget {
  const CreateWorkflowDialog({super.key});

  @override
  ConsumerState<CreateWorkflowDialog> createState() => _DialogBodyState();
}

class _DialogBodyState extends ConsumerState<CreateWorkflowDialog>
    with SignalsMixin {
  late final _currentPage = createSignal(PageEnum.chooseTemplate);
  late final _workflowName = createSignal('New Workflow');
  late final _flutterBuildIpaCommand = createSignal('flutter build ipa');
  late final _cwd = createSignal('');
  late final _baseBranch = createSignal('main');
  late final _githubTriggerType = createSignal(GitHubTriggerType.push);
  late final _appDistributionTarget =
      createSignal(OpenCIAppDistributionTarget.none);
  late final _issuerId = createSignal('');
  late final _keyId = createSignal('');
  late final _keyBase64 = createSignal('');

  @override
  Widget build(BuildContext context) {
    return switch (_currentPage.value) {
      PageEnum.chooseTemplate => ChooseTemplate(
          currentPage: _currentPage,
        ),
      PageEnum.checkASCKeyUpload => CheckASCKeyUpload(
          currentPage: _currentPage,
        ),
      PageEnum.selectASCKeys => SelectASCKeys(
          issuerId: _issuerId,
          keyId: _keyId,
          keyBase64: _keyBase64,
          currentPage: _currentPage,
        ),
      PageEnum.uploadASCKeys => UploadASCKeys(
          issuerId: _issuerId.value,
          keyId: _keyId.value,
          keyBase64: _keyBase64.value,
          currentPage: _currentPage,
        ),
      PageEnum.flutterBuildIpa => FlutterBuildIpa(
          currentPage: _currentPage,
          workflowName: _workflowName,
          flutterBuildIpaCommand: _flutterBuildIpaCommand,
          cwd: _cwd,
          baseBranch: _baseBranch,
          githubTriggerType: _githubTriggerType,
        ),
      PageEnum.distribution => Distribution(
          appDistributionTarget: _appDistributionTarget,
          currentPage: _currentPage,
        ),
      PageEnum.result => Result(
          currentWorkingDirectory: _cwd.value,
          workflowName: _workflowName.value,
          githubTriggerType: _githubTriggerType.value,
          githubBaseBranch: _baseBranch.value,
          flutterBuildIpaCommand: _flutterBuildIpaCommand.value,
          appDistributionTarget: _appDistributionTarget.value,
        ),
    };
  }
}
