import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';

class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {'user': 'Admin (Dinesh)', 'action': 'Valuation Approved', 'appId': 'TCA-2025-0862', 'time': '10:24 AM, Today', 'icon': Icons.check_circle},
      {'user': 'Forest Guard', 'action': 'Field Survey Uploaded', 'appId': 'TCA-2025-0871', 'time': '09:12 AM, Today', 'icon': Icons.upload_file},
      {'user': 'Citizen (Mohan)', 'action': 'New Application Created', 'appId': 'TCA-2025-0888', 'time': 'Yesterday', 'icon': Icons.add_circle},
      {'user': 'System AI', 'action': 'Fraud Risk Warning', 'appId': 'TCA-2025-0744', 'time': 'Yesterday', 'icon': Icons.warning_amber},
      {'user': 'Treasury', 'action': 'Challan Generated', 'appId': 'TCA-2025-0843', 'time': '03 Apr 2025', 'icon': Icons.receipt_long},
      {'user': 'DM Office', 'action': 'Site Visit Scheduled', 'appId': 'TCA-2025-0851', 'time': '02 Apr 2025', 'icon': Icons.calendar_today},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Audit Log'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final act = activities[index] as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.greenMid.withValues(alpha: 0.1),
                  child: Icon(act['icon'] as IconData, color: AppTheme.greenMid, size: 20),
                ),
                title: Text(act['action'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('By ${act['user']} | ${act['appId']}', style: TextStyle(fontSize: 11, color: AppTheme.textMid)),
                    const SizedBox(height: 4),
                    Text(act['time'] as String, style: TextStyle(fontSize: 10, color: AppTheme.textLight)),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          );
        },
      ),
    );
  }
}
