import 'package:dio/dio.dart';
import '../model/verification_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

abstract class VerificationRepository {
  Future<List<VerificationModel>> getPendingVerifications();
  Future<bool> verifyApplication(String id, bool approved);
}

class VerificationRepositoryImpl implements VerificationRepository {
  final Dio dio;

  VerificationRepositoryImpl(this.dio);

  @override
  Future<List<VerificationModel>> getPendingVerifications() async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return List.generate(10, (index) => VerificationModel.mock(index));
    }

    try {
      final response = await dio.get(ApiEndpoints.valuationApprovalsQueue);
      final List<dynamic> data = response.data;
      return data.map((e) => VerificationModel.fromJson(e)).toList();
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<bool> verifyApplication(String id, bool approved) async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      return true;
    }

    try {
      await dio.post(
        ApiEndpoints.rejectOrApprove(id),
        data: {'status': approved ? 'approved' : 'rejected'},
      );
      return true;
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }
}
