import 'package:dio/dio.dart';
import 'package:epcbuk_mobile_app/features/auth/model/user_model.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/constants/api_constants.dart';

abstract class AuthRepository {
  Future<void> sendOtp({
    required String role,
    required String userId,
    required String password,
  });

  Future<UserModel> verifyOtp({
    required String userId,
    required String otp,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  AuthRepositoryImpl(this.dio);

  @override
  Future<void> sendOtp({
    required String role,
    required String userId,
    required String password,
  }) async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      if (userId.isEmpty || password.isEmpty) {
        throw Exception('UserId and Password are required');
      }
      return;
    }

    try {
      await dio.post(
        ApiEndpoints.sendOtp,
        data: {
          'role': role,
          'user_id': userId,
          'password': password,
        },
      );
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    if (ApiConstants.useMockData) {
      await Future.delayed(
          const Duration(seconds: ApiConstants.mockDelaySeconds));
      if (otp == '123456') {
        return const UserModel(
          id: 'user_1',
          name: 'Forest Officer',
          email: 'officer@forest.gov.in',
          role: 'Forest Officer',
          token: 'mock_jwt_token_xyz',
        );
      } else {
        throw Exception('Invalid OTP. Please try again.');
      }
    }

    try {
      final response = await dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'user_id': userId,
          'otp': otp,
        },
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw NetworkErrorHandler.handle(e);
    }
  }
}
