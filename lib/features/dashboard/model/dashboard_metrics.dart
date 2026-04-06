class DashboardMetrics {
  final int totalApplications;
  final int treesPlanted;
  final double compensationPaid;
  final int pendingApprovals;

  const DashboardMetrics({
    required this.totalApplications,
    required this.treesPlanted,
    required this.compensationPaid,
    required this.pendingApprovals,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalApplications: json['total_applications'] as int,
      treesPlanted: json['trees_planted'] as int,
      compensationPaid: (json['compensation_paid'] as num).toDouble(),
      pendingApprovals: json['pending_approvals'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_applications': totalApplications,
      'trees_planted': treesPlanted,
      'compensation_paid': compensationPaid,
      'pending_approvals': pendingApprovals,
    };
  }

  DashboardMetrics copyWith({
    int? totalApplications,
    int? treesPlanted,
    double? compensationPaid,
    int? pendingApprovals,
  }) {
    return DashboardMetrics(
      totalApplications: totalApplications ?? this.totalApplications,
      treesPlanted: treesPlanted ?? this.treesPlanted,
      compensationPaid: compensationPaid ?? this.compensationPaid,
      pendingApprovals: pendingApprovals ?? this.pendingApprovals,
    );
  }
}
