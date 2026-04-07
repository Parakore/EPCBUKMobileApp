import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_kpi_card.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../model/grievance_model.dart';
import '../viewmodel/grievance_viewmodel.dart';

class GrievanceView extends ConsumerWidget {
  const GrievanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grievanceState = ref.watch(grievanceViewModelProvider);

    return Scaffold(
      body: grievanceState.when(
        data: (grievances) => RefreshIndicator(
          onRefresh: () =>
              ref.read(grievanceViewModelProvider.notifier).refresh(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Grievance Portal',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSummaryCards(),
                _buildSectionHeader('My Grievances'),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: grievances.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = grievances[index];
                    return _GrievanceCard(item: item);
                  },
                ),
              ],
            ),
          ),
        ),
        loading: () => const AppLoader(),
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onRetry: () =>
              ref.read(grievanceViewModelProvider.notifier).refresh(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.saffron,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('File New Grievance'),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: const [
        AppKpiCard(
          label: 'Total Grievances',
          value: '47',
          icon: Icons.forum_outlined,
          color: AppTheme.blueGov,
        ),
        AppKpiCard(
          label: 'Open',
          value: '9',
          icon: Icons.hourglass_top_outlined,
          color: AppTheme.saffron,
          isAlert: true,
        ),
        AppKpiCard(
          label: 'Resolved',
          value: '38',
          icon: Icons.check_circle_outline,
          color: AppTheme.greenMid,
        ),
        AppKpiCard(
          label: 'Avg Resolution',
          value: '3.2 Days',
          icon: Icons.speed_outlined,
          color: AppTheme.purpleAI,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, size: 18),
          label: const Text('Filter'),
        ),
      ],
    );
  }
}

class _GrievanceCard extends StatelessWidget {
  final Grievance item;

  const _GrievanceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppTheme.textLight,
                ),
              ),
              AppBadge(
                label: item.status,
                type: item.status == 'Resolved'
                    ? BadgeType.success
                    : BadgeType.warning,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.subject,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMid,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.category_outlined, item.category),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.calendar_today_outlined, item.date),
              const Spacer(),
              _buildPriorityIndicator(item.priority),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.textLight),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textMid),
        ),
      ],
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = AppTheme.redAlert;
        break;
      case 'Medium':
        color = AppTheme.saffron;
        break;
      default:
        color = AppTheme.blueGov;
    }
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          priority,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
