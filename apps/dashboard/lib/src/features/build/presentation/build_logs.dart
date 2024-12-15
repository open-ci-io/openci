import 'package:flutter/material.dart';

// サンプルデータ
class RunDetailsScreen extends StatelessWidget {
  const RunDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('your-org/your-repo'),
        actions: [
          Chip(
            label: const Text('RUNNING'),
            backgroundColor: Colors.blue.withValues(alpha: 0.2),
            side: BorderSide.none,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RunHeader(),
              SizedBox(height: 16),
              JobsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class RunHeader extends StatelessWidget {
  const RunHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'main #123',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.commit, size: 16),
              SizedBox(width: 8),
              Text('abc123'),
              SizedBox(width: 16),
              Icon(Icons.schedule, size: 16),
              SizedBox(width: 8),
              Text('Started 5 minutes ago'),
            ],
          ),
        ],
      ),
    );
  }
}

class JobsList extends StatelessWidget {
  const JobsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildJob(
          context,
          name: 'build',
          status: 'success',
          duration: '1m 23s',
          steps: [
            _buildStep('Set up job', 'success', '7s'),
            _buildStep('Run actions/checkout@v4', 'success', '12s'),
            _buildStep('Set up Flutter', 'success', '35s'),
            _buildStep('Get dependencies', 'success', '29s'),
          ],
        ),
        const SizedBox(height: 16),
        _buildJob(
          context,
          name: 'test',
          status: 'running',
          duration: '45s',
          steps: [
            _buildStep('Set up job', 'success', '8s'),
            _buildStep('Run actions/checkout@v4', 'success', '11s'),
            _buildStep('Run tests', 'running', '26s'),
          ],
        ),
      ],
    );
  }

  Widget _buildJob(
    BuildContext context, {
    required String name,
    required String status,
    required String duration,
    required List<Map<String, String>> steps,
  }) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: _StatusIcon(status: status),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(duration),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) => _StepTile(
              name: steps[index]['name']!,
              status: steps[index]['status']!,
              duration: steps[index]['duration']!,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _buildStep(String name, String status, String duration) {
    return {
      'name': name,
      'status': status,
      'duration': duration,
    };
  }
}

class _StepTile extends StatefulWidget {
  const _StepTile({
    required this.name,
    required this.status,
    required this.duration,
  });
  final String name;
  final String status;
  final String duration;

  @override
  State<_StepTile> createState() => _StepTileState();
}

class _StepTileState extends State<_StepTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _StatusIcon(
              status: widget.status,
              size: 20,
            ),
          ),
          title: Text(widget.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.duration,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (widget.status == 'running' || widget.status == 'failure') ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.unfold_less : Icons.unfold_more,
                  ),
                  onPressed: () => setState(() => isExpanded = !isExpanded),
                ),
              ],
            ],
          ),
        ),
        if (isExpanded)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LogLine(
                  time: '12:01:23',
                  message: 'Running tests...',
                  type: 'stdout',
                ),
                _LogLine(
                  time: '12:01:24',
                  message: 'Test case 1 passed',
                  type: 'stdout',
                ),
                _LogLine(
                  time: '12:01:25',
                  message: 'Warning: Deprecated API usage',
                  type: 'stderr',
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatusIcon extends StatefulWidget {
  const _StatusIcon({
    required this.status,
    this.size = 24,
  });
  final String status;
  final double size;

  @override
  State<_StatusIcon> createState() => _StatusIconState();
}

class _StatusIconState extends State<_StatusIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    if (widget.status == 'running') {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = switch (widget.status) {
      'success' => Icons.check_circle,
      'failure' => Icons.error,
      'running' => Icons.refresh,
      _ => Icons.help,
    };

    final color = switch (widget.status) {
      'success' => Colors.green,
      'failure' => Colors.red,
      'running' => Colors.blue,
      _ => Colors.grey,
    };

    if (widget.status == 'running') {
      return RotationTransition(
        turns: _controller,
        child: Icon(
          icon,
          color: color,
          size: widget.size,
        ),
      );
    }

    return Icon(
      icon,
      color: color,
      size: widget.size,
    );
  }
}

class _LogLine extends StatelessWidget {
  const _LogLine({
    required this.time,
    required this.message,
    required this.type,
  });
  final String time;
  final String message;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '[$time]',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.7),
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: type == 'stderr'
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
