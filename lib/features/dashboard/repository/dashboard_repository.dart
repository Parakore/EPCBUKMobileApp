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
      monthlyVolume: [
        MonthlyVolumeData(month: 'Apr', received: 152, completed: 178),
        MonthlyVolumeData(month: 'May', received: 82, completed: 138),
        MonthlyVolumeData(month: 'Jun', received: 185, completed: 145),
        MonthlyVolumeData(month: 'Jul', received: 212, completed: 100),
        MonthlyVolumeData(month: 'Aug', received: 100, completed: 115),
        MonthlyVolumeData(month: 'Sep', received: 120, completed: 105),
        MonthlyVolumeData(month: 'Oct', received: 182, completed: 65),
        MonthlyVolumeData(month: 'Nov', received: 208, completed: 118),
        MonthlyVolumeData(month: 'Dec', received: 205, completed: 95),
        MonthlyVolumeData(month: 'Jan', received: 185, completed: 50),
        MonthlyVolumeData(month: 'Feb', received: 138, completed: 52),
        MonthlyVolumeData(month: 'Mar', received: 105, completed: 125),
      ],
      districtCompensation: [
        DistrictCompensationData(district: 'Almora', amount: 112.5),
        DistrictCompensationData(district: 'Uttarkashi', amount: 78.2),
        DistrictCompensationData(district: 'Haridwar', amount: 69.8),
        DistrictCompensationData(district: 'Chamoli', amount: 66.4),
        DistrictCompensationData(district: 'Nainital', amount: 51.5),
        DistrictCompensationData(district: 'Tehri', amount: 46.8),
        DistrictCompensationData(district: 'Dehradun', amount: 40.2),
        DistrictCompensationData(district: 'Pauri', amount: 33.7),
      ],
      speciesDistribution: [
        SpeciesDistributionData(species: 'Teak', percentage: 35.0),
        SpeciesDistributionData(species: 'Sal', percentage: 25.0),
        SpeciesDistributionData(species: 'Pine', percentage: 15.0),
        SpeciesDistributionData(species: 'Oak', percentage: 12.0),
        SpeciesDistributionData(species: 'Bamboo', percentage: 8.0),
        SpeciesDistributionData(species: 'Other', percentage: 5.0),
      ],
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
