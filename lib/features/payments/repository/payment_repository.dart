import 'package:dio/dio.dart';
import '../model/payment_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

class PaymentRepository {
  final Dio dio;

  PaymentRepository(this.dio);

  Future<List<PaymentModel>> getPayments() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockPayments;
    }

    try {
      final response = await dio.get(ApiEndpoints.getPaymentDetails);
      final List<dynamic> data = response.data;
      return data.map((e) => PaymentModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  Future<PaymentSummary> getPaymentSummary() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return _mockSummary;
    }

    try {
      final response = await dio.get(ApiEndpoints.paymentHistory);
      return PaymentSummary.fromJson(response.data);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  static List<PaymentModel> get _mockPayments => [
        PaymentModel(
          id: 'CHL-98441',
          type: 'Timber Compensation',
          amount: 52480.0,
          status: PaymentStatus.paid,
          date: DateTime(2025, 4, 2),
          challanNo: 'CH-25-00389',
        ),
        PaymentModel(
          id: 'CHL-98442',
          type: 'Environmental & NPV',
          amount: 36500.0,
          status: PaymentStatus.pending,
          date: DateTime(2025, 4, 5),
          challanNo: 'CH-25-00412',
        ),
      ];

  static PaymentSummary get _mockSummary => PaymentSummary(
        totalDisbursed: 152480.0,
        pendingAmount: 36500.0,
        totalChallans: 4,
        monthlyTrend: [
          1.2,
          1.8,
          1.4,
          2.1,
          1.9,
          2.4,
          2.1,
          2.8,
          2.5,
          3.2,
          2.9,
          3.5
        ],
        fundAllocation: {
          'CAMPA': 30,
          'Afforestation': 20,
          'NPV': 25,
          'Timber': 18,
          'Admin': 7,
        },
      );
}
