class ComplianceCase {
  final String id;
  final String project;
  final String district;
  final String areaType;
  final String ecStatus;
  final String status;
  final String risk;

  ComplianceCase({
    required this.id,
    required this.project,
    required this.district,
    required this.areaType,
    required this.ecStatus,
    required this.status,
    required this.risk,
  });

  factory ComplianceCase.fromJson(Map<String, dynamic> json) {
    return ComplianceCase(
      id: json['id'] ?? '',
      project: json['project'] ?? '',
      district: json['district'] ?? '',
      areaType: json['areaType'] ?? '',
      ecStatus: json['ecStatus'] ?? '',
      status: json['status'] ?? '',
      risk: json['risk'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project': project,
      'district': district,
      'areaType': areaType,
      'ecStatus': ecStatus,
      'status': status,
      'risk': risk,
    };
  }
}
