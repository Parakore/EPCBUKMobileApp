import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_kpi_card.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/reports_viewmodel.dart';
import '../model/report_model.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportsViewModelProvider);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppAppBar(
          title: 'Reports & Analytics',
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppTheme.softYellow,
            unselectedLabelColor: Colors.white54,
            indicatorColor: AppTheme.softYellow,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Compensation'),
              Tab(text: 'Environment'),
              Tab(text: 'Financial'),
              Tab(text: 'Dept. Performance'),
            ],
          ),
        ),
        body: state.isLoading
            ? const AppLoader()
            : state.error != null
                ? AppErrorWidget(
                    message: state.error!,
                    onRetry: () => ref
                        .read(reportsViewModelProvider.notifier)
                        .loadReports(),
                  )
                : state.data == null
                    ? const Center(child: Text('No data available'))
                    : TabBarView(
                        children: [
                          _buildOverviewTab(state.data!),
                          _buildCompensationTab(state.data!),
                          _buildEnvironmentTab(state.data!),
                          _buildFinancialTab(state.data!),
                          _buildPerformanceTab(state.data!),
                        ],
                      ),
      ),
    );
  }

  Widget _buildOverviewTab(ReportModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Monthly Application Volume'),
          const SizedBox(height: 16),
          _buildGroupedMonthlyBarChart(
            data.monthlyVolume,
            'Applications',
            'Completed',
            AppTheme.greenMid,
            AppTheme.saffron,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('District-wise Applications'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: data.districtWise.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          e.value.label,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 16,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: e.value.value / 300,
                                  child: Container(
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _getDistrictColor(e.key),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 30,
                        child: Text(
                          e.value.value.toInt().toString(),
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Application Stage Distribution'),
          const SizedBox(height: 16),
          _buildDonutChart(data.stageDistribution),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCompensationTab(ReportModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: AppKpiCard(
                  label: 'Avg Rate',
                  value: '₹32,000',
                  icon: Icons.trending_up,
                  color: AppTheme.gold,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: AppKpiCard(
                  label: 'Total Paid',
                  value: '₹24.6 Cr',
                  icon: Icons.payments,
                  color: AppTheme.forestGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Species-wise Compensation (₹ L)'),
          const SizedBox(height: 16),
          _buildVerticalBarChart(data.speciesCompensation),
          const SizedBox(height: 24),
          _buildSectionTitle('Compensation Trend (₹ Cr)'),
          const SizedBox(height: 16),
          _buildLineChart(data.compensationTrend),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEnvironmentTab(ReportModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Afforestation vs Deforestation'),
          const SizedBox(height: 16),
          _buildGroupedMonthlyBarChart(
            data.treesMonthly,
            'Trees Cut',
            'Trees Planted',
            AppTheme.redAlert,
            AppTheme.greenMid,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Environmental Impact Index'),
          const SizedBox(height: 16),
          _buildTrendLineChart(
            data.envIndexMonthly,
            ['Env. Impact Index'],
            [AppTheme.greenMid],
            showArea: true,
          ),
          const SizedBox(height: 24),
          // _buildSectionTitle('Species wise Compensation'),
          // const SizedBox(height: 16),
          // _buildVerticalBarChart(data.speciesCompensation),
        ],
      ),
    );
  }

  Widget _buildFinancialTab(ReportModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('CAMPA Collected vs Utilized'),
          const SizedBox(height: 16),
          _buildGroupedMonthlyBarChart(
            data.campaMonthly,
            'Collected (₹ L)',
            'Utilized (₹ L)',
            const Color(0xFF9C27B0), // Purple
            AppTheme.greenMid,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Treasury Payment Flow'),
          const SizedBox(height: 16),
          _buildTrendLineChart(
            data.paymentFlowMonthly,
            ['Released (₹ L)', 'Pending (₹ L)'],
            [AppTheme.greenMid, AppTheme.redAlert],
            showPoints: true,
          ),
          const SizedBox(height: 24),
          // _buildSectionTitle('Compensation Trend'),
          // const SizedBox(height: 16),
          // _buildTrendLineChart(
          //   data.compensationTrend,
          //   ['Avg Compensation'],
          //   [AppTheme.saffron],
          //   showArea: true,
          // ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab(ReportModel data) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('Department SLA Performance'),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: data.slaPerformance.entries
                .map((e) => _buildSlaRow(e.key, e.value))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Department Turnaround Time Comparison'),
        const SizedBox(height: 16),
        _buildRadarChart(data.slaPerformance),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.forestGreen,
      ),
    );
  }

  Widget _buildSlaRow(String dept, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dept, style: const TextStyle(fontSize: 14)),
              Text('${value.toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[200],
            color: value > 85
                ? Colors.green
                : value > 75
                    ? Colors.orange
                    : Colors.red,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<ChartDataPoint> points) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildLegend([
            LegendItem(
                label: 'Compensation (₹ Cr)',
                color: AppTheme.greenMid,
                isSquare: true),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[200]!,
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey[200]!,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= points.length)
                          return const SizedBox();
                        return Transform.rotate(
                          angle: -0.5,
                          child: Text(points[value.toInt()].label,
                              style: const TextStyle(fontSize: 10)),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    left: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: points
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppTheme.greenMid,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: AppTheme.greenMid,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.greenMid.withValues(alpha: 0.3),
                          AppTheme.greenMid.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBarChart(List<ChartDataPoint> points) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
          barGroups: points
              .asMap()
              .entries
              .map((e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.value,
                        color: _getSpeciesColor(e.key),
                        width: 24,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      )
                    ],
                  ))
              .toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= points.length)
                  return const SizedBox();
                return SideTitleWidget(
                  meta: meta,
                  space: 12,
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(points[value.toInt()].label,
                        style: const TextStyle(fontSize: 10)),
                  ),
                );
              },
            )),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey[200]!,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              left: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonutChart(List<ChartDataPoint> stages) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: stages
                    .asMap()
                    .entries
                    .map((e) => PieChartSectionData(
                          value: e.value.value,
                          title: '', // Titles in legend
                          radius: 50,
                          color: _getStageColor(e.key),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: stages
                    .asMap()
                    .entries
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getStageColor(e.key),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  e.value.label,
                                  style: const TextStyle(fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<LegendItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: item.isSquare ? 16 : 12,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius:
                            BorderRadius.circular(item.isSquare ? 2 : 6),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(item.label,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Color _getDistrictColor(int index) {
    final colors = [
      AppTheme.greenMid,
      AppTheme.saffron,
      AppTheme.blueGov,
      AppTheme.redAlert,
      AppTheme.purpleAI,
      const Color(0xFF00796B),
      AppTheme.gold,
      const Color(0xFF43A047),
    ];
    return colors[index % colors.length];
  }

  Color _getStageColor(int index) {
    return _getDistrictColor(index);
  }

  Color _getSpeciesColor(int index) {
    return _getDistrictColor(index);
  }

  Widget _buildGroupedMonthlyBarChart(
    List<ChartDataPoint> points,
    String label1,
    String label2,
    Color color1,
    Color color2,
  ) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      child: Column(
        children: [
          _buildLegend([
            LegendItem(label: label1, color: color1, isSquare: true),
            LegendItem(label: label2, color: color2, isSquare: true),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: (points.isEmpty
                        ? 100
                        : points
                                .map((p) => [p.value, p.value2 ?? 0]
                                    .reduce((a, b) => a > b ? a : b))
                                .reduce((a, b) => a > b ? a : b) *
                            1.2)
                    .ceilToDouble(),
                barGroups: points.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.value,
                        color: color1,
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: e.value.value2 ?? 0,
                        color: color2,
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= points.length)
                          return const SizedBox();
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Text(
                              points[value.toInt()].label,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
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
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendLineChart(
    List<ChartDataPoint> points,
    List<String> labels,
    List<Color> colors, {
    bool showArea = false,
    bool showPoints = true,
  }) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
      child: Column(
        children: [
          _buildLegend(labels
              .asMap()
              .entries
              .map((e) => LegendItem(label: e.value, color: colors[e.key]))
              .toList()),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: points
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                        .toList(),
                    isCurved: true,
                    color: colors[0],
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: showPoints,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: colors[0],
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: showArea,
                      color: colors[0].withValues(alpha: 0.1),
                    ),
                  ),
                  if (labels.length > 1)
                    LineChartBarData(
                      spots: points
                          .asMap()
                          .entries
                          .map((e) =>
                              FlSpot(e.key.toDouble(), e.value.value2 ?? 0))
                          .toList(),
                      isCurved: true,
                      color: colors[1],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: showPoints,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: colors[1],
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: showArea,
                        color: colors[1].withValues(alpha: 0.1),
                      ),
                    ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= points.length)
                          return const SizedBox();
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Text(
                              points[value.toInt()].label,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
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
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRadarChart(Map<String, double> slaData) {
  return Container(
    height: 380,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.forestGreen.withValues(alpha: 0.2),
                border: Border.all(color: AppTheme.forestGreen, width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'SLA Performance (%)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: RadarChart(
            RadarChartData(
              dataSets: [
                RadarDataSet(
                  fillColor: AppTheme.forestGreen.withValues(alpha: 0.15),
                  borderColor: AppTheme.forestGreen,
                  borderWidth: 3,
                  entryRadius: 4,
                  dataEntries:
                      slaData.values.map((e) => RadarEntry(value: e)).toList(),
                ),
              ],
              radarBackgroundColor: Colors.transparent,
              borderData: FlBorderData(show: false),
              radarBorderData: const BorderSide(color: Colors.transparent),
              titlePositionPercentageOffset: 0.15,
              titleTextStyle: const TextStyle(fontSize: 11, color: Colors.grey),
              getTitle: (index, angle) {
                return RadarChartTitle(
                  text: slaData.keys.elementAt(index),
                  angle: angle,
                );
              },
              tickCount: 5,
              ticksTextStyle: const TextStyle(fontSize: 10, color: Colors.grey),
              tickBorderData: const BorderSide(color: Colors.transparent),
              gridBorderData: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
        ),
      ],
    ),
  );
}

class LegendItem {
  final String label;
  final Color color;
  final bool isSquare;

  LegendItem({required this.label, required this.color, this.isSquare = false});
}
