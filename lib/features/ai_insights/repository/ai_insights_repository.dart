import 'package:dio/dio.dart';
import '../model/ai_models.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

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
  final Dio dio;

  AIInsightsRepositoryImpl(this.dio);

  @override
  Future<List<AIAnalysisModel>> getAnalysisHistory() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockAnalysisHistory();
    }

    try {
      final response = await dio.get(ApiEndpoints.aiAnalysis);
      final List<dynamic> data = response.data['history'];
      return data.map((e) => AIAnalysisModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<List<FraudAlertModel>> getFraudAlerts() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockFraudAlerts();
    }

    try {
      final response = await dio.get(ApiEndpoints.aiAnalysis);
      final List<dynamic> data = response.data['alerts'];
      return data.map((e) => FraudAlertModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<AIAnalysisModel> identifySpecies(String imagePath) async {
    if (ApiConstants.useMockData) {
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

    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });
      final response = await dio.post(ApiEndpoints.aiAnalysis, data: formData);
      return AIAnalysisModel.fromJson(response.data);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<Map<String, double>> getModelPerformance() async {
    if (ApiConstants.useMockData) return _mockPerformance();

    try {
      final response = await dio.get(ApiEndpoints.aiAnalysis);
      return Map<String, double>.from(response.data['performance']);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<String> getNextMonthForecast() async {
    if (ApiConstants.useMockData) return '210–240 Applications';
    try {
      final response = await dio.get(ApiEndpoints.aiAnalysis);
      return response.data['forecast_count'];
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Future<String> getCompensationForecast() async {
    if (ApiConstants.useMockData) return '₹4.2 – 5.8 Crore';
    try {
      final response = await dio.get(ApiEndpoints.aiAnalysis);
      return response.data['forecast_amount'];
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Future<Map<String, double>> getRiskDistribution() async {
    if (ApiConstants.useMockData) return _mockRiskDistribution();
    try {
      final response = await dio.get(ApiEndpoints.aiAnalysis);
      return Map<String, double>.from(response.data['risk_distribution']);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<List<ScatterPointModel>> getPredictionVsActual() async {
    if (ApiConstants.useMockData) return _mockScatterPoints();
    try {
      final response = await dio.get(ApiEndpoints.aiAnalysis);
      final List<dynamic> data = response.data['scatter_points'];
      return data.map((e) => ScatterPointModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  // --- MOCK DATA ---
  List<AIAnalysisModel> _mockAnalysisHistory() => [
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
      ];

  List<FraudAlertModel> _mockFraudAlerts() => [
        FraudAlertModel(
          id: 'AL-001',
          applicationId: 'TCA-2025-0844',
          riskLevel: RiskLevel.high,
          reason: 'Duplicate Application Detected',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];

  Map<String, double> _mockPerformance() => {
        'Tree Species Recognition': 0.94,
        'Fraud Detection': 0.98,
      };

  Map<String, double> _mockRiskDistribution() => {
        'Low Risk': 0.62,
        'Medium Risk': 0.23,
        'High Risk': 0.11,
        'Very High Risk': 0.04,
      };

  List<ScatterPointModel> _mockScatterPoints() => [
        const ScatterPointModel(x: 20, y: 18),
        const ScatterPointModel(x: 35, y: 38),
      ];
}

