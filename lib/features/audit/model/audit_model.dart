class AuditModel {
  final String timestamp;
  final String user;
  final String role;
  final String action;
  final String? caseId;
  final String ipAddress;
  final String status;

  const AuditModel({
    required this.timestamp,
    required this.user,
    required this.role,
    required this.action,
    this.caseId,
    required this.ipAddress,
    required this.status,
  });

  AuditModel copyWith({
    String? timestamp,
    String? user,
    String? role,
    String? action,
    String? caseId,
    String? ipAddress,
    String? status,
  }) {
    return AuditModel(
      timestamp: timestamp ?? this.timestamp,
      user: user ?? this.user,
      role: role ?? this.role,
      action: action ?? this.action,
      caseId: caseId ?? this.caseId,
      ipAddress: ipAddress ?? this.ipAddress,
      status: status ?? this.status,
    );
  }
}
