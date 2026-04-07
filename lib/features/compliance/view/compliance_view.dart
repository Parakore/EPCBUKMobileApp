import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_kpi_card.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../model/compliance_model.dart';
import '../viewmodel/compliance_viewmodel.dart';

class ComplianceView extends ConsumerWidget {
  const ComplianceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complianceState = ref.watch(complianceViewModelProvider);

    return Scaffold(
      body: complianceState.when(
        data: (cases) => RefreshIndicator(
          onRefresh: () =>
              ref.read(complianceViewModelProvider.notifier).refresh(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Environmental Compliance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.greenDark.withValues(alpha: 0.8),
                  ),
                ),
                _buildHeader(),
                const SizedBox(height: 16),
                _buildKpiGrid(),
                _buildSectionTitle('Compliance Queue'),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cases.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = cases[index];
                    return _ComplianceCaseCard(item: item);
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
              ref.read(complianceViewModelProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UKPCB Compliance Portal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.greenDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Home → Compliance',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: const [
        AppKpiCard(
          label: 'Pending',
          value: '6',
          icon: Icons.shield_outlined,
          color: AppTheme.redAlert,
          isAlert: true,
        ),
        AppKpiCard(
          label: 'Clearances',
          value: '28',
          icon: Icons.verified_user_outlined,
          color: AppTheme.greenMid,
        ),
        AppKpiCard(
          label: 'High Risk',
          value: '3',
          icon: Icons.notification_important_outlined,
          color: AppTheme.saffron,
        ),
        AppKpiCard(
          label: 'Impact Score',
          value: '72/100',
          icon: Icons.eco_outlined,
          color: AppTheme.purpleAI,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.greenMid,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ComplianceCaseCard extends StatelessWidget {
  final ComplianceCase item;

  const _ComplianceCaseCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.greenMid.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                  fontSize: 14,
                ),
              ),
              _buildRiskBadge(item.risk),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.project,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.greenDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoItem(Icons.location_on_outlined, item.district),
              const SizedBox(width: 16),
              _buildInfoItem(Icons.landscape_outlined, item.areaType),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EC STATUS',
                    style: TextStyle(fontSize: 10, color: AppTheme.textLight),
                  ),
                  const SizedBox(height: 4),
                  AppBadge(
                    label: item.ecStatus,
                    type: item.ecStatus == 'Granted'
                        ? BadgeType.success
                        : BadgeType.warning,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMPLIANCE',
                    style: TextStyle(fontSize: 10, color: AppTheme.textLight),
                  ),
                  const SizedBox(height: 4),
                  AppBadge(
                    label: item.status,
                    type: _getComplianceBadgeType(item.status),
                  ),
                ],
              ),
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.greenPale,
                  foregroundColor: AppTheme.greenMid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.textLight),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textMid),
        ),
      ],
    );
  }

  Widget _buildRiskBadge(String risk) {
    BadgeType type;
    switch (risk) {
      case 'Very High':
        type = BadgeType.danger;
        break;
      case 'High':
        type = BadgeType.warning;
        break;
      case 'Medium':
        type = BadgeType.info;
        break;
      default:
        type = BadgeType.success;
    }
    return AppBadge(label: 'Risk: $risk', type: type);
  }

  BadgeType _getComplianceBadgeType(String status) {
    switch (status) {
      case 'Compliant':
        return BadgeType.success;
      case 'Violation':
        return BadgeType.danger;
      default:
        return BadgeType.warning;
    }
  }
}
