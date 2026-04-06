import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';
import '../features/dashboard/model/dashboard_metrics.dart';
import '../features/dashboard/repository/dashboard_repository.dart';
import '../features/dashboard/viewmodel/dashboard_viewmodel.dart';
import '../core/network/dio_client.dart';

// --- Core Providers ---
final networkClientProvider = Provider((ref) => NetworkClient());

// --- Repository Providers ---
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(networkClientProvider).dio;
  return AuthRepositoryImpl(dio);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

// --- ViewModel Providers ---
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthViewModel(repository);
});

final dashboardViewModelProvider =
    AsyncNotifierProvider<DashboardViewModel, DashboardMetrics>(() {
  return DashboardViewModel();
});
