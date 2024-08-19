import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/components/action_list.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_page.dart';

class ChooseAction extends StatelessWidget {
  const ChooseAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 300,
        height: 500,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: actionList.length,
          itemBuilder: (context, index) {
            final title = actionList[index]['title'] as String;
            final actionName = actionList[index]['actionName'] as String;
            return ListTile(
              title: Text(title),
              subtitle: Text(actionName),
              onTap: () {
                selectedAction.value = {
                  'title': title,
                  'actionName': actionName
                };
              },
            );
          },
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
