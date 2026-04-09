import 'package:dio/dio.dart';
import '../model/report_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

class ReportsRepository {
  final Dio dio;

  ReportsRepository(this.dio);

  Future<ReportModel> getReportsData() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockReportData;
    }

    try {
      final response = await dio.get(ApiEndpoints.analytics);
      return ReportModel.fromJson(response.data);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  static ReportModel get _mockReportData => ReportModel(
        monthlyVolume: [
          ChartDataPoint(label: 'Apr', value: 110, value2: 95),
          ChartDataPoint(label: 'May', value: 140, value2: 130),
          ChartDataPoint(label: 'Jun', value: 80, value2: 170),
          ChartDataPoint(label: 'Jul', value: 120, value2: 135),
          ChartDataPoint(label: 'Aug', value: 85, value2: 70),
          ChartDataPoint(label: 'Sep', value: 190, value2: 125),
        ],
        districtWise: [
          ChartDataPoint(label: 'Dehradun', value: 230),
          ChartDataPoint(label: 'Haridwar', value: 150),
          ChartDataPoint(label: 'Nainital', value: 200),
          ChartDataPoint(label: 'Tehri', value: 200),
        ],
        stageDistribution: [
          ChartDataPoint(label: 'Submitted', value: 15),
          ChartDataPoint(label: 'Field Survey', value: 12),
          ChartDataPoint(label: 'Verification', value: 18),
          ChartDataPoint(label: 'Completed', value: 45),
        ],
        speciesCompensation: [
          ChartDataPoint(label: 'Deodar', value: 48),
          ChartDataPoint(label: 'Teak', value: 38),
          ChartDataPoint(label: 'Sal', value: 33),
          ChartDataPoint(label: 'Oak', value: 25),
        ],
        compensationTrend: [
          ChartDataPoint(label: 'Apr', value: 5.0),
          ChartDataPoint(label: 'May', value: 4.7),
          ChartDataPoint(label: 'Jun', value: 6.0),
          ChartDataPoint(label: 'Jul', value: 3.5),
        ],
        slaPerformance: {
          'Forest Guard': 82,
          'Range Officer': 91,
          'DFO': 78,
          'UKPCB': 85,
          'DM': 88,
          'Treasury': 74,
        },
        treesMonthly: [
          ChartDataPoint(label: 'Apr', value: 560, value2: 1150),
          ChartDataPoint(label: 'May', value: 720, value2: 560),
        ],
        envIndexMonthly: [
          ChartDataPoint(label: 'Apr', value: 63),
          ChartDataPoint(label: 'May', value: 76),
        ],
        campaMonthly: [
          ChartDataPoint(label: 'Apr', value: 31, value2: 28),
          ChartDataPoint(label: 'May', value: 34, value2: 20),
        ],
        paymentFlowMonthly: [
          ChartDataPoint(label: 'Apr', value: 45, value2: 29),
          ChartDataPoint(label: 'May', value: 47, value2: 37),
        ],
      );
}
