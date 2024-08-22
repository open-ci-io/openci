import 'package:flutter/material.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/configure_workflow/presentation/configure_workflow.dart';
import 'package:gha_visual_editor/src/features/editor/presentation/editor_page.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum FlutterChannel {
  stable,
  beta,
  dev,
  master,
}

class ConfigureActions extends StatelessWidget {
  const ConfigureActions({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final action = selectedActionSignal.value!.value;
      return Container(
        width: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      action.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(action.source);
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: const Text(
                        'View source',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            UsesField(label: 'uses', value: action.uses),
            CustomTextField(
              label: 'name',
              value: action.name,
              onChanged: (value) {
                selectedActionSignal.value!.value =
                    selectedActionSignal.value!.value.copyWith(
                  name: value,
                );
              },
            ),
            const SizedBox(height: 16),
            DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              initialSelection: action.channel,
              requestFocusOnTap: true,
              label: const Text('channel'),
              onSelected: (value) {
                if (value == null) return;
                selectedActionSignal.value!.value =
                    selectedActionSignal.value!.value.copyWith(
                  channel: value,
                );
              },
              dropdownMenuEntries: FlutterChannel.values
                  .map<DropdownMenuEntry<FlutterChannel>>((value) {
                return DropdownMenuEntry<FlutterChannel>(
                  value: value,
                  label: value.name,
                  enabled: true,
                );
              }).toList(),
            ),
            CustomTextField(
              label: 'flutter version',
              value: action.flutterVersion,
              onChanged: (value) {
                selectedActionSignal.value!.value =
                    selectedActionSignal.value!.value.copyWith(
                  flutterVersion: value,
                );
              },
            ),
            const Text('Cache', style: TextStyle(color: Colors.grey)),
            Transform.scale(
              scale: 0.8,
              child: SizedBox(
                width: 40,
                child: Switch(
                  // This bool value toggles the switch.
                  value: true,
                  onChanged: (bool value) {
                    selectedActionSignal.value!.value =
                        selectedActionSignal.value!.value.copyWith(
                      cache: value,
                    );
                  },
                ),
              ),
            ),
            CustomTextField(
              label: 'Cache Key',
              value: action.cacheKey,
              onChanged: (value) {
                selectedActionSignal.value!.value =
                    selectedActionSignal.value!.value.copyWith(cacheKey: value);
              },
            ),
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
    });
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
