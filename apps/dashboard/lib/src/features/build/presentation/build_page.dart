import 'package:dashboard/src/features/build/presentation/build_logs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuildPage extends StatelessWidget {
  const BuildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const BuildHistoryItem(
          title: 'Sample Title',
          subtitle: 'Sample Subtitle',
          duration: '12m 24s',
          timeAgo: '1h ago',
          branch: 'develop',
        );
      },
    );
  }
}

class BuildHistoryItem extends StatelessWidget {
  const BuildHistoryItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.timeAgo,
    required this.branch,
    this.tags = const [],
    this.isSuccess = true,
  });
  final String title;
  final String subtitle;
  final String duration;
  final String timeAgo;
  final String branch;
  final List<String> tags;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (context) => const RunDetailsScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success/Failure Icon
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),

            // Main Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tags and Time Info
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Duration
                      _Tag(
                        icon: Icons.timer_outlined,
                        text: duration,
                      ),

                      // Time Ago
                      _Tag(
                        icon: Icons.access_time,
                        text: timeAgo,
                      ),

                      _Tag(
                        icon: FontAwesomeIcons.codeBranch,
                        text: branch,
                        iconSize: 10,
                      ),

                      // Additional Tags
                      ...tags.map(
                        (tag) => _Tag(
                          icon: Icons.tag,
                          text: tag,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // More Options
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.icon,
    required this.text,
    this.iconSize = 16,
  });
  final IconData icon;
  final String text;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.grey[400],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
