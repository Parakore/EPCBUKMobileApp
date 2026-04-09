import 'package:dio/dio.dart';
import '../model/audit_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

class AuditRepository {
  final Dio dio;

  AuditRepository(this.dio);

  Future<List<AuditModel>> getAuditLogs() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockAuditLogs;
    }

    try {
      final response = await dio.get(ApiEndpoints.audit);
      final List<dynamic> data = response.data;
      return data.map((e) => AuditModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  static List<AuditModel> get _mockAuditLogs => [
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
      ];
}
