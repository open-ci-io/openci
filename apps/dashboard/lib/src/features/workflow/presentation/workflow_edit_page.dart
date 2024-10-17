import 'package:flutter/material.dart';

class WorkflowCard extends StatelessWidget {
  final Map<String, dynamic> workflow;

  const WorkflowCard({super.key, required this.workflow});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.blue, width: 1),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.blue, width: 1),
        ),
        title: Text(workflow['name'] ?? 'Unnamed Workflow'),
        subtitle:
            Text('Flutter: ${workflow['flutter']?['version'] ?? 'Unknown'}'),
        children: [
          ListTile(
              title: Text(
                  'GitHub: ${workflow['github']?['repositoryUrl'] ?? 'Unknown'}')),
          ListTile(
              title: Text(
                  'Trigger Type: ${workflow['github']?['triggerType'] ?? 'Unknown'}')),
          const ListTile(title: Text('Steps:')),
          ...?workflow['steps']
              ?.map<Widget>(
                (step) => Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    title: Text(step['name'] ?? 'Unnamed Step'),
                    subtitle: Text(step['commands']?.join(', ') ?? ''),
                  ),
                ),
              )
              .toList(),
          OverflowBar(
            children: [
              TextButton(
                onPressed: () =>
                    _showWorkflowDialog(context, workflow: workflow),
                child: const Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWorkflowDialog(BuildContext context,
      {Map<String, dynamic>? workflow}) {
    showDialog(
      context: context,
      builder: (context) => WorkflowDialog(workflow: workflow),
    );
  }
}

class WorkflowDialog extends StatefulWidget {
  final Map<String, dynamic>? workflow;

  const WorkflowDialog({super.key, this.workflow});

  @override
  _WorkflowDialogState createState() => _WorkflowDialogState();
}

class _WorkflowDialogState extends State<WorkflowDialog> {
  late TextEditingController _nameController;
  late TextEditingController _flutterVersionController;
  late TextEditingController _githubUrlController;
  late TextEditingController _triggerTypeController;
  List<Map<String, dynamic>> _steps = [];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.workflow?['name'] ?? '');
    _flutterVersionController = TextEditingController(
        text: widget.workflow?['flutter']?['version'] ?? '');
    _githubUrlController = TextEditingController(
        text: widget.workflow?['github']?['repositoryUrl'] ?? '');
    _triggerTypeController = TextEditingController(
        text: widget.workflow?['github']?['triggerType'] ?? '');
    _steps = List<Map<String, dynamic>>.from(widget.workflow?['steps'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.workflow == null ? 'Add Workflow' : 'Edit Workflow',
              style: const TextStyle(color: Colors.white),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Workflow Name'),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _flutterVersionController,
                      decoration:
                          const InputDecoration(labelText: 'Flutter Version'),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _githubUrlController,
                      decoration: const InputDecoration(
                          labelText: 'GitHub Repository URL'),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _triggerTypeController,
                      decoration:
                          const InputDecoration(labelText: 'Trigger Type'),
                    ),
                    const SizedBox(height: 16),
                    Text('Steps', style: Theme.of(context).textTheme.bodyLarge),
                    ..._buildStepsList(),
                    ElevatedButton(
                      onPressed: _addStep,
                      child: const Text('Add Step'),
                    ),
                  ],
                ),
              ),
            ),
            OverflowBar(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _saveWorkflow,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStepsList() {
    return _steps.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> step = entry.value;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Step Name'),
                controller: TextEditingController(text: step['name']),
                onChanged: (value) => _steps[index]['name'] = value,
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: 'Commands (comma-separated)'),
                controller:
                    TextEditingController(text: step['commands']?.join(', ')),
                onChanged: (value) =>
                    _steps[index]['commands'] = value.split(', '),
              ),
              OverflowBar(
                children: [
                  TextButton(
                    onPressed: () => _removeStep(index),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _addStep() {
    setState(() {
      _steps.add({'name': '', 'commands': []});
    });
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _saveWorkflow() {
    // Implement Firebase data saving logic here
    // Example:
    // FirebaseFirestore.instance.collection('workflows').add({
    //   'name': _nameController.text,
    //   'flutter': {'version': _flutterVersionController.text},
    //   'github': {
    //     'repositoryUrl': _githubUrlController.text,
    //     'triggerType': _triggerTypeController.text,
    //   },
    //   'steps': _steps,
    // });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _flutterVersionController.dispose();
    _githubUrlController.dispose();
    _triggerTypeController.dispose();
    super.dispose();
  }
}
