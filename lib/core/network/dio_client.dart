import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class NetworkClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  NetworkClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.forest-management.com/v1/', // Mock URL
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
