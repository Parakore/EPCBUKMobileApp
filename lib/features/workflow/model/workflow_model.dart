import 'package:flutter/material.dart';

enum WorkflowStatus { completed, active, pending }

class WorkflowStage {
  final String title;
  final String role;
  final IconData icon;
  final WorkflowStatus status;

  WorkflowStage({
    required this.title,
    required this.role,
    required this.icon,
    required this.status,
  });
}

class TimelineEntry {
  final String title;
  final String subtitle;
  final String date;
  final Color? color;

  TimelineEntry({
    required this.title,
    required this.subtitle,
    required this.date,
    this.color,
  });
}
