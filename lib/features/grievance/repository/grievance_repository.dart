import 'package:dio/dio.dart';
import '../model/grievance_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

class GrievanceRepository {
  final Dio dio;

  GrievanceRepository(this.dio);

  Future<List<Grievance>> getGrievances() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockGrievances;
    }

    try {
      final response = await dio.get(ApiEndpoints.grievance);
      final List<dynamic> data = response.data;
      return data.map((e) => Grievance.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  static List<Grievance> get _mockGrievances => [
        Grievance(
          id: 'GRV-084',
          date: '22 Mar 2025',
          category: 'Application Delay',
          status: 'Open',
          priority: 'High',
          subject: 'Delay in site inspection',
          description: 'Forest guard has not visited the plot since 2 weeks.',
        ),
        Grievance(
          id: 'GRV-082',
          date: '18 Mar 2025',
          category: 'Payment Issue',
          status: 'Resolved',
          priority: 'Medium',
          subject: 'Double payment debited',
          description: 'Payment of ₹1,24,000 debited twice from my bank.',
        ),
      ];
}
