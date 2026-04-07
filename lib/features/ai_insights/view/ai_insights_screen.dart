import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../providers/providers.dart';
import '../model/ai_models.dart';
import '../viewmodel/ai_insights_viewmodel.dart';

class AIInsightsScreen extends ConsumerStatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  ConsumerState<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends ConsumerState<AIInsightsScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      ref
          .read(aiInsightsViewModelProvider.notifier)
          .identifySpecies(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiInsightsViewModelProvider);

    return SafeArea(
      child: aiState.when(
        data: (state) => RefreshIndicator(
          onRefresh: () =>
              ref.read(aiInsightsViewModelProvider.notifier).refresh(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Intelligence Layer',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => ref
                          .read(aiInsightsViewModelProvider.notifier)
                          .refresh(),
                      child:
                          const Icon(Icons.refresh, color: AppTheme.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildNeuralStatusHeader(context),
                const SizedBox(height: 24),
                _buildKPIGrid(context, state),
                const SizedBox(height: 32),
                _buildPerformanceDashboard(context, state),
                const SizedBox(height: 32),
                _buildForecastSection(context, state),
                const SizedBox(height: 32),
                _buildRiskDistributionSection(context, state),
                const SizedBox(height: 32),
                _buildPredictionVsActualSection(context, state),
                const SizedBox(height: 32),
                _buildFraudAlertsSection(context, state),
                const SizedBox(height: 32),
                _buildSpeciesIdSection(context, state),
                const SizedBox(height: 32),
                _buildAnalysisHistory(context, state),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        loading: () => const AppLoader(
            message: 'Initializing Neural Engine...', isDark: false),
        error: (err, stack) => Center(
          child: Text('Engine Error: $err',
              style: const TextStyle(color: AppTheme.redAlert)),
        ),
      ),
    );
  }

  Widget _buildNeuralStatusHeader(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      opacity: 0.8, // More opaque for light mode visibility
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.purpleAI.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology,
                color: AppTheme.purpleAI, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Intelligence Layer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Home → AI Intelligence Layer',
                  style: TextStyle(fontSize: 12, color: AppTheme.textLight),
                ),
              ],
            ),
          ),
          _buildLiveIndicator(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildLiveIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ).animate(onPlay: (c) => c.repeat()).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.5, 1.5),
              duration: 800.ms,
              curve: Curves.easeInOut),
          const SizedBox(width: 8),
          const Text('LIVE',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildKPIGrid(BuildContext context, AIInsightsState state) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildGlassKpi(
            'AI Models Active', '6', Icons.smart_toy, const Color(0xFF7B1FA2)),
        _buildGlassKpi(
            'Fraud Flags Today', '3', Icons.flag, const Color(0xFFC62828)),
        _buildGlassKpi('Species ID Accuracy', '94%', Icons.visibility,
            const Color(0xFF1E7A40)),
        _buildGlassKpi('Risk Predictions', '98% Acc.', Icons.gps_fixed,
            const Color(0xFF1565C0)),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildGlassKpi(
      String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      opacity: 0.9, // Higher opacity for visibility on white
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceDashboard(
      BuildContext context, AIInsightsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Model Performance Dashboard',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(20),
          opacity: 0.9,
          child: Column(
            children: state.modelPerformance.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                              color: AppTheme.textMid, fontSize: 13),
                        ),
                        Text(
                          '${(entry.value * 100).toInt()}%',
                          style: const TextStyle(
                              color: AppTheme.greenMid,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: entry.value,
                        backgroundColor:
                            AppTheme.textLight.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          entry.value > 0.9
                              ? AppTheme.greenMid
                              : AppTheme.blueGov,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildForecastSection(BuildContext context, AIInsightsState state) {
    return Row(
      children: [
        Expanded(
          child: _buildForecastCard(
            'Next Month Forecast',
            state.nextMonthForecast,
            'Applications Volume',
            Icons.trending_up,
            AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildForecastCard(
            'Predicted Outflow',
            state.compensationForecast,
            'Compensation Payout',
            Icons.account_balance_wallet,
            AppTheme.redAlert,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildForecastCard(
      String title, String value, String subtitle, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      opacity: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: AppTheme.textLight),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark),
          ),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 10, color: AppTheme.textLight.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildFraudAlertsSection(BuildContext context, AIInsightsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.security, color: AppTheme.redAlert, size: 20),
            const SizedBox(width: 10),
            const Text(
              'Predictive Threat Alerts',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state.alerts.isEmpty)
          const Text('System clean. No threats detected.',
              style: TextStyle(color: AppTheme.textLight))
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.alerts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _buildAlertGlassCard(context, state.alerts[index]),
          ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildAlertGlassCard(BuildContext context, FraudAlertModel alert) {
    final color = _getRiskColor(alert.riskLevel);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      opacity: 0.9,
      border: Border.all(color: color.withValues(alpha: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.report, color: color, size: 16),
              ),
              const SizedBox(width: 12),
              Text(
                alert.applicationId,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              const Spacer(),
              Text(
                alert.riskLevel.name.toUpperCase(),
                style: TextStyle(
                    color: color, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            alert.reason,
            style: TextStyle(color: AppTheme.textMid, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesIdSection(BuildContext context, AIInsightsState state) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      color: AppTheme.primaryGreen,
      opacity: 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Species Vision ID',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'Capture asset imagery to perform AI-driven taxonomic identification.',
            style: TextStyle(color: AppTheme.textMid, fontSize: 13),
          ),
          const SizedBox(height: 20),
          if (state.isIdentifying)
            const Center(
                child: AppLoader(
              message: 'Scanning Forest Data...',
            ))
          else if (state.lastIdentification != null)
            _buildScanResultUI(state.lastIdentification!)
          else
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'New Scan',
                    icon:
                        const Icon(Icons.qr_code_scanner, color: Colors.white),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'Library',
                    variant: ButtonVariant.outline,
                    icon: const Icon(Icons.add_photo_alternate_outlined,
                        color: AppTheme.forestGreen),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildScanResultUI(AIAnalysisModel result) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: result.imageUrl != null
                    ? DecorationImage(
                        image: FileImage(File(result.imageUrl!)),
                        fit: BoxFit.cover)
                    : null,
                color: AppTheme.naturalBg,
              ),
              child: result.imageUrl == null
                  ? const Icon(Icons.eco, color: AppTheme.primaryGreen)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.species,
                      style: const TextStyle(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(
                    '${(result.confidence * 100).toStringAsFixed(1)}% Match Probability',
                    style: const TextStyle(
                        color: AppTheme.primaryGreen, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        AppButton(
          text: 'Reset Scanner',
          variant: ButtonVariant.outline,
          onPressed: () =>
              ref.read(aiInsightsViewModelProvider.notifier).refresh(),
        ),
      ],
    );
  }

  Widget _buildRiskDistributionSection(
      BuildContext context, AIInsightsState state) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Risk Score Distribution',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 45,
                    sections: _buildRiskPieSections(state.riskDistribution),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.riskDistribution.entries.map((e) {
                    return _buildLegendItem(
                        e.key, _getRiskDistributionColor(e.key));
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }

  List<PieChartSectionData> _buildRiskPieSections(Map<String, double> data) {
    return data.entries.map((e) {
      return PieChartSectionData(
        color: _getRiskDistributionColor(e.key),
        value: e.value,
        title: '${(e.value * 100).toInt()}%',
        radius: 35,
        titleStyle: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppTheme.textMid)),
        ],
      ),
    );
  }

  Widget _buildPredictionVsActualSection(
      BuildContext context, AIInsightsState state) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Prediction vs Actual Compensation',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Variance analysis for compensation payout accuracy (₹ 000)',
            style: TextStyle(color: AppTheme.textLight, fontSize: 11),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
            child: ScatterChart(
              ScatterChartData(
                scatterSpots: state.predictionVsActual.map((p) {
                  return ScatterSpot(p.x, p.y);
                }).toList(),
                minX: 0,
                maxX: 120,
                minY: 0,
                maxY: 140,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Predicted (₹ 000)',
                        style:
                            TextStyle(fontSize: 10, color: AppTheme.textMid)),
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (v, m) => Text(v.toInt().toString(),
                            style: const TextStyle(
                                fontSize: 9, color: AppTheme.textLight))),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text('Actual (₹ 000)',
                        style:
                            TextStyle(fontSize: 10, color: AppTheme.textMid)),
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (v, m) => Text(v.toInt().toString(),
                            style: const TextStyle(
                                fontSize: 9, color: AppTheme.textLight))),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  verticalInterval: 20,
                  getDrawingHorizontalLine: (value) => FlLine(
                      color: AppTheme.textLight.withValues(alpha: 0.1),
                      strokeWidth: 1),
                  getDrawingVerticalLine: (value) => FlLine(
                      color: AppTheme.textLight.withValues(alpha: 0.1),
                      strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildAnalysisHistory(BuildContext context, AIInsightsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Taxonomic History',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark),
        ),
        const SizedBox(height: 16),
        ...state.history.take(3).map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                opacity: 0.9,
                child: Row(
                  children: [
                    const Icon(Icons.history,
                        color: AppTheme.textLight, size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(item.species,
                          style: const TextStyle(color: AppTheme.textMid)),
                    ),
                    Text(
                      '${(item.confidence * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            )),
      ],
    ).animate().fadeIn(delay: 900.ms);
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppTheme.primaryGreen;
      case RiskLevel.medium:
        return AppTheme.saffron;
      case RiskLevel.high:
        return AppTheme.redAlert;
      case RiskLevel.veryHigh:
        return const Color(0xFF8B0000);
    }
  }

  Color _getRiskDistributionColor(String label) {
    if (label.contains('Low')) return AppTheme.primaryGreen;
    if (label.contains('Medium')) return AppTheme.saffron;
    if (label.contains('Very High')) return const Color(0xFF8B0000);
    if (label.contains('High')) return AppTheme.redAlert;
    return AppTheme.primaryGreen;
  }
}
