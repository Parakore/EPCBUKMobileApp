class ChartDataPoint {
  final String label;
  final double value;
  final double? value2; // Added for dual-value charts

  ChartDataPoint({
    required this.label,
    required this.value,
    this.value2,
  });

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      label: json['label'],
      value: json['value'],
      value2: json['value2'],
    );
  }
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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      monthlyVolume: (json['monthlyVolume'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      districtWise: (json['districtWise'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      stageDistribution: (json['stageDistribution'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      speciesCompensation: (json['speciesCompensation'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      compensationTrend: (json['compensationTrend'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      slaPerformance: (json['slaPerformance'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as double)),
      treesMonthly: (json['treesMonthly'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      envIndexMonthly: (json['envIndexMonthly'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      campaMonthly: (json['campaMonthly'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      paymentFlowMonthly: (json['paymentFlowMonthly'] as List<dynamic>)
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
    );
  }
}
