import 'package:flutter/material.dart';
import 'package:openci_models/openci_models.dart';

class WorkflowEditor extends StatefulWidget {
  const WorkflowEditor({super.key, this.workflow});
  final WorkflowModel? workflow;

  @override
  State<WorkflowEditor> createState() => _WorkflowEditorState();
}

class _WorkflowEditorState extends State<WorkflowEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _flutterVersionController;
  late TextEditingController _repoUrlController;
  late TextEditingController _baseBranchController;
  late List<String> _owners;
  late List<WorkflowModelStep> _steps;
  late GitHubTriggerType _triggerType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workflow?.name ?? '');
    _flutterVersionController = TextEditingController(
      text: widget.workflow?.flutter.version ?? '',
    );
    _repoUrlController = TextEditingController(
      text: widget.workflow?.github.repositoryUrl ?? '',
    );
    _baseBranchController = TextEditingController(
      text: widget.workflow?.github.baseBranch ?? '',
    );
    _owners = List<String>.from(widget.workflow?.owners ?? []);
    _steps = List<WorkflowModelStep>.from(widget.workflow?.steps ?? []);
    _triggerType =
        widget.workflow?.github.triggerType ?? GitHubTriggerType.push;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _flutterVersionController.dispose();
    _repoUrlController.dispose();
    _baseBranchController.dispose();
    super.dispose();
  }

  void _saveWorkflow() {
    if (_formKey.currentState?.validate() ?? false) {
      final workflow = WorkflowModel(
        name: _nameController.text,
        id: widget.workflow?.id ?? DateTime.now().toString(),
        flutter: WorkflowModelFlutter(version: _flutterVersionController.text),
        github: WorkflowModelGitHub(
          repositoryUrl: _repoUrlController.text,
          triggerType: _triggerType,
          baseBranch: _baseBranchController.text,
        ),
        owners: _owners,
        steps: _steps,
      );
      Navigator.pop(context, workflow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.workflow == null ? 'Create Workflow' : 'Edit Workflow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWorkflow,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildGitHubSection(),
            const SizedBox(height: 24),
            _buildOwnersSection(),
            const SizedBox(height: 24),
            _buildStepsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _BasicInfoSection(
      nameController: _nameController,
      flutterVersionController: _flutterVersionController,
    );
  }

  Widget _buildGitHubSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GitHub Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _repoUrlController,
              decoration: const InputDecoration(
                labelText: 'Repository URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter repository URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<GitHubTriggerType>(
              value: _triggerType,
              decoration: const InputDecoration(
                labelText: 'Trigger Type',
                border: OutlineInputBorder(),
              ),
              items: GitHubTriggerType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _triggerType = value ?? GitHubTriggerType.push;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _baseBranchController,
              decoration: const InputDecoration(
                labelText: 'Base Branch',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter base branch';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Owners',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addOwner,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _owners.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_owners[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeOwner(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addStep,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                return _buildStepItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(int index) {
    final step = _steps[index];
    return Card(
      child: ExpansionTile(
        title: Text(step.name.isEmpty ? 'Step ${index + 1}' : step.name),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: step.name,
                  decoration: const InputDecoration(
                    labelText: 'Step Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _steps[index] = step.copyWith(name: value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: step.commands.length + 1,
                  itemBuilder: (context, commandIndex) {
                    if (commandIndex == step.commands.length) {
                      return ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Add Command'),
                        onTap: () => _addCommand(index),
                      );
                    }
                    return ListTile(
                      title: TextFormField(
                        initialValue: step.commands[commandIndex],
                        decoration: InputDecoration(
                          labelText: 'Command ${commandIndex + 1}',
                        ),
                        onChanged: (value) {
                          setState(() {
                            final newCommands =
                                List<String>.from(step.commands);
                            newCommands[commandIndex] = value;
                            _steps[index] =
                                step.copyWith(commands: newCommands);
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeCommand(index, commandIndex),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _removeStep(index),
                  child: const Text('Remove Step'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addOwner() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Owner'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Owner Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _owners.add(controller.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeOwner(int index) {
    setState(() {
      _owners.removeAt(index);
    });
  }

  void _addStep() {
    setState(() {
      _steps.add(const WorkflowModelStep());
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _addCommand(int stepIndex) {
    setState(() {
      final step = _steps[stepIndex];
      final newCommands = List<String>.from(step.commands)..add('');
      _steps[stepIndex] = step.copyWith(commands: newCommands);
    });
  }

  void _removeCommand(int stepIndex, int commandIndex) {
    setState(() {
      final step = _steps[stepIndex];
      final newCommands = List<String>.from(step.commands)
        ..removeAt(commandIndex);
      _steps[stepIndex] = step.copyWith(commands: newCommands);
    });
  }
}

// 新しいStateless Widgetを追加
class _BasicInfoSection extends StatelessWidget {
  const _BasicInfoSection({
    required this.nameController,
    required this.flutterVersionController,
  });

  final TextEditingController nameController;
  final TextEditingController flutterVersionController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Workflow Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a workflow name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: flutterVersionController,
              decoration: const InputDecoration(
                labelText: 'Flutter Version',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter Flutter version';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
