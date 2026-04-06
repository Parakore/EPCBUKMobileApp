import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/dashboard_metrics.dart';
import '../repository/dashboard_repository.dart';
import '../../../providers/providers.dart';

class DashboardViewModel extends AsyncNotifier<DashboardMetrics> {
  late final DashboardRepository _repository;

  @override
  Future<DashboardMetrics> build() async {
    _repository = ref.watch(dashboardRepositoryProvider);
    return _fetchMetrics();
  }

  Future<DashboardMetrics> _fetchMetrics() async {
    return await _repository.getMetrics();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMetrics());
  }
}
