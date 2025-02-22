import 'package:flutter/material.dart';

class StepDetailPage extends StatelessWidget {
  const StepDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Step Detail'),
      ),
      body: const Center(
        child: Text('Step Detail'),
      ),
    );
  }
}
