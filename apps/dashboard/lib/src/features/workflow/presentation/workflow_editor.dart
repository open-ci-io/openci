import 'package:dashboard/src/features/workflow/presentation/workflow_page.dart';
import 'package:flutter/material.dart';

class WorkflowEditor extends StatefulWidget {
  const WorkflowEditor({super.key, required this.workflow});
  final WorkflowItem workflow;

  @override
  State<WorkflowEditor> createState() => _WorkflowEditorState();
}

class _WorkflowEditorState extends State<WorkflowEditor> {
  late TextEditingController _yamlController;
  late TextEditingController _nameController;
  bool _onPushEnabled = true;
  bool _onPullRequestEnabled = true;
  bool _manualTriggerEnabled = true;
  bool _scheduledEnabled = false;
  String _selectedBranch = 'main';
  final List<String> _environments = [];
  final Map<String, String> _secrets = {};

  @override
  void initState() {
    super.initState();
    _yamlController = TextEditingController(
      text: '''name: ${widget.workflow.title}
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2''',
    );
    _nameController = TextEditingController(text: widget.workflow.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Workflow: ${widget.workflow.title}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _saveWorkflow,
            child: const Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Basic Settings'),
                Tab(text: 'YAML'),
                Tab(text: 'Environment'),
                Tab(text: 'Secrets'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBasicSettings(),
                  _buildYamlEditor(),
                  _buildEnvironmentVariables(),
                  _buildSecrets(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicSettings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Workflow Name',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2C2C2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Trigger Settings',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildTriggerSwitch('Run on Push', _onPushEnabled, (value) {
          setState(() => _onPushEnabled = value);
        }),
        _buildTriggerSwitch('Run on Pull Request', _onPullRequestEnabled,
            (value) {
          setState(() => _onPullRequestEnabled = value);
        }),
        _buildTriggerSwitch('Allow Manual Trigger', _manualTriggerEnabled,
            (value) {
          setState(() => _manualTriggerEnabled = value);
        }),
        _buildTriggerSwitch('Schedule Run', _scheduledEnabled, (value) {
          setState(() => _scheduledEnabled = value);
        }),
        const SizedBox(height: 24),
        const Text(
          'Branch Settings',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBranch,
          dropdownColor: const Color(0xFF2C2C2E),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2C2C2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          items: ['main', 'develop', 'staging']
              .map(
                (branch) => DropdownMenuItem(
                  value: branch,
                  child: Text(branch),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedBranch = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildYamlEditor() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _yamlController,
        style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
        maxLines: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF2C2C2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildEnvironmentVariables() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _environments.length + 1,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              if (index == _environments.length) {
                return ElevatedButton(
                  onPressed: _addEnvironmentVariable,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Add Environment Variable'),
                );
              }
              return _buildEnvironmentRow(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecrets() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _secrets.length + 1,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              if (index == _secrets.length) {
                return ElevatedButton(
                  onPressed: _addSecret,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Add Secret'),
                );
              }
              final key = _secrets.keys.elementAt(index);
              return _buildSecretRow(key);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerSwitch(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }

  Widget _buildEnvironmentRow(int index) {
    return Card(
      color: const Color(0xFF2C2C2E),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _environments[index],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editEnvironmentVariable(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteEnvironmentVariable(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecretRow(String key) {
    return Card(
      color: const Color(0xFF2C2C2E),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Text(
                    '********',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editSecret(key),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteSecret(key),
            ),
          ],
        ),
      ),
    );
  }

  void _addEnvironmentVariable() {
    showDialog<void>(
      context: context,
      builder: (context) => _buildEnvironmentDialog(),
    );
  }

  void _editEnvironmentVariable(int index) {
    showDialog<void>(
      context: context,
      builder: (context) => _buildEnvironmentDialog(
        initialValue: _environments[index],
        index: index,
      ),
    );
  }

  void _deleteEnvironmentVariable(int index) {
    setState(() {
      _environments.removeAt(index);
    });
  }

  void _addSecret() {
    showDialog<void>(
      context: context,
      builder: (context) => _buildSecretDialog(),
    );
  }

  void _editSecret(String key) {
    showDialog<void>(
      context: context,
      builder: (context) => _buildSecretDialog(
        initialKey: key,
        initialValue: _secrets[key],
      ),
    );
  }

  void _deleteSecret(String key) {
    setState(() {
      _secrets.remove(key);
    });
  }

  Widget _buildEnvironmentDialog({String? initialValue, int? index}) {
    final controller = TextEditingController(text: initialValue);
    return AlertDialog(
      backgroundColor: const Color(0xFF2C2C2E),
      title: Text(
        initialValue == null
            ? 'Add Environment Variable'
            : 'Edit Environment Variable',
        style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF1C1C1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              if (index != null) {
                _environments[index] = controller.text;
              } else {
                _environments.add(controller.text);
              }
            });
            Navigator.pop(context);
          },
          child: const Text('Save', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildSecretDialog({String? initialKey, String? initialValue}) {
    final keyController = TextEditingController(text: initialKey);
    final valueController = TextEditingController(text: initialValue);
    return AlertDialog(
      backgroundColor: const Color(0xFF2C2C2E),
      title: Text(
        initialKey == null ? 'Add Secret' : 'Edit Secret',
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: keyController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Key',
              filled: true,
              fillColor: const Color(0xFF1C1C1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: valueController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Value',
              filled: true,
              fillColor: const Color(0xFF1C1C1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              if (initialKey != null) {
                _secrets.remove(initialKey);
              }
              _secrets[keyController.text] = valueController.text;
            });
            Navigator.pop(context);
          },
          child: const Text('Save', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  void _saveWorkflow() {
    // TODO: Implement save logic
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _yamlController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
