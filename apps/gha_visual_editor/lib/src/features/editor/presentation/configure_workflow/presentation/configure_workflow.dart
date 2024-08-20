import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/domain/workflow_domain.dart';

class ConfigureWorkflow extends StatelessWidget {
  const ConfigureWorkflow({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'Workflow Name',
            value: workflowDomainSignal.value.workflowName,
            onChanged: (value) {
              workflowDomainSignal.value = workflowDomainSignal.value.copyWith(
                workflowName: value,
              );
            },
          ),
          const SizedBox(height: 16),
          DropdownMenu<OnPush>(
            initialSelection: OnPush.push,
            requestFocusOnTap: true,
            label: const Text('Run'),
            onSelected: (value) {
              if (value == null) return;
              workflowDomainSignal.value = workflowDomainSignal.value.copyWith(
                on: value,
              );
            },
            dropdownMenuEntries:
                OnPush.values.map<DropdownMenuEntry<OnPush>>((value) {
              return DropdownMenuEntry<OnPush>(
                value: value,
                label: value.name,
                enabled: true,
              );
            }).toList(),
          ),
          CustomTextField(
            label: 'branch',
            value: workflowDomainSignal.value.branch,
            onChanged: (value) {
              workflowDomainSignal.value = workflowDomainSignal.value.copyWith(
                branch: value,
              );
            },
          ),
          // _buildConfigItem('Run', 'on: push'),
          // _buildConfigItem('Target Branch', 'develop'),
          // _buildConfigItem('runs', 'Overrides ENTRYPOINT'),
          // _buildConfigItem('args', 'test'),
          // const SizedBox(height: 16),
          // const Text(
          //   'secrets',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // const Text(
          //   'Secrets are environment variables that are encrypted and available only when this action executes.',
          //   style: TextStyle(fontSize: 12, color: Colors.grey),
          // ),
          // const SizedBox(height: 8),
          // _buildSecretItem('GITHUB_TOKEN'),
          // _buildSecretItem('NPM_AUTH_TOKEN', showDelete: true),
          // const SizedBox(height: 8),
          // const Text(
          //   'Create a new secret',
          //   style: TextStyle(color: Colors.blue),
          // ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildConfigItem(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(label, style: const TextStyle(color: Colors.grey)),
  //         const SizedBox(height: 4),
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey[300]!),
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: Text(value),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSecretItem(String label, {bool showDelete = false}) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        const Icon(Icons.lock, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label),
        if (showDelete) ...[
          const Spacer(),
          const Icon(Icons.delete, size: 16, color: Colors.grey),
        ],
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
