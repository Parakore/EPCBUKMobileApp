import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ApiException extends NetworkException {
  ApiException({required super.message, super.statusCode});
}

class AuthException extends NetworkException {
  AuthException({required super.message, super.statusCode});
}

class ServerException extends NetworkException {
  ServerException({required super.message, super.statusCode});
}

class NetworkErrorHandler {
  static NetworkException handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(message: 'Connection timed out. Please check your internet.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final data = error.response?.data;
          String message = 'Something went wrong';
          
          if (data is Map && data.containsKey('message')) {
            message = data['message'];
          }

          if (statusCode == 401 || statusCode == 403) {
            return AuthException(message: message, statusCode: statusCode);
          } else if (statusCode != null && statusCode >= 500) {
            return ServerException(message: 'Internal Server Error', statusCode: statusCode);
          }
          return ApiException(message: message, statusCode: statusCode);
        case DioExceptionType.cancel:
          return NetworkException(message: 'Request cancelled');
        case DioExceptionType.connectionError:
          return NetworkException(message: 'No internet connection');
        default:
          return NetworkException(message: 'An unexpected error occurred');
      }
    }
    return NetworkException(message: error.toString());
  }
}
