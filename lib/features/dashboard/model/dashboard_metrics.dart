class DashboardMetrics {
  final int totalApplications;
  final int treesEnumerated;
  final double compensationPaid;
  final int pendingApprovals;
  final int slaBreaches;
  final int activeDistricts;
  final double afforestationProgress;
  final String environmentImpactIndex;

  // AI Intelligence Center
  final double fraudDetectionAccuracy;
  final double compensationPredictionScore;
  final double riskScoringAccuracy;
  final double speciesIdAccuracy;
  final double documentAuthenticityScan;
  final String predictedNextMonthApps;

  // Lists
  final List<SLADepartmentPerformance> slaPerformance;
  final List<RecentActivity> recentActivities;

  const DashboardMetrics({
    required this.totalApplications,
    required this.treesEnumerated,
    required this.compensationPaid,
    required this.pendingApprovals,
    required this.slaBreaches,
    required this.activeDistricts,
    required this.afforestationProgress,
    required this.environmentImpactIndex,
    required this.fraudDetectionAccuracy,
    required this.compensationPredictionScore,
    required this.riskScoringAccuracy,
    required this.speciesIdAccuracy,
    required this.documentAuthenticityScan,
    required this.predictedNextMonthApps,
    required this.slaPerformance,
    required this.recentActivities,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalApplications: json['total_applications'] as int,
      treesEnumerated: json['trees_enumerated'] as int,
      compensationPaid: (json['compensation_paid'] as num).toDouble(),
      pendingApprovals: json['pending_approvals'] as int,
      slaBreaches: json['sla_breaches'] as int,
      activeDistricts: json['active_districts'] as int,
      afforestationProgress: (json['afforestation_progress'] as num).toDouble(),
      environmentImpactIndex: json['env_impact_index'] as String,
      fraudDetectionAccuracy: (json['fraud_detection_acc'] as num).toDouble(),
      compensationPredictionScore: (json['comp_prediction_score'] as num).toDouble(),
      riskScoringAccuracy: (json['risk_scoring_acc'] as num).toDouble(),
      speciesIdAccuracy: (json['species_id_acc'] as num).toDouble(),
      documentAuthenticityScan: (json['doc_authenticity_scan'] as num).toDouble(),
      predictedNextMonthApps: json['predicted_next_month_apps'] as String,
      slaPerformance: (json['sla_performance'] as List)
          .map((e) => SLADepartmentPerformance.fromJson(e))
          .toList(),
      recentActivities: (json['recent_activities'] as List)
          .map((e) => RecentActivity.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_applications': totalApplications,
      'trees_enumerated': treesEnumerated,
      'compensation_paid': compensationPaid,
      'pending_approvals': pendingApprovals,
      'sla_breaches': slaBreaches,
      'active_districts': activeDistricts,
      'afforestation_progress': afforestationProgress,
      'env_impact_index': environmentImpactIndex,
      'fraud_detection_acc': fraudDetectionAccuracy,
      'comp_prediction_score': compensationPredictionScore,
      'risk_scoring_acc': riskScoringAccuracy,
      'species_id_acc': speciesIdAccuracy,
      'doc_authenticity_scan': documentAuthenticityScan,
      'predicted_next_month_apps': predictedNextMonthApps,
      'sla_performance': slaPerformance.map((e) => e.toJson()).toList(),
      'recent_activities': recentActivities.map((e) => e.toJson()).toList(),
    };
  }

  DashboardMetrics copyWith({
    int? totalApplications,
    int? treesEnumerated,
    double? compensationPaid,
    int? pendingApprovals,
    int? slaBreaches,
    int? activeDistricts,
    double? afforestationProgress,
    String? environmentImpactIndex,
    double? fraudDetectionAccuracy,
    double? compensationPredictionScore,
    double? riskScoringAccuracy,
    double? speciesIdAccuracy,
    double? documentAuthenticityScan,
    String? predictedNextMonthApps,
    List<SLADepartmentPerformance>? slaPerformance,
    List<RecentActivity>? recentActivities,
  }) {
    return DashboardMetrics(
      totalApplications: totalApplications ?? this.totalApplications,
      treesEnumerated: treesEnumerated ?? this.treesEnumerated,
      compensationPaid: compensationPaid ?? this.compensationPaid,
      pendingApprovals: pendingApprovals ?? this.pendingApprovals,
      slaBreaches: slaBreaches ?? this.slaBreaches,
      activeDistricts: activeDistricts ?? this.activeDistricts,
      afforestationProgress: afforestationProgress ?? this.afforestationProgress,
      environmentImpactIndex: environmentImpactIndex ?? this.environmentImpactIndex,
      fraudDetectionAccuracy: fraudDetectionAccuracy ?? this.fraudDetectionAccuracy,
      compensationPredictionScore: compensationPredictionScore ?? this.compensationPredictionScore,
      riskScoringAccuracy: riskScoringAccuracy ?? this.riskScoringAccuracy,
      speciesIdAccuracy: speciesIdAccuracy ?? this.speciesIdAccuracy,
      documentAuthenticityScan: documentAuthenticityScan ?? this.documentAuthenticityScan,
      predictedNextMonthApps: predictedNextMonthApps ?? this.predictedNextMonthApps,
      slaPerformance: slaPerformance ?? this.slaPerformance,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}

class SLADepartmentPerformance {
  final String department;
  final double percentage;
  final int slaDays;

  const SLADepartmentPerformance({
    required this.department,
    required this.percentage,
    required this.slaDays,
  });

  factory SLADepartmentPerformance.fromJson(Map<String, dynamic> json) {
    return SLADepartmentPerformance(
      department: json['department'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      slaDays: json['sla_days'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'percentage': percentage,
      'sla_days': slaDays,
    };
  }
}

class RecentActivity {
  final String caseId;
  final String district;
  final String activity;
  final String by;
  final String time;
  final String status;

  const RecentActivity({
    required this.caseId,
    required this.district,
    required this.activity,
    required this.by,
    required this.time,
    required this.status,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      caseId: json['case_id'] as String,
      district: json['district'] as String,
      activity: json['activity'] as String,
      by: json['by'] as String,
      time: json['time'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'case_id': caseId,
      'district': district,
      'activity': activity,
      'by': by,
      'time': time,
      'status': status,
    };
  }
}
