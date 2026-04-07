import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';
import '../features/dashboard/model/dashboard_metrics.dart';
import '../features/dashboard/repository/dashboard_repository.dart';
import '../features/dashboard/viewmodel/dashboard_viewmodel.dart';
import '../core/services/storage_service.dart';
import '../core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
