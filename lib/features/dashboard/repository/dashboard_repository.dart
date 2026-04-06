import '../model/dashboard_metrics.dart';

abstract class DashboardRepository {
  Future<DashboardMetrics> getMetrics();
}

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<DashboardMetrics> getMetrics() async {
    // [STRICT] MOCK API CALL
    await Future.delayed(const Duration(seconds: 1));

    return const DashboardMetrics(
      totalApplications: 1245,
      treesPlanted: 450000,
      compensationPaid: 15750000.0,
      pendingApprovals: 84,
    );
  }
}
