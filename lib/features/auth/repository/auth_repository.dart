import 'package:dio/dio.dart';
import '../model/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({
    required String role,
    required String userId,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<UserModel> login({
    required String role,
    required String userId,
    required String password,
  }) async {
    // [STRICT] MOCK API CALL
    await Future.delayed(const Duration(seconds: 2));

    if (userId == '123456' && password == 'password') {
      return UserModel(
        id: 'user_1',
        name: 'Forest Officer',
        email: 'officer@forest.gov.in',
        role: role,
        token: 'mock_jwt_token_xyz',
      );
    } else {
      throw Exception('Invalid User ID or Password');
    }
  }
}
