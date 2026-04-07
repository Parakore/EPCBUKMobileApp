import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../model/workflow_model.dart';

class WorkflowScreen extends StatelessWidget {
  final String applicationId;

  const WorkflowScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context) {
    final stages = [
      WorkflowStage(title: 'Submitted', role: 'Citizen', icon: Icons.person_outline, status: WorkflowStatus.completed),
      WorkflowStage(title: 'Field Survey', role: 'Forest Guard', icon: Icons.park_outlined, status: WorkflowStatus.completed),
      WorkflowStage(title: 'Verification', role: 'Range Officer', icon: Icons.check_circle_outline, status: WorkflowStatus.active),
      WorkflowStage(title: 'Valuation', role: 'DFO', icon: Icons.calculate_outlined, status: WorkflowStatus.pending),
      WorkflowStage(title: 'UKPCB Review', role: 'PCB Priya', icon: Icons.eco_outlined, status: WorkflowStatus.pending),
      WorkflowStage(title: 'DM Approval', role: 'DM Anand', icon: Icons.gavel_outlined, status: WorkflowStatus.pending),
      WorkflowStage(title: 'Payment', role: 'Treasury', icon: Icons.payments_outlined, status: WorkflowStatus.pending),
      WorkflowStage(title: 'Completed', role: 'System', icon: Icons.verified_user_outlined, status: WorkflowStatus.pending),
    ];

    final history = [
      TimelineEntry(title: 'Application Submitted', subtitle: 'Submitted online via UTCMS portal', date: '29 Mar 2025'),
      TimelineEntry(title: 'Forest Guard Assigned', subtitle: 'FG Suresh Rawat – Beat B-12, Dehradun', date: '30 Mar 2025'),
      TimelineEntry(title: 'Field Survey Completed', subtitle: 'Tree enumeration and geo-tagging done', date: '01 Apr 2025', color: AppTheme.greenMid),
      TimelineEntry(title: 'Awaiting Verification', subtitle: 'Pending with Range Officer Dinesh', date: 'Today', color: AppTheme.gold),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Workflow Tracker – $applicationId'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stepper Header
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.greenDark, AppTheme.greenMain],
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  return _WorkflowStep(stage: stages[index], index: index + 1);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'History & Timeline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return _TimelineItem(
                        entry: history[index],
                        isLast: index == history.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final WorkflowStage stage;
  final int index;

  const _WorkflowStep({required this.stage, required this.index});

  @override
  Widget build(BuildContext context) {
    bool isActive = stage.status == WorkflowStatus.active;
    bool isCompleted = stage.status == WorkflowStatus.completed;

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.white : (isActive ? AppTheme.gold : Colors.white12),
            ),
            child: Icon(
              isCompleted ? Icons.check : stage.icon,
              size: 20,
              color: isCompleted ? AppTheme.greenDark : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stage.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.goldLight : Colors.white70,
            ),
          ),
          Text(
            stage.role,
            style: const TextStyle(fontSize: 8, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineEntry entry;
  final bool isLast;

  const _TimelineItem({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: entry.color ?? AppTheme.greenMid,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        entry.date,
                        style: TextStyle(fontSize: 10, color: AppTheme.textLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.subtitle,
                    style: TextStyle(fontSize: 12, color: AppTheme.textMid),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
