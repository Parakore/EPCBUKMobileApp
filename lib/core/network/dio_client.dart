import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioClient {
  late final Dio _dio;
  final _logger = Logger();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.utcms.gov.in/v1', // Placeholder base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger
              .d('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger
              .e('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get instance => _dio;
}

// Global provider-like singleton for simplicity in core
final dioClient = DioClient();
