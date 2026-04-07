import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_kpi_card.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../providers/providers.dart';
import '../model/payment_model.dart';

class PaymentStatusScreen extends ConsumerWidget {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentViewModelProvider);
    final summaryAsync = ref.watch(paymentSummaryProvider);

    return summaryAsync.when(
      data: (summary) => paymentsAsync.when(
        data: (payments) => _buildContent(context, ref, payments, summary),
        loading: () => const AppLoader(),
        error: (e, st) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(paymentViewModelProvider.notifier).refresh(),
        ),
      ),
      loading: () => const AppLoader(),
      error: (e, st) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.read(paymentViewModelProvider.notifier).refresh(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref,
      List<PaymentModel> payments, PaymentSummary summary) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return RefreshIndicator(
      onRefresh: () => ref.read(paymentViewModelProvider.notifier).refresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Analytics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.greenDark.withValues(alpha: 0.8),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      ref.read(paymentViewModelProvider.notifier).refresh(),
                  child: Icon(Icons.refresh, color: AppTheme.greenDark),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // KPI Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                AppKpiCard(
                  label: 'Total Disbursed',
                  value: currencyFormat.format(summary.totalDisbursed),
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppTheme.greenMid,
                ),
                AppKpiCard(
                  label: 'Net Pending',
                  value: currencyFormat.format(summary.pendingAmount),
                  icon: Icons.pending_actions_outlined,
                  color: AppTheme.saffron,
                  isAlert: summary.pendingAmount > 0,
                ),
                AppKpiCard(
                  label: 'Generated Challans',
                  value: summary.totalChallans.toString().padLeft(2, '0'),
                  icon: Icons.receipt_long_outlined,
                  color: AppTheme.blueGov,
                ),
                AppKpiCard(
                  label: 'SLA Compliance',
                  value: '94%',
                  icon: Icons.speed_outlined,
                  color: AppTheme.purpleAI,
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

            const SizedBox(height: 24),

            // Payment Trend Chart (Line Chart)
            const Text(
              'Disbursement Timeline (₹ Cr)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GlassCard(
                child: LineChart(
                  _getLineChartData(summary.monthlyTrend),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            // Fund Allocation (Pie Chart)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fund Allocation',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: PieChart(
                          _getPieChartData(summary.fundAllocation),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: summary.fundAllocation.entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getColorForFund(e.key),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${e.key} (${e.value.toInt()}%)',
                                style: const TextStyle(
                                    fontSize: 10, color: AppTheme.textMid),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 24),

            // Payment History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final p = payments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(p.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getStatusIcon(p.status),
                          color: _getStatusColor(p.status),
                        ),
                      ),
                      title: Text(
                        p.type,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        'ID: ${p.id} • ${DateFormat('dd MMM yyyy').format(p.date)}',
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textLight),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFormat.format(p.amount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.greenDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AppBadge(
                            label: p.status.label,
                            type: _getBadgeType(p.status),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }

  LineChartData _getLineChartData(List<double> trend) {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: trend
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList(),
          isCurved: true,
          color: AppTheme.greenMid,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.greenMid.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  PieChartData _getPieChartData(Map<String, double> allocation) {
    return PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: allocation.entries.map((e) {
        return PieChartSectionData(
          color: _getColorForFund(e.key),
          value: e.value,
          title: '',
          radius: 30,
        );
      }).toList(),
    );
  }

  Color _getColorForFund(String fund) {
    switch (fund) {
      case 'CAMPA':
        return AppTheme.greenMid;
      case 'Afforestation':
        return AppTheme.saffron;
      case 'NPV':
        return AppTheme.blueGov;
      case 'Timber':
        return AppTheme.redAlert;
      case 'Admin':
        return AppTheme.gold;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return AppTheme.greenMid;
      case PaymentStatus.pending:
        return AppTheme.saffron;
      case PaymentStatus.processing:
        return AppTheme.blueGov;
      case PaymentStatus.failed:
        return AppTheme.redAlert;
    }
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return Icons.check_circle_outline;
      case PaymentStatus.pending:
        return Icons.access_time;
      case PaymentStatus.processing:
        return Icons.sync;
      case PaymentStatus.failed:
        return Icons.error_outline;
    }
  }

  BadgeType _getBadgeType(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return BadgeType.success;
      case PaymentStatus.pending:
        return BadgeType.warning;
      case PaymentStatus.processing:
        return BadgeType.info;
      case PaymentStatus.failed:
        return BadgeType.danger;
    }
  }
}
