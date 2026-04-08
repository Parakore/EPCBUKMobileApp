class ChartDataPoint {
  final String label;
  final double value;
  final double? value2; // Added for dual-value charts

  ChartDataPoint({
    required this.label,
    required this.value,
    this.value2,
  });
}

class ReportModel {
  final List<ChartDataPoint> monthlyVolume;
  final List<ChartDataPoint> districtWise;
  final List<ChartDataPoint> stageDistribution;
  final List<ChartDataPoint> speciesCompensation;
  final List<ChartDataPoint> compensationTrend;
  final Map<String, double> slaPerformance;

  // New Monthly Metrics
  final List<ChartDataPoint> treesMonthly; // Image 1
  final List<ChartDataPoint> envIndexMonthly; // Image 2
  final List<ChartDataPoint> campaMonthly; // Image 3
  final List<ChartDataPoint> paymentFlowMonthly; // Image 4

  ReportModel({
    required this.monthlyVolume,
    required this.districtWise,
    required this.stageDistribution,
    required this.speciesCompensation,
    required this.compensationTrend,
    required this.slaPerformance,
    required this.treesMonthly,
    required this.envIndexMonthly,
    required this.campaMonthly,
    required this.paymentFlowMonthly,
  });
}
