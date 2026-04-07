import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
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
              _buildMonthlyVolumeSection(context, metrics),
              const SizedBox(height: 32),
              _buildDistrictCompensationSection(context, metrics),
              const SizedBox(height: 32),
              _buildSpeciesDistributionSection(context, metrics),
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
        _buildKMICard(
          'Districts Active',
          '${metrics.activeDistricts}/13',
          Icons.map,
          Colors.teal,
          onTap: () => context.go('/home/gis_map'),
        ),
        _buildKMICard('Afforestation', '${metrics.afforestationProgress}%',
            Icons.eco, Colors.lightGreen),
        _buildKMICard('Env. Impact Index', metrics.environmentImpactIndex,
            Icons.forest, Colors.brown),
      ],
    );
  }

  Widget _buildKMICard(String label, String value, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
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
      ),
    );
  }

  Widget _buildMonthlyVolumeSection(
      BuildContext context, DashboardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📈 Monthly Application Volume',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Applications Received', Colors.green[700]!),
                  const SizedBox(width: 16),
                  _buildLegendItem('Completed', Colors.orange),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 250,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < metrics.monthlyVolume.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  metrics.monthlyVolume[value.toInt()].month,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 10),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 50,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString(),
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 10));
                          },
                          reservedSize: 28,
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey[200],
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups:
                        metrics.monthlyVolume.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.received.toDouble(),
                            color: Colors.green[700],
                            width: 8,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                          BarChartRodData(
                            toY: entry.value.completed.toDouble(),
                            color: Colors.orange,
                            width: 8,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistrictCompensationSection(
      BuildContext context, DashboardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🏙 Compensation by District (₹ L)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: metrics.districtCompensation.asMap().entries.map((entry) {
              final district = entry.value;
              final colors = [
                Colors.green[800]!,
                Colors.orange[700]!,
                Colors.blue[800]!,
                Colors.red[800]!,
                Colors.purple[800]!,
                Colors.teal[800]!,
                Colors.amber[800]!,
                Colors.green[600]!,
              ];
              final maxAmount = metrics.districtCompensation
                  .map((e) => e.amount)
                  .reduce((a, b) => a > b ? a : b);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(district.district,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('₹${district.amount} L',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: district.amount / maxAmount,
                        minHeight: 12,
                        backgroundColor: colors[entry.key % colors.length]
                            .withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            colors[entry.key % colors.length]),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesDistributionSection(
      BuildContext context, DashboardMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🌳 Tree Species Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: metrics.speciesDistribution
                        .asMap()
                        .entries
                        .map((entry) {
                      final colors = [
                        Colors.green[800]!,
                        Colors.green[600]!,
                        Colors.green[400]!,
                        Colors.lightGreen[400]!,
                        Colors.teal[400]!,
                        Colors.blueGrey[400]!,
                      ];
                      return PieChartSectionData(
                        color: colors[entry.key % colors.length],
                        value: entry.value.percentage,
                        title: '${entry.value.percentage.toInt()}%',
                        radius: 50,
                        titleStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      metrics.speciesDistribution.asMap().entries.map((entry) {
                    final colors = [
                      Colors.green[800]!,
                      Colors.green[600]!,
                      Colors.green[400]!,
                      Colors.lightGreen[400]!,
                      Colors.teal[400]!,
                      Colors.blueGrey[400]!,
                    ];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _buildLegendItem(entry.value.species,
                          colors[entry.key % colors.length]),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
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
            const Icon(Icons.auto_awesome, color: Colors.purple, size: 24),
            const SizedBox(width: 8),
            const Text('AI Intelligence Center',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/home/ai_insights'),
              child: const Text('View Detailed Analysis →',
                  style: TextStyle(fontSize: 12, color: Colors.purple)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.withValues(alpha: 0.1),
                Colors.blue.withValues(alpha: 0.1),
              ],
            ),
            border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
          ),
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
              const Divider(height: 32, color: Colors.purple),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.forest_rounded,
                          color: Colors.purple, size: 20),
                    ),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple)),
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
                      fontSize: 12, fontWeight: FontWeight.w600)),
              Text('${percentage.toInt()}%',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.purple.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              minHeight: 6,
            ),
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
                              ])),
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
