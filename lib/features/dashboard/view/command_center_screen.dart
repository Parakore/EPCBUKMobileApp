import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';

class CommandCenterScreen extends ConsumerWidget {
  const CommandCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Executive Command Center',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    ref.read(dashboardViewModelProvider.notifier).refresh(),
                child: const Icon(Icons.refresh, color: AppTheme.textDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLiveStatusHeader(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, '🏛 State Overview (Essential KPIs)'),
          const SizedBox(height: 12),
          _buildKPIGrid(context, _stateOverviewKPIs),
          const SizedBox(height: 32),
          _buildSectionTitle(context, '💰 Financial & Compensation Analytics'),
          const SizedBox(height: 12),
          _buildKPIGrid(context, _financialKPIs),
          const SizedBox(height: 24),
          _buildFinancialCharts(context),
          const SizedBox(height: 32),
          _buildSectionTitle(context, '🌳 Environment & Afforestation'),
          const SizedBox(height: 12),
          _buildKPIGrid(context, _environmentKPIs),
          const SizedBox(height: 24),
          _buildAfforestationChart(context),
          const SizedBox(height: 32),
          _buildSectionTitle(context, '⚙ Operational Efficiency (SLA)'),
          const SizedBox(height: 12),
          _buildKPIGrid(context, _operationalKPIs),
          const SizedBox(height: 32),
          _buildSectionTitle(context, '⚖ Legal & Compliance Tracking'),
          const SizedBox(height: 12),
          _buildKPIGrid(context, _complianceKPIs),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLiveStatusHeader(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      color: AppTheme.primaryGreen.withValues(alpha: 0.05),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.dashboard_customize_outlined,
                color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'State Command & Control Hub',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Real-time monitoring across 13 districts',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          _buildLiveIndicator(),
        ],
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildLiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.green, size: 8)
              .animate(onPlay: (c) => c.repeat())
              .scale(
                  duration: 1.seconds,
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2))
              .fadeOut(duration: 1.seconds),
          const SizedBox(width: 6),
          const Text('● LIVE',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.forestGreen,
          ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildKPIGrid(BuildContext context, List<_KPIData> kpis) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return _buildKPICard(context, kpi)
            .animate()
            .fadeIn(delay: (index * 50).ms)
            .scale();
      },
    );
  }

  Widget _buildKPICard(BuildContext context, _KPIData kpi) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      color: kpi.color.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(kpi.icon, color: kpi.color, size: 20),
              if (kpi.trend != null)
                Row(
                  children: [
                    Icon(
                      kpi.trend! > 0 ? Icons.trending_up : Icons.trending_down,
                      color: kpi.trend! > 0 ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${kpi.trend!.abs()}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: kpi.trend! > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kpi.value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                kpi.label,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCharts(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('District-wise Compensation Distribution (₹ Cr)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroupData(0, 45, Colors.blue),
                  _makeGroupData(1, 42, Colors.blue),
                  _makeGroupData(2, 48, Colors.blue),
                  _makeGroupData(3, 35, Colors.blue),
                  _makeGroupData(4, 52, Colors.blue),
                  _makeGroupData(5, 38, Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildAfforestationChart(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Yearly Afforestation Progress (Million Trees)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(2020, 1.2),
                      FlSpot(2021, 1.5),
                      FlSpot(2022, 1.4),
                      FlSpot(2023, 1.8),
                      FlSpot(2024, 2.1),
                    ],
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                        show: true, color: Colors.green.withValues(alpha: 0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  // --- Static Data Mocking 40+ KPIs ---

  static final List<_KPIData> _stateOverviewKPIs = [
    _KPIData(
        'Total Projects', '1,248', Icons.folder_copy_outlined, Colors.blue, 12),
    _KPIData('Active Districts', '13/13', Icons.map_outlined, Colors.teal, 0),
    _KPIData('Total Area (Ha)', '84,250', Icons.area_chart_outlined,
        Colors.green, 5),
    _KPIData(
        'Population Served', '2.4M', Icons.groups_outlined, Colors.indigo, 8),
    _KPIData(
        'Forest Guards', '1,840', Icons.security_outlined, Colors.brown, 2),
    _KPIData('Satellites Active', '4', Icons.satellite_alt_outlined,
        Colors.deepPurple, 0),
    _KPIData('Drones Deployed', '28', Icons.flight_takeoff_outlined,
        Colors.blueGrey, 15),
    _KPIData('Checkposts', '156', Icons.door_back_door, Colors.orange, 4),
  ];

  static final List<_KPIData> _financialKPIs = [
    _KPIData(
        'Total Funds', '₹480 Cr', Icons.payments_outlined, Colors.green, 15),
    _KPIData('Comp. Paid', '₹142 Cr', Icons.account_balance_wallet_outlined,
        Colors.amber, 20),
    _KPIData('GST Collection', '₹18.4 Cr', Icons.receipt_long_outlined,
        Colors.blue, 10),
    _KPIData('Treasury Sync', '100%', Icons.sync_outlined, Colors.teal, 0),
    _KPIData(
        'Avg Setup Cost', '₹2.4L', Icons.analytics_outlined, Colors.purple, -5),
    _KPIData('Audit Rating', 'A+', Icons.verified_outlined, Colors.green, 0),
    _KPIData(
        'Pending Dues', '₹4.2 Cr', Icons.emergency_outlined, Colors.red, 12),
    _KPIData(
        'Fund Utilization', '74%', Icons.pie_chart_outline, Colors.indigo, 4),
  ];

  static final List<_KPIData> _environmentKPIs = [
    _KPIData('Total Trees', '4.8M', Icons.park_outlined, Colors.green, 8),
    _KPIData('Survival Rate', '84%', Icons.health_and_safety_outlined,
        Colors.lightGreen, 3),
    _KPIData(
        'CO2 Sequester', '124K T', Icons.cloud_done_outlined, Colors.blue, 12),
    _KPIData('Air Quality Avg', '42 AQI', Icons.air_outlined, Colors.teal, -10),
    _KPIData('Soil Health', '78%', Icons.grass_outlined, Colors.brown, 2),
    _KPIData(
        'Hydrol. Impact', 'Good', Icons.water_drop_outlined, Colors.blue, 0),
    _KPIData(
        'Species Div.', '124', Icons.category_outlined, Colors.deepOrange, 5),
    _KPIData('Illegal Felling', '12 Cases', Icons.warning_amber_outlined,
        Colors.red, -15),
  ];

  static final List<_KPIData> _operationalKPIs = [
    _KPIData('SLA Compliance', '92%', Icons.timer_outlined, Colors.blue, 4),
    _KPIData(
        'Avg Processing', '14 Days', Icons.speed_outlined, Colors.orange, -2),
    _KPIData('Staff Online', '428', Icons.person_outline, Colors.teal, 12),
    _KPIData('Mobile Syncs', '8.4K', Icons.phonelink_ring_outlined,
        Colors.indigo, 18),
    _KPIData('Field Surveys', '124/Day', Icons.app_registration_outlined,
        Colors.brown, 7),
    _KPIData('Govt Approvals', '45 Pending', Icons.history_edu_outlined,
        Colors.amber, -5),
    _KPIData(
        'System Uptime', '99.9%', Icons.cloud_circle_outlined, Colors.green, 0),
    _KPIData('Security Alerts', '2', Icons.lock_open_outlined, Colors.red, -50),
  ];

  static final List<_KPIData> _complianceKPIs = [
    _KPIData(
        'UKPCB Permits', '248', Icons.verified_user_outlined, Colors.blue, 5),
    _KPIData('Env. Clearances', '124', Icons.eco_outlined, Colors.green, 8),
    _KPIData('Court Cases', '14', Icons.gavel_outlined, Colors.red, 0),
    _KPIData(
        'Public Hearing', '8 Total', Icons.forum_outlined, Colors.indigo, 10),
    _KPIData('Transparency ID', 'AA-142', Icons.fingerprint_outlined,
        Colors.teal, 0),
    _KPIData('Violations', '4 New', Icons.report_problem_outlined,
        Colors.orange, 12),
    _KPIData(
        'Settlements', '₹1.2 Cr', Icons.handshake_outlined, Colors.green, 5),
    _KPIData('Certification', 'ISO-14001', Icons.workspace_premium_outlined,
        Colors.amber, 0),
  ];
}

class _KPIData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double? trend;

  _KPIData(this.label, this.value, this.icon, this.color, [this.trend]);
}
