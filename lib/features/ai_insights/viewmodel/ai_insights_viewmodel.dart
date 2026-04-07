import 'dart:async';
import 'package:epcbuk_mobile_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/ai_models.dart';
import '../repository/ai_insights_repository.dart';

class AIInsightsState {
  final List<AIAnalysisModel> history;
  final List<FraudAlertModel> alerts;
  final bool isIdentifying;
  final AIAnalysisModel? lastIdentification;
  final Map<String, double> modelPerformance;
  final String nextMonthForecast;
  final String compensationForecast;
  final Map<String, double> riskDistribution;
  final List<ScatterPointModel> predictionVsActual;

  AIInsightsState({
    this.history = const [],
    this.alerts = const [],
    this.isIdentifying = false,
    this.lastIdentification,
    this.modelPerformance = const {},
    this.nextMonthForecast = '',
    this.compensationForecast = '',
    this.riskDistribution = const {},
    this.predictionVsActual = const [],
  });

  AIInsightsState copyWith({
    List<AIAnalysisModel>? history,
    List<FraudAlertModel>? alerts,
    bool? isIdentifying,
    AIAnalysisModel? lastIdentification,
    Map<String, double>? modelPerformance,
    String? nextMonthForecast,
    String? compensationForecast,
    Map<String, double>? riskDistribution,
    List<ScatterPointModel>? predictionVsActual,
  }) {
    return AIInsightsState(
      history: history ?? this.history,
      alerts: alerts ?? this.alerts,
      isIdentifying: isIdentifying ?? this.isIdentifying,
      lastIdentification: lastIdentification ?? this.lastIdentification,
      modelPerformance: modelPerformance ?? this.modelPerformance,
      nextMonthForecast: nextMonthForecast ?? this.nextMonthForecast,
      compensationForecast: compensationForecast ?? this.compensationForecast,
      riskDistribution: riskDistribution ?? this.riskDistribution,
      predictionVsActual: predictionVsActual ?? this.predictionVsActual,
    );
  }
}

class AIInsightsViewModel extends AsyncNotifier<AIInsightsState> {
  late final AIInsightsRepository _repository;

  @override
  FutureOr<AIInsightsState> build() async {
    _repository = ref.watch(aiInsightsRepositoryProvider);
    return _loadInitialData();
  }

  Future<AIInsightsState> _loadInitialData() async {
    final history = await _repository.getAnalysisHistory();
    final alerts = await _repository.getFraudAlerts();
    final performance = await _repository.getModelPerformance();
    final nextMonth = await _repository.getNextMonthForecast();
    final compensation = await _repository.getCompensationForecast();
    final riskDist = await _repository.getRiskDistribution();
    final scatterData = await _repository.getPredictionVsActual();

    return AIInsightsState(
      history: history,
      alerts: alerts,
      modelPerformance: performance,
      nextMonthForecast: nextMonth,
      compensationForecast: compensation,
      riskDistribution: riskDist,
      predictionVsActual: scatterData,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadInitialData());
  }

  Future<void> identifySpecies(String imagePath) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(isIdentifying: true));

    try {
      final result = await _repository.identifySpecies(imagePath);
      state = AsyncValue.data(current.copyWith(
        isIdentifying: false,
        lastIdentification: result,
        history: [result, ...current.history],
      ));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> resolveAlert(String alertId) async {
    final current = state.value;
    if (current == null) return;

    final updatedAlerts = current.alerts.map((a) {
      if (a.id == alertId) {
        return FraudAlertModel(
          id: a.id,
          applicationId: a.applicationId,
          riskLevel: a.riskLevel,
          reason: a.reason,
          timestamp: a.timestamp,
          isResolved: true,
        );
      }
      return a;
    }).toList();

    state = AsyncValue.data(current.copyWith(alerts: updatedAlerts));
  }
}
