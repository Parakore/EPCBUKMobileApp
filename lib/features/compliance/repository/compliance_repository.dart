import 'package:dio/dio.dart';
import '../model/compliance_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

class ComplianceRepository {
  final Dio dio;

  ComplianceRepository(this.dio);

  Future<List<ComplianceCase>> getComplianceCases() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockComplianceCases;
    }

    try {
      final response = await dio.get(ApiEndpoints.compliance);
      final List<dynamic> data = response.data;
      return data.map((e) => ComplianceCase.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  static List<ComplianceCase> get _mockComplianceCases => [
        ComplianceCase(
          id: 'TCA-2025-0843',
          project: 'UJVNL Hydro Project',
          district: 'Tehri',
          areaType: 'Forest Land',
          ecStatus: 'Required',
          status: 'Pending',
          risk: 'High',
        ),
        ComplianceCase(
          id: 'TCA-2025-0851',
          project: 'NH-72 Widening',
          district: 'Haridwar',
          areaType: 'Protected Zone',
          ecStatus: 'Granted',
          status: 'Compliant',
          risk: 'Medium',
        ),
        ComplianceCase(
          id: 'TCA-2025-0856',
          project: 'Mining Access Road',
          district: 'Almora',
          areaType: 'Reserve Forest',
          ecStatus: 'Required',
          status: 'Violation',
          risk: 'Very High',
        ),
      ];
}
