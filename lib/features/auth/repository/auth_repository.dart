import 'package:dio/dio.dart';
import '../model/user_model.dart';

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
    // MOCK API CALL for Step 1
    await Future.delayed(const Duration(seconds: 1));

    if (userId.isEmpty || password.isEmpty) {
      throw Exception('UserId and Password are required');
    }

    // In a real app, we would call an endpoint that sends SMS/Email
    return;
  }

  @override
  Future<UserModel> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    // MOCK API CALL for Step 2
    await Future.delayed(const Duration(seconds: 1));

    if (otp == '123456') {
      return UserModel(
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
}
