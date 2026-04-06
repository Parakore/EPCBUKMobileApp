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
      totalApplications: 1847,
      treesEnumerated: 12384,
      compensationPaid: 246000000.0, // 24.6 Cr
      pendingApprovals: 156,
      slaBreaches: 23,
      activeDistricts: 13,
      afforestationProgress: 68.0,
      environmentImpactIndex: 'B+',
      fraudDetectionAccuracy: 96.0,
      compensationPredictionScore: 91.0,
      riskScoringAccuracy: 88.0,
      speciesIdAccuracy: 94.0,
      documentAuthenticityScan: 98.0,
      predictedNextMonthApps: '~210–240 Applications',
      slaPerformance: [
        SLADepartmentPerformance(department: 'Forest Guard (Survey)', percentage: 82.0, slaDays: 7),
        SLADepartmentPerformance(department: 'Range Officer (Verify)', percentage: 91.0, slaDays: 3),
        SLADepartmentPerformance(department: 'DFO (Valuation)', percentage: 78.0, slaDays: 5),
        SLADepartmentPerformance(department: 'UKPCB (Compliance)', percentage: 85.0, slaDays: 4),
        SLADepartmentPerformance(department: 'District Magistrate', percentage: 88.0, slaDays: 3),
        SLADepartmentPerformance(department: 'Treasury (Payment)', percentage: 74.0, slaDays: 7),
      ],
      recentActivities: [
        RecentActivity(
          caseId: 'TCA-2025-0862',
          district: 'Dehradun',
          activity: 'Application Submitted',
          by: 'Citizen – Mohan Das',
          time: '5 min ago',
          status: 'New',
        ),
        RecentActivity(
          caseId: 'TCA-2025-0861',
          district: 'Haridwar',
          activity: 'Field Survey Completed',
          by: 'FG Suresh Rawat',
          time: '22 min ago',
          status: 'Progress',
        ),
        RecentActivity(
          caseId: 'TCA-2025-0856',
          district: 'Almora',
          activity: 'UKPCB Compliance Flagged',
          by: 'UKPCB Officer',
          time: '1 hr ago',
          status: 'Alert',
        ),
        RecentActivity(
          caseId: 'TCA-2025-0843',
          district: 'Tehri',
          activity: 'Sent for DM Final Approval',
          by: 'DFO Rajiv Sharma',
          time: '3 hr ago',
          status: 'Progress',
        ),
        RecentActivity(
          caseId: 'TCA-2025-0835',
          district: 'Haridwar',
          activity: 'Payment Challan Generated',
          by: 'Treasury Mohan Lal',
          time: '4 hr ago',
          status: 'Progress',
        ),
        RecentActivity(
          caseId: 'TCA-2025-0821',
          district: 'Nainital',
          activity: 'DM Final Approval Granted',
          by: 'DM A. Verma',
          time: 'Yesterday',
          status: 'Done',
        ),
      ],
    );
  }
}
