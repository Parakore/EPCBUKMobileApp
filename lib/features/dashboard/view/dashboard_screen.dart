import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';
import '../model/dashboard_metrics.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModelProvider);
    final user = ref.watch(authViewModelProvider).user;

    return dashboardState.when(
      data: (metrics) => RefreshIndicator(
        onRefresh: () =>
            ref.read(dashboardViewModelProvider.notifier).refresh(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExecutiveHeader(context, user?.name ?? 'State Admin'),
              const SizedBox(height: 24),
              _buildAnalyticsGrid(context, metrics),
              const SizedBox(height: 32),
              _buildChartsSection(context),
              const SizedBox(height: 32),
              _buildAIIntelligenceCenter(context, metrics),
              const SizedBox(height: 32),
              _buildSLAPerformance(context, metrics),
              const SizedBox(height: 32),
              _buildRecentActivityTable(context, metrics),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      loading: () => const AppLoader(message: 'Syncing metrics...'),
      error: (err, stack) => AppErrorWidget(
        message: err.toString(),
        onRetry: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
      ),
    );
  }

  Widget _buildExecutiveHeader(BuildContext context, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'State Executive Dashboard – Uttarakhand',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Home → State Admin Dashboard',
                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sensors, color: Colors.red, size: 14)
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 500.ms)
                      .fadeOut(delay: 500.ms),
                  const SizedBox(width: 4),
                  const Text('LIVE',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Suprabhat, $name',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
        ),
      ],
    ).animate().fadeIn().moveY(begin: -10, end: 0);
  }

  Widget _buildAnalyticsGrid(BuildContext context, DashboardMetrics metrics) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildKMICard(
            'Total Applications',
            metrics.totalApplications.toString(),
            Icons.assignment,
            Colors.blue),
        _buildKMICard('Trees Enumerated', metrics.treesEnumerated.toString(),
            Icons.park, Colors.green),
        _buildKMICard(
            'Compensation Paid',
            '₹${(metrics.compensationPaid / 10000000).toStringAsFixed(1)}Cr',
            Icons.account_balance_wallet,
            Colors.amber[700]!),
        _buildKMICard('Pending Approvals', metrics.pendingApprovals.toString(),
            Icons.hourglass_empty, Colors.orange),
        _buildKMICard('SLA Breaches', metrics.slaBreaches.toString(),
            Icons.warning_amber, Colors.red),
        _buildKMICard('Districts Active', '${metrics.activeDistricts}/13',
            Icons.map, Colors.teal),
        _buildKMICard('Afforestation', '${metrics.afforestationProgress}%',
            Icons.eco, Colors.lightGreen),
        _buildKMICard('Env. Impact Index', metrics.environmentImpactIndex,
            Icons.forest, Colors.brown),
      ],
    );
  }

  Widget _buildKMICard(String label, String value, IconData icon, Color color) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: color.withValues(alpha: 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 18),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.trending_up,
                    color: Colors.green, size: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📊 Performance Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Monthly Application Volume',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 31),
                          FlSpot(2, 42),
                          FlSpot(4, 38),
                          FlSpot(6, 45),
                          FlSpot(8, 52),
                          FlSpot(10, 48),
                        ],
                        isCurved: true,
                        color: AppTheme.primaryGreen,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                            show: true,
                            color:
                                AppTheme.primaryGreen.withValues(alpha: 0.1)),
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIIntelligenceCenter(
      BuildContext context, DashboardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.psychology, color: Colors.purple, size: 24),
            const SizedBox(width: 8),
            const Text('AI Intelligence Center',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildAIMetricRow('Fraud / Duplication Detection',
                  metrics.fraudDetectionAccuracy),
              _buildAIMetricRow('Compensation Prediction Score',
                  metrics.compensationPredictionScore),
              _buildAIMetricRow(
                  'Risk Scoring Accuracy', metrics.riskScoringAccuracy),
              _buildAIMetricRow(
                  'Tree Species ID Accuracy', metrics.speciesIdAccuracy),
              _buildAIMetricRow('Document Authenticity Scan',
                  metrics.documentAuthenticityScan),
              const Divider(height: 32),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.forest, color: Colors.purple, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🔮 Next Month Forecast',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple)),
                          Text(metrics.predictedNextMonthApps,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIMetricRow(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
              Text('${percentage.toInt()}%',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.purple.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildSLAPerformance(BuildContext context, DashboardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⏱ SLA Performance by Dept.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: metrics.slaPerformance
                .map((sla) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(sla.department,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              Text('Target: ${sla.slaDays} Days',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey[600])),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: sla.percentage / 100,
                                  backgroundColor:
                                      Colors.orange.withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      sla.percentage > 85
                                          ? Colors.green
                                          : Colors.orange),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('${sla.percentage.toInt()}%',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityTable(
      BuildContext context, DashboardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📜 Recent State-wide Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        AppCard(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 56,
              columnSpacing: 24,
              columns: const [
                DataColumn(
                    label: Text('Case ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13))),
                DataColumn(
                    label: Text('District',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13))),
                DataColumn(
                    label: Text('By',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13))),
                DataColumn(
                    label: Text('Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13))),
              ],
              rows: metrics.recentActivities
                  .map((activity) => DataRow(
                        cells: [
                          DataCell(Text(activity.caseId,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue))),
                          DataCell(Text(activity.district,
                              style: const TextStyle(fontSize: 12))),
                          DataCell(Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activity.by,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                              Text(activity.time,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[600])),
                            ],
                          )),
                          DataCell(_buildStatusBadge(activity.status)),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'New':
        color = Colors.blue;
        break;
      case 'Progress':
        color = Colors.orange;
        break;
      case 'Alert':
        color = Colors.red;
        break;
      case 'Done':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
