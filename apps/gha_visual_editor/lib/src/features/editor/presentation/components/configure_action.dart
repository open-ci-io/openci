import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_page.dart';
import 'package:signals/signals_flutter.dart';

class ConfigureActions extends StatelessWidget {
  const ConfigureActions({
    super.key,
    required this.clearArrow,
  });

  final VoidCallback clearArrow;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) => Padding(
        padding: const EdgeInsets.only(right: 32.0),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Configure action',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      showConfigureActionSheet.value = false;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.inventory_2, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAction.value['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'View source',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildConfigItem('uses', selectedAction.value['title']!),
              // _buildConfigItem('label', 'Run NPM Test'),
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
                    onPressed: () {
                      clearArrow();
                      showConfigureActionSheet.value = false;
                      showNextStepSignal.value = true;
                      showFirstArrowSignal.value = false;
                    },
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
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

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
