import '../model/ai_models.dart';

abstract class AIInsightsRepository {
  Future<List<AIAnalysisModel>> getAnalysisHistory();
  Future<List<FraudAlertModel>> getFraudAlerts();
  Future<AIAnalysisModel> identifySpecies(String imagePath);
  Future<Map<String, double>> getModelPerformance();
  Future<String> getNextMonthForecast();
  Future<String> getCompensationForecast();
  Future<Map<String, double>> getRiskDistribution();
  Future<List<ScatterPointModel>> getPredictionVsActual();
}

class AIInsightsRepositoryImpl implements AIInsightsRepository {
  @override
  Future<List<AIAnalysisModel>> getAnalysisHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AIAnalysisModel(
        id: 'AI-2026-001',
        species: 'Himalayan Cedar (Deodar)',
        confidence: 0.992,
        predictionTime: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      AIAnalysisModel(
        id: 'AI-2026-002',
        species: 'Sal (Shorea robusta)',
        confidence: 0.945,
        predictionTime: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AIAnalysisModel(
        id: 'AI-2026-003',
        species: 'Oak (Banj)',
        confidence: 0.887,
        predictionTime: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }

  @override
  Future<List<FraudAlertModel>> getFraudAlerts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      FraudAlertModel(
        id: 'AL-001',
        applicationId: 'TCA-2025-0844',
        riskLevel: RiskLevel.high,
        reason: 'Duplicate Application Detected: Matches 91% with TCA-2025-0831',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      FraudAlertModel(
        id: 'AL-002',
        applicationId: 'TCA-2025-0856',
        riskLevel: RiskLevel.high,
        reason: 'High-value anomaly flagged: ₹12L claim for 3 trees – statistical outlier',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      FraudAlertModel(
        id: 'AL-003',
        applicationId: 'TCA-2025-0892',
        riskLevel: RiskLevel.medium,
        reason: 'Address GPS mismatch: Claimed location vs actual GPS 2.4km apart',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<AIAnalysisModel> identifySpecies(String imagePath) async {
    await Future.delayed(const Duration(seconds: 2));
    return AIAnalysisModel(
      id: 'AI-${DateTime.now().millisecondsSinceEpoch}',
      species: 'Deodar (Cedrus deodara)',
      confidence: 0.962,
      predictionTime: DateTime.now(),
      imageUrl: imagePath,
      metadata: {
        'age': '35–45 years',
        'class': 'Protected Species',
      },
    );
  }

  @override
  Future<Map<String, double>> getModelPerformance() async {
    return {
      'Tree Species Recognition (Image AI)': 0.94,
      'Compensation Prediction Accuracy': 0.91,
      'Fraud / Duplication Detection': 0.98,
      'Risk Scoring Precision': 0.88,
      'Document OCR & Authenticity': 0.96,
      'Geo-fence Compliance Check': 0.99,
    };
  }

  @override
  Future<String> getNextMonthForecast() async {
    return '210–240 Applications';
  }

  @override
  Future<String> getCompensationForecast() async {
    return '₹4.2 – 5.8 Crore';
  }

  @override
  Future<Map<String, double>> getRiskDistribution() async {
    return {
      'Low Risk': 0.62,
      'Medium Risk': 0.23,
      'High Risk': 0.11,
      'Very High Risk': 0.04,
    };
  }

  @override
  Future<List<ScatterPointModel>> getPredictionVsActual() async {
    return [
      const ScatterPointModel(x: 20, y: 18),
      const ScatterPointModel(x: 35, y: 38),
      const ScatterPointModel(x: 45, y: 42),
      const ScatterPointModel(x: 55, y: 60),
      const ScatterPointModel(x: 65, y: 62),
      const ScatterPointModel(x: 80, y: 78),
      const ScatterPointModel(x: 95, y: 102),
      const ScatterPointModel(x: 105, y: 108),
      const ScatterPointModel(x: 30, y: 28),
      const ScatterPointModel(x: 50, y: 48),
      const ScatterPointModel(x: 70, y: 72),
      const ScatterPointModel(x: 40, y: 45),
      const ScatterPointModel(x: 60, y: 55),
      const ScatterPointModel(x: 85, y: 80),
      const ScatterPointModel(x: 25, y: 22),
      const ScatterPointModel(x: 75, y: 70),
      const ScatterPointModel(x: 90, y: 92),
      const ScatterPointModel(x: 110, y: 105),
    ];
  }
}

