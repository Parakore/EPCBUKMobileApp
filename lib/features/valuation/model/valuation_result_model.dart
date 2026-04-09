class ValuationResultModel {
  final String applicationId;
  final double landValue;
  final double treeValue;
  final double structureValue;
  final double solatium; // Compensation for lost property (usually 100%)
  final double totalCompensation;
  final DateTime calculatedAt;

  ValuationResultModel({
    required this.applicationId,
    required this.landValue,
    required this.treeValue,
    this.structureValue = 0.0,
    required this.solatium,
    required this.totalCompensation,
    required this.calculatedAt,
  });

  factory ValuationResultModel.fromJson(Map<String, dynamic> json) {
    return ValuationResultModel(
      applicationId: json['application_id'] as String,
      landValue: (json['land_value'] as num).toDouble(),
      treeValue: (json['tree_value'] as num).toDouble(),
      structureValue: (json['structure_value'] as num?)?.toDouble() ?? 0.0,
      solatium: (json['solatium'] as num).toDouble(),
      totalCompensation: (json['total_compensation'] as num).toDouble(),
      calculatedAt: DateTime.parse(json['calculated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_id': applicationId,
      'land_value': landValue,
      'tree_value': treeValue,
      'structure_value': structureValue,
      'solatium': solatium,
      'total_compensation': totalCompensation,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }

  factory ValuationResultModel.mock(String id) {
    double base = 1500000.0;
    double trees = 450000.0;
    double sol = base + trees;
    return ValuationResultModel(
      applicationId: id,
      landValue: base,
      treeValue: trees,
      solatium: sol,
      totalCompensation: base + trees + sol,
      calculatedAt: DateTime.now(),
    );
  }
}
