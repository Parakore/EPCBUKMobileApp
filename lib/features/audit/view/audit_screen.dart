import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/glass_card.dart';
import '../viewmodel/audit_viewmodel.dart';
import '../model/audit_model.dart';

class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(auditViewModelProvider);
    final viewModel = ref.read(auditViewModelProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppTextField(
            labelText: 'Search Logs',
            hintText: 'Search by user, action or ID...',
            prefixIcon: const Icon(Icons.search),
            onChanged: viewModel.setSearchQuery,
          ),
        ),
        Expanded(
          child: state.isLoading
              ? const AppLoader()
              : state.error != null
                  ? AppErrorWidget(
                      message: state.error!,
                      onRetry: () => viewModel.loadLogs(),
                    )
                  : state.filteredLogs.isEmpty
                      ? const Center(child: Text('No logs found'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.filteredLogs.length,
                          itemBuilder: (context, index) {
                            final log = state.filteredLogs[index];
                            return _AuditCard(log: log);
                          },
                        ),
        ),
      ],
    );
  }
}

class _AuditCard extends StatelessWidget {
  final AuditModel log;

  const _AuditCard({required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    log.action,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                AppBadge(
                  label: log.status,
                  type: log.status == 'Success'
                      ? BadgeType.success
                      : log.status == 'Alert'
                          ? BadgeType.warning
                          : BadgeType.danger,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 12, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  '${log.user} (${log.role})',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DetailRow(label: 'Timestamp', value: log.timestamp),
                if (log.caseId != null)
                  _DetailRow(label: 'Case ID', value: log.caseId!),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DetailRow(label: 'IP Address', value: log.ipAddress),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryGreen,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child:
                      const Text('View JSON', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9, color: Colors.grey[500]),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
