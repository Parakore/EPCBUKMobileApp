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
