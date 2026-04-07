import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppStatusTimeline extends StatelessWidget {
  final List<TimelineStep> steps;

  const AppStatusTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return _TimelineItem(step: step, isLast: isLast);
      }),
    );
  }
}

class TimelineStep {
  final String title;
  final String? subtitle;
  final String? timestamp;
  final TimelineStatus status;
  final IconData? icon;

  const TimelineStep({
    required this.title,
    this.subtitle,
    this.timestamp,
    this.status = TimelineStatus.pending,
    this.icon,
  });
}

enum TimelineStatus { completed, active, pending, alert }

class _TimelineItem extends StatelessWidget {
  final TimelineStep step;
  final bool isLast;

  const _TimelineItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 36,
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: step.status == TimelineStatus.pending
                      ? Colors.grey[200]
                      : color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.status == TimelineStatus.pending
                        ? Colors.grey[300]!
                        : color,
                    width: step.status == TimelineStatus.active ? 2.5 : 1.5,
                  ),
                ),
                child: Icon(
                  step.icon ?? _defaultIcon(),
                  size: 16,
                  color: step.status == TimelineStatus.pending
                      ? Colors.grey[400]
                      : color,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: step.status == TimelineStatus.completed
                      ? AppTheme.forestGreen.withValues(alpha: 0.3)
                      : Colors.grey[200],
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: step.status == TimelineStatus.active
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: step.status == TimelineStatus.pending
                        ? Colors.grey[500]
                        : Colors.grey[800],
                  ),
                ),
                if (step.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    step.subtitle!,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
                if (step.timestamp != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    step.timestamp!,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _color() {
    switch (step.status) {
      case TimelineStatus.completed:
        return AppTheme.forestGreen;
      case TimelineStatus.active:
        return const Color(0xFF1565C0);
      case TimelineStatus.alert:
        return Colors.red.shade600;
      case TimelineStatus.pending:
        return Colors.grey;
    }
  }

  IconData _defaultIcon() {
    switch (step.status) {
      case TimelineStatus.completed:
        return Icons.check;
      case TimelineStatus.active:
        return Icons.radio_button_checked;
      case TimelineStatus.alert:
        return Icons.warning_amber;
      case TimelineStatus.pending:
        return Icons.circle_outlined;
    }
  }
}
