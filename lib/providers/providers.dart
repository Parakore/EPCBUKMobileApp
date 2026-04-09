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
import '../features/payments/repository/payment_repository.dart';
import '../features/payments/viewmodel/payment_viewmodel.dart';
import '../features/payments/model/payment_model.dart';
import '../features/notifications/repository/notification_repository.dart';
import '../features/notifications/viewmodel/notification_viewmodel.dart';
import '../features/notifications/model/notification_model.dart';
import '../features/applications/repository/application_repository.dart';
import '../features/dms/repository/dms_repository.dart';
import '../features/audit/repository/audit_repository.dart';
import '../features/audit/viewmodel/audit_viewmodel.dart';
import '../features/compliance/repository/compliance_repository.dart';
import '../features/compliance/viewmodel/compliance_viewmodel.dart';
import '../features/compliance/model/compliance_model.dart';
import '../features/reports/repository/reports_repository.dart';
import '../features/reports/viewmodel/reports_viewmodel.dart';
import '../features/grievance/repository/grievance_repository.dart';
import '../features/grievance/viewmodel/grievance_viewmodel.dart';
import '../features/grievance/model/grievance_model.dart';
import '../features/dms/viewmodel/dms_viewmodel.dart';
import '../features/dms/model/document_model.dart';
import '../features/settings/model/settings_model.dart';
import '../features/settings/viewmodel/settings_viewmodel.dart';

// --- Core Providers ---
final networkClientProvider = Provider((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return DioClient(storageService: storageService);
});

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
  final dio = ref.watch(networkClientProvider).instance;
  return DashboardRepositoryImpl(dio);
});

final gisRepositoryProvider = Provider<GISRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return GISRepositoryImpl(dio);
});

final valuationRepositoryProvider = Provider<ValuationRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return ValuationRepositoryImpl(dio);
});

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return ApplicationRepository(dio);
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
  final dio = ref.watch(networkClientProvider).instance;
  return AIInsightsRepositoryImpl(dio);
});

final aiInsightsViewModelProvider =
    AsyncNotifierProvider<AIInsightsViewModel, AIInsightsState>(() {
  return AIInsightsViewModel();
});

// --- GIS Providers ---
final gisMapViewModelProvider =
    AsyncNotifierProvider<GISMapViewModel, GISMapState>(() {
  return GISMapViewModel();
});

final geoTaggingViewModelProvider =
    NotifierProvider.autoDispose<GeoTaggingViewModel, GeoTaggingState>(() {
  return GeoTaggingViewModel();
});

// --- Valuation Providers ---
// Interactive Calculator
final valuationProvider =
    StateNotifierProvider<ValuationViewModel, ValuationState>((ref) {
  return ValuationViewModel();
});

// Application Valuation Results
final valuationViewModelProvider = AsyncNotifierProviderFamily<
    ValuationDetailViewModel, ValuationResultModel, String>(() {
  return ValuationDetailViewModel();
});

// --- Verification Providers ---
final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return VerificationRepositoryImpl(dio);
});

final verificationViewModelProvider =
    AsyncNotifierProvider<VerificationViewModel, List<VerificationModel>>(() {
  return VerificationViewModel();
});

// --- Payment Providers ---
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return PaymentRepository(dio);
});

final paymentViewModelProvider =
    AsyncNotifierProvider<PaymentViewModel, List<PaymentModel>>(() {
  return PaymentViewModel();
});

final paymentSummaryProvider =
    FutureProvider.autoDispose<PaymentSummary>((ref) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return await repository.getPaymentSummary();
});

// --- Notification Providers ---
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return NotificationRepository(dio);
});

// --- DMS Providers ---
final dmsRepositoryProvider = Provider<DMSRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return DMSRepository(dio);
});

final notificationViewModelProvider = StateNotifierProvider<
    NotificationNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repository);
});

// --- Settings Providers ---
final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsModel>((ref) {
  return SettingsViewModel();
});

// --- Governance & Compliance Providers ---
final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return AuditRepository(dio);
});

final complianceRepositoryProvider = Provider<ComplianceRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return ComplianceRepository(dio);
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return ReportsRepository(dio);
});

final grievanceRepositoryProvider = Provider<GrievanceRepository>((ref) {
  final dio = ref.watch(networkClientProvider).instance;
  return GrievanceRepository(dio);
});

// --- Governance & Compliance ViewModel Providers ---
final auditViewModelProvider =
    StateNotifierProvider<AuditViewModel, AuditState>((ref) {
  final repository = ref.watch(auditRepositoryProvider);
  return AuditViewModel(repository);
});

final complianceViewModelProvider =
    AsyncNotifierProvider<ComplianceViewModel, List<ComplianceCase>>(() {
  return ComplianceViewModel();
});

final reportsViewModelProvider =
    StateNotifierProvider<ReportsViewModel, ReportsState>((ref) {
  final repository = ref.watch(reportsRepositoryProvider);
  return ReportsViewModel(repository);
});

final grievanceViewModelProvider =
    AsyncNotifierProvider<GrievanceViewModel, List<Grievance>>(() {
  return GrievanceViewModel();
});

// DMS ViewModel Provider (Family)
final dmsViewModelProvider =
    AsyncNotifierProviderFamily<DMSViewModel, List<AppDocument>, String>(() {
  return DMSViewModel();
});
