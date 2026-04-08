import '../model/audit_model.dart';

class AuditRepository {
  Future<List<AuditModel>> getAuditLogs() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const AuditModel(
        timestamp: '2025-05-15 14:32:10',
        user: 'Dinesh Rawat',
        role: 'Admin',
        action: 'User Profile Updated',
        caseId: 'USR-1290',
        ipAddress: '10.22.45.12',
        status: 'Success',
      ),
      const AuditModel(
        timestamp: '2025-05-15 13:15:45',
        user: 'Suresh Negi',
        role: 'RO',
        action: 'Field Survey Submitted',
        caseId: 'TCA-2025-0862',
        ipAddress: '10.22.48.91',
        status: 'Success',
      ),
      const AuditModel(
        timestamp: '2025-05-15 12:44:20',
        user: 'System Bot',
        role: 'System',
        action: 'SLA Breach Warning',
        caseId: 'TCA-2025-0811',
        ipAddress: '127.0.0.1',
        status: 'Alert',
      ),
      const AuditModel(
        timestamp: '2025-05-15 11:30:15',
        user: 'Applicant (Rahul)',
        role: 'Citizen',
        action: 'New Application',
        caseId: 'TCA-2025-0901',
        ipAddress: '157.2.14.88',
        status: 'Success',
      ),
      const AuditModel(
        timestamp: '2025-05-15 10:20:05',
        user: 'Treasury Admin',
        role: 'Bank/Treasury',
        action: 'Challan Verified',
        caseId: 'TCA-2025-0850',
        ipAddress: '10.22.12.33',
        status: 'Success',
      ),
    ];
  }
}
