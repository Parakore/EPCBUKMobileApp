import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/dio_client.dart';
import '../core/services/storage_service.dart';
import '../features/ai_insights/repository/ai_insights_repository.dart';
import '../features/ai_insights/viewmodel/ai_insights_viewmodel.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';
import '../features/dashboard/model/dashboard_metrics.dart';
import '../features/dashboard/repository/dashboard_repository.dart';
import '../features/dashboard/viewmodel/dashboard_viewmodel.dart';
import '../features/gis_mapping/repository/gis_repository.dart';
import '../features/gis_mapping/viewmodel/gis_map_viewmodel.dart';
import '../features/gis_mapping/viewmodel/geo_tagging_viewmodel.dart';
import '../features/valuation/repository/valuation_repository.dart';
import '../features/valuation/viewmodel/valuation_viewmodel.dart';
import '../features/valuation/viewmodel/valuation_detail_viewmodel.dart';
import '../features/valuation/model/valuation_state.dart';
import '../features/valuation/model/valuation_result_model.dart';
import '../features/verification/repository/verification_repository.dart';
import '../features/verification/viewmodel/verification_viewmodel.dart';
import '../features/verification/model/verification_model.dart';

// --- Core Providers ---
final networkClientProvider = Provider((ref) => DioClient());

/// Provider for SharedPreferences to be disposed by ProviderContainer
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return StorageService(prefs);
});

// --- Repository Providers ---
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return AuthRepositoryImpl(dio);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

// --- ViewModel Providers ---
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthViewModel(repository, storage);
});

final dashboardViewModelProvider =
    AsyncNotifierProvider<DashboardViewModel, DashboardMetrics>(() {
  return DashboardViewModel();
});

// --- AI Insights Providers ---
final aiInsightsRepositoryProvider = Provider<AIInsightsRepository>((ref) {
  return AIInsightsRepositoryImpl();
});

final aiInsightsViewModelProvider =
    AsyncNotifierProvider<AIInsightsViewModel, AIInsightsState>(() {
  return AIInsightsViewModel();
});

// --- GIS Providers ---
final gisRepositoryProvider = Provider<GISRepository>((ref) {
  return GISRepositoryImpl();
});

final gisMapViewModelProvider =
    AsyncNotifierProvider<GISMapViewModel, GISMapState>(() {
  return GISMapViewModel();
});

final geoTaggingViewModelProvider =
    NotifierProvider.autoDispose<GeoTaggingViewModel, GeoTaggingState>(() {
  return GeoTaggingViewModel();
});

// --- Valuation Providers ---
final valuationRepositoryProvider = Provider<ValuationRepository>((ref) {
  return ValuationRepositoryImpl();
});

// Interactive Calculator
final valuationProvider = StateNotifierProvider<ValuationViewModel, ValuationState>((ref) {
  return ValuationViewModel();
});

// Application Valuation Results
final valuationViewModelProvider = AsyncNotifierProviderFamily<
    ValuationDetailViewModel, ValuationResultModel, String>(() {
  return ValuationDetailViewModel();
});

// --- Verification Providers ---
final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  return VerificationRepositoryImpl();
});

final verificationViewModelProvider =
    AsyncNotifierProvider<VerificationViewModel, List<VerificationModel>>(() {
  return VerificationViewModel();
});

